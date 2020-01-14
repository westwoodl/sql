select * from user;
select * from user_role;
select *from role;
-- 插入 select * from user;
insert into user (userid, username, userpwd, sex, address) values(3, 'xrc', '123', '男', '南昌'), (5, 'xrc', '123', '男', '南昌');

-- 修改
update user set userpwd = MD5(userpwd) where user.userid=4;
update user u, role r set userpwd = MD5(userpwd), r.rolename = concat(r.rolename, '1') where u.userid=5 and r.roleid=1;

-- 删除
delete from user where userpwd like '%123%';-- 单表删除
delete u, ur from user u inner join user_role ur on u.userid = ur.userid where u.userid=4; -- 多表删除
delete u from user u inner join user_role ur on u.userid = ur.userid where u.userid=4; -- 多表删除
truncate user; -- 数据全部删除  自增的值从1开始 truncate不能回滚，delete可以回滚