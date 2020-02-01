-- 一、表锁（偏读）MyISAM
-- 加锁
lock table table_name read; -- 读锁 当前session: 只可以读自己，写自己报错，读写别的表报错。其他session：只可以读被锁的表，修改会被阻塞。
lock table table_name write; -- 写锁 当前session: 对锁定表的查询+更新+插入都可以，对其他表crud报错。 其他session：对锁定表crud 阻塞。
-- 简而言之，就是读锁会阻塞写，但是不会阻塞读。而写锁会阻塞读写

-- 解锁
unlock tables;


/*
	表锁分析：
*/
show open tables;

-- 二、行锁（偏写）InnoDB：开销大，加锁慢；会出现死锁，锁定粒度最小，发生锁冲突的概率最低，并发度最高
-- mysql的默认事务隔离级别 不可重复读 使用的就是行锁

/*
	无索引行锁变表锁
	索引失效导致行锁变表锁
*/
/*
	间隙锁的危害：
		当我们用范围条件而不是相等条件检索数据,并请求共享或排他锁时, 
		Innodb会给符合条件的已有数据记录的索引项加锁;对于键值在条件范围内但并不存在的记录,叫做“间隙(GAP)”,
		如：a > 1 and a < 10;会将范围内的所有数据都加锁，即使实际数据中不存在

*/
-- 给特定行加锁
begin;
select * from test_innodb_lock where a = 8 for update;
/*....*/
commit;

show status like 'innodb_row_lock%';
/*
	innodb_ row lock_current_waits:当前正在等待锁定的数量;
	innodb_row_ lock_time:从系统启动到现在锁定总时间长度
	nodb_row_ lock_time_avg:每次等待所花平均时间
	innodb_row_ lock_time_max:从系统启动到现在等待最常的一次所花的时间
	nodb_row_lock_ waits:系统启动后到现在总共等待的次数
*/


/*
	锁的使用建议：
		1.尽可能所有数据检索都通过索引完成，避免误索引行锁升级为表锁
		2.合理设计索引，尽量缩小锁的范围
		3.尽可能较少检索条件，避免间隙锁
		4.尽量控制事务大小，减少锁定资源量和时间长度
		5.尽可能低级别事务隔离


*/