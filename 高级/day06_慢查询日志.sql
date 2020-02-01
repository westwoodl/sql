/*
	MySQL默认关闭慢查询日志，对性能会有影响，不是为了调优，不建议开启
	MySQL 8 为开启的
*/
-- 开启慢查询日志
show variables like '%slow_query_log%';
set global slow_query_log = 1; -- 如需永久生效，修改配置文件my.cnf
-- 慢查询日志时间阈值
show global variables like 'long_query_time%';
set global long_query_time = 3;
-- 查看多少慢查询
show global status like '%slow_queries%';

-- mysqldumpslow

/*
	-- 复习批量数据脚本，函数和存储过程
*/

/*
 	show profile
 */
show variables like '%profiling%';
set profiling = 1;

show profile;
show profile cpu, block io for query 1;
/*
	表中status字段所给出的信息：
		出现如下信息，证明sql不好：
			1. converting heap to MyISAM 查询结果太大，内存都不够用了往磁盘上搬
			2. creating tmp table 创建临时表：1.拷贝数据到临时表中 2.用完在删除
			3. copying to tmp table on disk 将临时表拷贝到磁盘上
			4. lock


*/

-- 查询全局日志
set global general_log = 1;
set global log_output = 'TABLE'
select * from mysql.general_log

