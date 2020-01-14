/*
 函数 (mysql的设置默认是不允许创建函数)
    和存储过程很相似
    区别：函数有且仅有一个返回，适合做处理数据后返回一个结果
 */

# 创建语法
    /*
        create function function_name(参数列表) returns 返回类型
        begin

                函数体

            return 返回值
        end;
    */
SET GLOBAL log_bin_trust_function_creators = 1;
create function authenticationFunction(username varchar(10), userpwd varchar(50)) returns int
begin
    declare result int default 0;
    select count(user.userid) into result
    from user where user.userpwd = userpwd and user.username = username;
    return result;
end;

drop function if exists plus;
create function plus(a float, b float) returns float return a + b;

select plus(100.9912,100.102);
# 调用语法
select authenticationFunction('zhangsan','130dd1561e22fa4c07d6c19e8ef02efa');

# 查看函数
show create function authenticationFunction;

# drop
drop function authenticationFunction;