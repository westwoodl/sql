# 事务控制语言
show engines;
show variables like 'autocommit'; -- 自动提交默认为开启

/*
 ACID:
    atomicity
    consistency 数据库必须由一个一致性状态转化成另一个一致性状态
    isolation 隔离级别 (解决多个事务操作同一数据库的并发问题)
        read uncommit（读未提交）没有隔离级别，可以读取未提交的事务的数据
        read commit（读已提交 解决脏读）一个事务不会读取到其他事务未提交的数据
        repeatable read（可重复读 解决不可重复读）一个事务在多次读取时，读取的都是一样的数据（即最初读取到的数据）
                    (多个事务都在修改时，时会有表锁)
        serializable （执行一个事务时，禁止其他事务更新、删除、添加数据）
    durability 持久
 */
/*
set autocommit = 0;
start transaction ;
-- 增删改查 （DML与事务无关）
commit;    -- 提交事务
rollback ; -- 回滚
*/
-- 事务
set autocommit =0;
start transaction ;
insert book_copy2(id, bName, price, authorid, publish_date) value
    (2, '百年孤独',12,23,str_to_date('2012-12-03 09:00:00','%Y-%m-%d %H:%i:%s'));
update book_copy2 set price = price * 10 where id = 2;
commit ;

-- 查询/设置事务隔离级别
select @@transaction_isolation;
set transaction isolation level read uncommitted ;
set transaction isolation level read committed ;
set transaction isolation level repeatable read ;-- mysql默认
set transaction isolation level serializable ;

-- save point 回滚点
set autocommit = 0;
start transaction ;
delete from book_copy2 where id = 7;
savepoint a;
delete from book_copy2 where id = 6;
rollback to a;

 -- delete可以回滚，但是truncate不能回滚
