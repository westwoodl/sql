/*

多表关联时，在“从表”上加索引
	左连接 右表建索引 （因为左边的元素都有，选择性的选取右边的元素）
	左连接 右表建索引

覆盖索引：
	覆盖索引必须要存储索引的列，而哈希索引、空间索引和全文索引等都不存储索引列的值，
	所以MySQL只能使用B-Tree索引做覆盖索引 （B-树保存了值）

如何避免索引失效：
	1.（全值匹配）
	2.复合索引的最左原则：复合索引时，查询的字段顺序必须要按复合索引的顺序，
	3.不在索引列上做任何操作(计算、函数、(自动or手动)类型转换),会导致索引失效而转向全表扫描
	4.存储引擎不能使用索引中范围条件右边的列口
	5.尽量使用覆盖索引(只访问索引的查询(索引列和查询列一致),减少 select*
	6.mysql在使用不等于(=或者<>)的时候无法使用索引会导致全表扫描
	7.is null is not null 1也无法使用索引
	8.like以通配符开头(%abc…)mysq索引失效会变成全表扫描的操作， "abc%"可以使用到索引
		解决两边百分号索引失效的问题：使用覆盖索引解决（查询字段写有索引的字段）。
		extra显示 Using index condition 说明有回表查询
		我总不可能每个字段都去建索引吧,目前能想到的时候把那种like查询的字段建上索引连同主键一起查出来,然后做二次查询，
	（范围失效：>会导致后面的索引失效，但是'abc%'的like不会导致后面的失效）
	9.字符串不加单引号索引失效，避免字符类型隐式转换
	10.少用or,用它来连接时会索引失效

	注意：order by 也是可以需要索引的，也是属于顺序的其中
*/

/*
mysql 自动优化 ：
	create index idx_test03_c1234 

	explain select * from test03 where c1='1' and c2='2' and c3='3' and c4='4'; 和
	explain select * from test03 where c1='1' and c2='2' and c4='4' and c3='3'; 效果一样

	当然
	explain select * from test03 where c1='1' and c2='2' and c3>'3' and c4='4'; c4索引失效
	explain select * from test03 where c1='1' and c2='2' and c4>'4' and c3='3'; 索引没有失效，使用了4个索引 type:range


	c3的作用在于排序而不是查找
	explain select * from test03 where c1='1' and c2='2' and c4='4' order by c3;
	explain select * from test03 where c1='1' and c2='2' order by c3; 效果一样 

	explain select * from test03 where c1='1' and c2='2' order by c4; using filesort效果差


	explain select * from test03 where c1='1' and c2='2' order by c4,c3; 出现了filesort
	explain select * from test03 where c1='1' and c2='2' order by c3,c2; 没有出现filesort，c2已经是个常量

	explain select * from test03 where c1='1' and c4='4' group by c2,c3;
	explain select * from test03 where c1='1' and c4='4' group by c3,c2; 使用了 filesort, temporary
	关于group by：
		group by基本上都需要进行排序，会有临时表产生

	where / group by / order by 按顺序来


例题：
	Where语句								索引是否被使用Y使用到
	a=3 and b=5									Y,使用到a,b
	where a=3 and b=5 and c=4					Y,使用到a,b,c
	where b=3 or where b=3 and c=4 or where c=4 N
	where a =3 and c= 5							使用到a,但是c不可以,b中间断了
	where a=3 and b>4 and c=5					使用到a和b,c不能用在范围之后,b断了
	where a= 3 and b like 'kk%' and c= 4		Y,使用到a,b,c
	where a=3 and b like '%kk' and c= 4			Y,只用到a
	where a=3 and b like '%kk%' and c= 4		Y,只用到a
	where a= 3 and b like 'k%kk%' and c= 4		Y,使用到a,b,c




*/
