MySQL主从复制如何保证数据一致性？



如何保证MySQL主从数据的一致性。MySQL主从复制原理直白一点来说，就是master写入数据时会留下写入日志，slave根据master留下的日志模仿其数据执行过程进行数据写入。了解了MySQL主从复制的原理，可以清楚的了解到，有两个步骤可能导致主从不一致：

  1、mater日志写入不成功导致slave不能正常模仿。
  2、slave根据master日志模仿时写入不成功。
今天我们就从这两个维度去解决主从不一致的问题。

一、保证MySQL（master端）日志和数据的统一性，处理掉电、宕机等异常情况。
多哔哔几句：
1、MySQL作为一个可插拔的数据库系统，支持插件式的存储引擎，在设计上分为Server层和Storage Engine层。
2、在Server层，MySQL以events的形式记录数据库各种操作的Binlog二进制日志，其基本核心作用有：复制和备
  份。除此之外，我们结合多样化的业务场景需求，基于Binlog的特性构建了强大的MySQL生态，如：DTS、单元化、
  异构系统之间实时同步等等，Binlog早已成为MySQL生态中不可缺少的模块。
3、在Storage Engine层，InnoDB作为比较通用的存储引擎，其在高可用和高性能两方面作了较好的平衡
  ，早已经成为使用MySQL的首选（PS：官方从MySQL 5.5.5开始，将InnoDB作为了MySQL的默认存储引擎 ）。
  和大多数关系型数据库一样，InnoDB采用WAL技术，即InnoDB Redo Log记录了对数据文件的物理更改，并保
  证总是日志先行，在持久化数据文件前，保证之前的redo日志已经写到磁盘。Binlog和InnoDB Redo Log是否  ***
  落盘将直接影响实例在异常宕机后数据能恢复到什么程度。InnoDB提供了相应的参数来控制事务提交时，写日
  志的方式和策略，例如：

innodb_flush_method:控制innodb数据文件、日志文件的打开和刷写的方式，建议取值：fsync、O_DIRECT。
innodb_flush_log_at_trx_commit:控制每次事务提交时，重做日志的写盘和落盘策略，可取值：0，1，2。
当innodb_flush_log_at_trx_commit=1时，每次事务提交，日志写到InnoDB Log Buffer后，会等待Log Buffer中的日志写到Innodb日志文件并刷新到磁盘上才返回成功。
sync_binlog：控制每次事务提交时，Binlog日志多久刷新到磁盘上，可取值：0或者n(N为正整数)。
不同取值会影响MySQL的性能和异常crash后数据能恢复的程度。当sync_binlog=1时，MySQL每次事务提交都会将binlog_cache中的数据强制写入磁盘。
innodb_doublewrite：控制是否打开double writer功能，取值ON或者OFF。
当Innodb的page size默认16K，磁盘单次写的page大小通常为4K或者远小于Innodb的page大小时，发生了系统断电/os crash ，刚好只有一部分写是成功的，则会遇到partial page write问题，从而可能导致crash后由于部分写失败的page影响数据的恢复。InnoDB为此提供了Double Writer技术来避免页断裂(partial write)的发生。
innodb_support_xa:控制是否开启InnoDB的两阶段事务提交.默认情况下，innodb_support_xa=true，支持xa两段式事务提交。
通过以上哔哔，我们得出以下配置：

#以下配置保证bin-log写入后事务提交流程会变成两阶段提交，这里的两阶段提交并不涉及分布式事务，mysql把它称之为内部xa事务
innodb_support_xa=ON
#以下配置能够保证不论是MySQL Crash 还是OS Crash 或者是主机断电重启都不会丢失数据
innodb_doublewrite=ON
#以下配置保证每次事务提交后，都能实时刷新到磁盘中，尤其是确保每次事务对应的binlog都能及时刷新到磁盘中，只要有了binlog，InnoDB就有办法做数据恢复，不至于导致主从复制的数据丢失
innodb_flush_log_at_trx_commit = 1
sync_binlog = 1
mysql配置
二、保证MySQL（slave端）同步时和master端保持一致。
1、异步复制
主库在执行完客户端提交的事务后会立即将结果返给给客户端，并不关心从库是否已经接收并处理，这样就会有一个问题，主如果crash掉了，此时主上已经提交的事务可能并没有传到从库上，如果此时，强行将从提升为主，可能导致“数据不一致”。早期MySQL(5.5以前)仅仅支持异步复制。

2、半同步复制
MySQL在5.5中引入了半同步复制，主库在应答客户端提交的事务前需要保证至少一个从库接收并写到relay log中，半同步复制通过rpl_semi_sync_master_wait_point参数来控制master在哪个环节接收 slave ack，master 接收到 ack 后返回状态给客户端，此参数一共有两个选项 AFTER_SYNC & AFTER_COMMIT。

rpl_semi_sync_master_wait_point=WAIT_AFTER_COMMIT
rpl_semi_sync_master_wait_point为WAIT_AFTER_COMMIT时，commitTrx的调用在engine层commit之后，即在等待Slave ACK时候，虽然没有返回当前客户端，但事务已经提交，其他客户端会读取到已提交事务。如果Slave端还没有读到该事务的events，同时主库发生了crash，然后切换到备库。那么之前读到的事务就不见了，出现了数据不一致的问题。如果主库永远启动不了，那么实际上在主库已经成功提交的事务，在从库上是找不到的，也就是数据丢失了。

PS：早在11年前后，阿里巴巴数据库就创新实现了在engine层commit之前等待Slave ACK的方式来解决此问题。

3、全同步复制
MySQL官方针对上述问题，在5.7.2引入了Loss-less Semi-Synchronous，在调用binlog sync之后，engine层commit之前等待Slave ACK。这样只有在确认Slave收到事务events后，事务才会提交。

rpl_semi_sync_master_wait_point=WAIT_AFTER_SYNC
在after_sync模式下解决了after_commit模式带来的数据不一致的问题，因为主库没有提交事务。但也会有个问题，当主库在binlog flush并且binlog同步到了备库之后，binlog sync之前发生了abort，那么很明显这个事务在主库上是未提交成功的（由于abort之前binlog未sync完成，主库恢复后事务会被回滚掉），但由于从库已经收到了这些Binlog，并且执行成功，相当于在从库上多出了数据，从而可能造成“数据不一致”。

此外，MySQL半同步复制架构中，主库在等待备库ack时候，如果超时会退化为异步后，也可能导致“数据不一致”。

三、备注&解决方案（以上解决思路可以满足99.8%公司的业务场景）
1、通过以上两点的分析和配置，我们发现MySQL自身的Repliaction已经无法满足我们爱钻牛角尖同学的欲望了（后端的程序员思维都会过于缜密），怎么办？为了保证主从的数据绝对一致性，下面我来提供两个思路（今天有点累，仅仅是思路，具体解决方案请听下回分解）。
2、阿里云自己研发的数据订正平台。
3、PXC数据强一致性解决方案并且支持多主多从哦，缺点是需要向老板申请性能差别不大的机器做集群。