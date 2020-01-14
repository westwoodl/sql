# 变量
/*
 系统变量：
    全局变量
    会话变量
 自定义变量：
    用户变量
    局部变量
 */

-- 默认设置的是session
show global variables ;
show session variables ;
show variables like '%char%';
select @@global.autocommit;
select @@global.tra
set @@global.autocommit = 0; -- 为系统变量赋值
-- 重启会恢复默认

-- 声明并初始化自定义变量
set @xu_var = 'xu';
set @xu_var = 1; -- 弱类型
set @xu_var2 := 'xu';
select @xu_var3:='xu';

select count(1) into @user_count from user;
-- 查看变量
select @user_count;

-- 局部变量 只能在begin end中
create procedure myprocedure_name()
begin
    -- 声明
    declare @xu_varx int default 0;
    -- 赋值
    set @xu_varx1=1;
    set @xu_varx1:=1;
    select @xu_varx1:=1;
end;