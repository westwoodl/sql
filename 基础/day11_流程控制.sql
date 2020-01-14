/*
 begin end 中的流程控制
 */
# 一、分支
# 1. if函数
select if(true, 1, 0);

# 2. case结果
select case date_format(now(), '%y') when 18 then '一八' when 19 then '一九' else '唉' end; -- switch else可以省略
select case when 1 < -1 then 'one' when 1 = 2 then 'two' when 1 = 1 then 'three' else 'four' end; -- 多条件 else可以省略

# 应用在begin end中 (then后面就不是值了，而是语句)
create procedure liucheng(in a int)
begin
    case
        when a<10 then select '个位';
        when a>10 and a < 100 then select '十位';
        when a<0 then select '负数';
        end case; -- *
end;
call liucheng(1);
drop procedure liucheng;

# if多重分支
create function test_if(a int) returns varchar(20)
begin
    if a<10 then return '个位';
    elseif a<0 then return '负数';
    else return 'fuck';
    end if; -- *
end;
select test_if(2);
drop function if exists test_if;

# 二、循环
/*
 分类：while、loop、repeat
 流程控制：
     iterate：continue
     leave：break
 */

# 1.while
alter table user modify userid int auto_increment; -- 添加
drop procedure if exists insert_test;
create procedure insert_test(in looptime int)
begin
    w1: while looptime>0 do
            if looptime > 20 then leave w1;
            end if;
            if looptime%5 = 0 then iterate w1;
            end if;
            insert into user( username, userpwd, sex, address)
            values( concat('username',looptime), 123, '男', null);
            set looptime = looptime - 1;
    end while w1;
end;
call insert_test(10);
select * from user;

# 2.loop
/*
    lable:loop
    loop_list
    end loop lable;
 */

# 3.repeat
/*
    lable:repeat
        loop_list
    until end_condition
    end repeat lable;
 */