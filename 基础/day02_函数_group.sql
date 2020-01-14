-- 常见函数
    -- 单行函数：字符、日期、数学、流程控制函数

select LENGTH('徐荣超xrc');-- 获取字节长度
show variables like '%char%';
select concat('_', 'f', 'u', 'c', 'k');-- 拼接字符串
select upper('sLJSALKjdskajd') 'sad大写', lower('aksjdkaAJSKjfa') 'as小写';-- upper lower
select SUBSTR('徐荣超sdsadsd',1,4); -- 截取
select SUBSTR('徐荣超sdsadsd',2);
select CONCAT(upper(substr(username,1,1)),'_',substr(username,2)) from user ;-- 首字母小写
select instr('assadasddsda','da');-- 出现的第一次索引
select trim('      askjklsajk    ');-- trim
select trim('a' from  'aaaaaaaaaaaaaaaaaaa哈aaahaaaa');-- trim
select lpad('徐荣超', 10, '*');-- lpad 左填充指定长度
select replace('张无忌忌','忌','鸡');-- 全部替换

-- 数学函数
select round(4.5); -- 四舍五入
select ceil(-1.1);-- 向上取整
select floor(-9.99);-- 向下取整
select truncate(1.69999, 1); -- 小数点后
select mod(10, -3); -- 取余 a-a/b*b

-- 日期函数
select now();-- 精确到秒
select curdate();
select curtime();
select year(now()) 年, month(now()) 月, day(now()) 日, second(now()) 秒;
select str_to_date('1998-3-2', '%Y-%c-%d'); -- 字符转日期
select date_format(now(), '%Y年 %c月 %d日');

-- 其他函数
select version();
select database();
select user();

-- 流程函数
select if(10>5, '大_is true', '小_is false') as result; -- if
select case date_format(now(), '%y') when 18 then '一八' when 19 then '一九' else '唉' end; -- switch else可以省略
select case when 1<-1 then 'one' when 1=2 then 'two' when 1=1 then 'three'else 'four' end; -- 多条件 else可以省略

-- 分组（统计）函数 和分组函数同一查询的只能是group by
select sum(userid), sum(distinct userid) from user; -- 忽略null
select avg(userid) from user; -- 忽略null
select min(username) from user; -- 忽略null
select max(userid) from user; -- 忽略null
select count(distinct sex) from user; -- 忽略null
select count(null   ) from user;
select *,max(userid) from user;

-- 分组查询 where：原表筛选 having：结果集筛选 （分组前筛选更好）
select username,max(userid) from user where userid is not null group by username having max(userid) < 5;-- 每个部门的平均工资。。(having:最大工工资<5)
select max(user.userid) from user where userid = 1;
select avg(userid) from user group by userpwd;