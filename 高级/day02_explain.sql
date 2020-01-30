/*
 sql分析，explain下的字段解释haha
 1.id为优先级(越大越高)，相同优先级按顺序执行
 2.select_type:
    Derive衍生查询：在FROM列表中包含的子查询被标记为 DERIVED(行生)MYSQL会递归执行这些子查询,把结果放在临时表里。
    primary主查询
    subquery子查询
    union联合查询：若第二个 SELECT出现在 UNION之后,则被标记为 JNION若 UNION包含在FROM子句的子查询中,外层 SELECT将被标记为: DERIVED
    union result：
 3.type：显示了查询使用了何种类型
    system：单表且一行数据
    const：表示通过素引一次就找到了, const用于比较 primary key:或者 unique素引。因为只匹配一行数据,所以很快如将主键置于 where列表中,MSL就能将该查询转换为一个常量
            explain select * from book_copy2 where id = 1;
    eq_ref：唯一性索引扫描,对于每个素引键,表中只有一条记录与之匹配。常见于主键或唯一索引扫描
            explain select * from user left join user_role on user.userid = user_role.userid;
    ref：非唯一性索引（多值索引）扫描,返回匹配某个单独值的所有行本质上也是一种索引访问,它返回所有匹配某个单独值的行,然而它可能会找到多个符合条件的行,所以他应该属于查找和扫描的混合体
    range：只检素给定范围的行,使用一个索引来选择行。key列显示使用了哪个索引般就是在你的 where语句中出现了 between、<、>、in等的查询这种范围扫描素引扫描比全表扫描要好,为它只需要开始于素引的某一点,而结東语另一点,不用扫描全部素引
    index：Full Index Scan, index与ALL区别为 index类型只遍历索引树。这通常比ALL快,因为索引文件通常比数据文件小(也就是说虽然all和index都是读全表,但 index是从s索引中读取的,而all是从硬盘中读的)
    ALL：全表扫描


 4.possible_keys：mysql觉得可能应用在这张表中的素引,一个或多个。查询涉及到的字段上若存在索引,则该索引将被列出,但不一定被查询实际使用
 5.keys：实际使用的索引
 6.key_len：表示索引中使用的字节数,可通过该列计算查询中使用的索引的长度。在不损失精确性的情况下key越短月好。len显示的值为索引字段的最大可能长度,并非实际使用长度,即 key_len是根据表定义计算而得
 7.ref：显示使用了那些索引字段
 8.row：扫描行数
 9.extra：
    a) using where
    b) using index 
    c) using filesort (无法用索引完成的排序称为文件排序
    d) using temporary 使了用临时表保存中间结果,MySQL在对查询结果排序时使用临时表。常见于排序 order by和分组查询 group by
        推荐group by为索引字段，临时表是非常好性能的
    f) using join buffer
    g) distinct
    ...
 
 */

explain select * from user, user_role where user.userid not in  (select id from book_copy2);
explain select * from book_copy2 where id = 1;
explain select * from book_copy2 where price = 100;
alter table book_copy2 modify id int primary key ;


CREATE TABLE IF NOT EXISTS article (
    id INT (10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    author_id INT (10) UNSIGNED NOT NULL,
    category_id INT (10) UNSIGNED NOT NULL,
    views INT ( 10 ) UNSIGNED NOT NULL,
    comments INT ( 10 ) UNSIGNED NOT NULL,
    title VARBINARY ( 255 ) NOT NULL ,
    content TEXT NOT NULL

);
    
    INSERT INTO article ( author_id , category_id , views , comments , title , content ) 
    VALUES(1,1,1,1,'1','1'),(2,2,2,2,'2','2'),(1,1,3,3,'3','3');


    /*
复合索引的最左原则
    */