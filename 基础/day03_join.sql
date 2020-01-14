-- 连接查询
select * from role inner join permission_role pr on role.roleid = pr.roleid; -- 内连接
select * from role left join permission_role pr on role.roleid = pr.roleid left join permission p on pr.perid = p.perid;

-- 子查询
select * from role where roleid > (select roleid from permission_role where perid = 1);
select * from role where roleid in (select roleid from permission_role where perid = 1);
select * from role where roleid > all (select roleid from permission_role where perid = 1);
select * from role where roleid > any (select roleid from permission_role where perid = 1);
select * from role where roleid > some (select roleid from permission_role where perid = 1);
select *,(select max(role.roleid) from role) from role r;
select * from (select * from role ) a; -- from 后面必须起别名
select rolename from role where exists (select * from role where roleid > 2); -- 单个字段

-- 分页查询 limit offset, size ;（offset起始索引，size显示多少条）；写语句的最后面
select * from role order by roleid desc limit 1;

-- DQL 的书写顺序和执行顺序
select 查询列表              7
from 表                     1
连接类型 join 表2            2
on 连接条件                  3
where 筛选条件               4
group by 分组列表            5
having 分组后筛选            6
order by 排序列表            8
limit 偏移, 条目数           9

-- 联合查询：两个需要联合的结果集，字段必须都要一样
select * from user union select * from user; -- 去重
select * from user union all select * from user; -- 不去重