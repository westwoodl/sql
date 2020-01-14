-- 数据定义语言

-- 建库
create database if not exists gobang;
alter database character set 'ut-8';
create table book (
    id int,
    bName varchar(20),
    price double,
    authorid int,
    publishdate datetime
);
create table author(
    id int,
    au_name varchar(10),
    nation varchar(10)
);

-- 表的修改
alter table book change /* column */ publishdate publish_date datetime; -- 修改表名
alter table book modify /* column */ publish_date timestamp; -- 修改列类型或约束
alter table book add /* column */ book_type varchar(10); -- 添加新列
alter table book drop /* column */ book_type; -- 删除列
alter table book rename to books; -- 修改表名


-- 表的删除
drop table  if exists book;

-- 表的复制
insert into books(id, bName, price, authorid, publish_date)
values (1,'人生的智慧',22,1,str_to_date('2019-12-4 11:45:15','%Y-%m-%d %H:%i:%s'));
create table book_copy like books; -- 复制表结构
create table if not exists book_copy2 select id, bName, price, authorid from books where id=1;

-- 数据类型
/*
 数值型：
    整型：tinyint（1byte）、smallint（2byte）、mediumint（3byte）、int（4byte）、int unsigned 无符号整型、bigint（8byte）
    小数：
        定点数：dec(M, D)、decimal(M, D) （精度较高）
        浮点数：float(M, D) （4byte）、double(M, D)（8byte）。（M:整数部分，D:小数部分）
 字符型：
    短文本：char(M) （字符数为0~255之间的整数，效率高、定长、消耗空间）、varchar(M)（字符数为0~65535，效率低、不定长、节省空间） （M:字符数）
    长文本：text、blob（较长的二进制数据）
 二进制：
    binary：
    varbinary：
 日期型：
    date（4byte 1000-01-01 ~ 9999-12-31）
    datetime（8byte 1000-01-01 00:00:00 ~ 9999-12-31 23:59:59）---- 日期
    timestamp（4byte 19700101080001 ~ 2038年的某个时刻）       ------ 时间戳
    time （3byte -838:59:59 ~ 838:59:59）
    year（1byte 1901 ~ 2155）

 枚举类型：
    create table test_emum (sex enum('男', '女'));
 集合类型
    set(element1, element2) （和枚举类似，但可以同时插入多个element）

 */

-- 约束
/* 六大约束
 1.not null 2.default 3.primary key
 4.unique (唯一，但可以为空) 5.check(mysql没效果)
 6.foreign key
   列级约束：六大都能写，但是foreign key没用
   表级约束：除了not null, default都可以
 */
create table xxx (
    xxx_id int primary key ,
    xxx_name varchar(10) not null default 'xxx_name',
    gender char(1) check ( gender='man' or gender='woman' ),
    seat int unique,
    roleid int references role(roleid), -- 没用
    /*constraint nn */check ( seat=1 or seat=2 ),
    constraint fk foreign key (roleid) references role(roleid)
);
drop table if exists xxx;
show index from xxx;-- 主键和唯一会建索引，主键只能有一个，唯一键可以有多个
/*外键：
    一般是其他表的主键或者唯一键。
  删除时：先删除从表，再删除主表
  插入时：先插入主表，在插入从表
*/

-- 修改表时添加约束
alter table xxx modify seat int unique ; -- 列级约束
alter table user modify userid int auto_increment; -- 修改主键为自增，主键属性依然存在
alter table xxx add primary key (xxx_id); -- 表级约束
alter table xxx modify xxx_id int;
alter table xxx drop primary key ; -- 删除主键约束
alter table xxx drop foreign key fk;

-- 标识列(自增列) 必须是一个key，一个表只能一个，类型数值型
drop table if exists yyy;
create table yyy (
  yyy_id int primary key ,
  yyy_row int unique auto_increment
);
show variables like '%auto_increment%';

alter table yyy modify yyy_id int primary key auto_increment;