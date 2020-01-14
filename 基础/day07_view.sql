-- 视图
create view myv1 as
    -- 表查询语句
    select * from book_copy2 where book_copy2.id = 1 union select * from books;

select * from myv1;
create view myv2 as
    select * from books union select * from book_copy2;

show variables like 'autocommit';

select * from myv2;
create or replace view myv1 as
    select * from book_copy2;
alter view myv1 as
    select * from book_copy2 where book_copy2.id = 1 union select * from books;

drop view myv1;
desc myv1;
show create view myv1;
show create view myv1;

-- 更改视图的数据
/*
 简单的视图允许增删改
 复杂的视图不允许增删改
 */

--