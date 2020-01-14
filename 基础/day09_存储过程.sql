/*
 存储过程：一组预先编译好的sql语句的集合，理解成批处理语句
     优点：预编译、封装
     适合批量插入、批量更新
 */

-- 1.创建
    /*
    create procedure procedure_name(parameter)
    begin

    end
    */

    /*
     1.参数列表三部分
        参数模式 参数名 类型
        in username varchar(10)
     2.参数模式：
        in：该参数可以作为入口（需要调用方传值）
        out：该参数可以作为返回值
        inout：该参数既可以作为输入，又可以作为输出
     3.如果存储过程只有一句话，BEGIN END可以省略
        存储过程体中的每条sql语句结尾要求必须加分号。
        存储过程的结尾可以使用delimiter 重新设置
     */

-- 2.调用
    /*
    call procedure_name(paramete);
     */

delimiter $
create procedure myp1()
begin
    insert into book_copy2(id, bName, price) values (10, '石头记', 30);
    /*
     使用存储过程插入上万条
     */
end $;

/*
  创建带in参数的存储过程
 */
delimiter $
 create procedure myp2(in bookname varchar(20))
 begin
     select * from book_copy2 where bName like concat('%', bookname, '%');
 end $

call myp2('头');

drop procedure authentication;
create  procedure  authentication(in username varchar(10), in userpwd varchar(50))
begin
    declare result varchar(2) default '';
    select count(*) into result
    from user where user.username = username and user.userpwd = userpwd;

    select if(result>0, '成功','失败');
end;

call authentication('zhangsan', '130dd1561e22fa4c07d6c19e8ef02efa');

/*
 创建out模式变量，将返回值赋给全局变量
 */

 create procedure myp3(in username varchar(10), out userpwd varchar(50))
 begin
    select user.userpwd into userpwd
    from user where  user.username = username;
 end;

set @pwd = '';
call myp3('lisi', @pwd) ;
select @pwd;

/*
 创建inout
 */
 create procedure myp4(inout a int, inout b int)
 begin
     declare c int ;
    set a=a*a;
    set b=b*b;
    set c = a + b;
 end;
set @m=10;
set @n=20;
call myp4(@m,@n);
select @m,@n;

/*
 删除和查看存储过程
 */
show create procedure myp1;
drop procedure myp1;