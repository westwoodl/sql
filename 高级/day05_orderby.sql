/*

在排序时使用索引
order by:
MySQL支持两种方式的排序：1.Index 2. file sort。 index效率高，它指MySQL扫描索引本身完成排序。filesort效率较低
所以在extra中避免出现file sort

	index(age, brith)
	select * from table where age > 20 order by age;
	select * from table where age > 20 order by brith;  -- 使用了file sort

	order by 满足两种情况，会使用index方式排序：
		1.order by使用索引最左前列 ---------------------------------------------> 重点
		2.使用where子句与order by子句条件列组合满足索引最左前列------------------->

如果不在索引列上，filesort有两种算法：
	1.双路排序
	2.单路排序 4.1之后默认，但是如果数据大于sort_buffer ，性能会下降，变成多路排序
	select * 对sort_buffer不太友好

例子：key （a,b,c）
	可以使用的情况：
		order by a,b,c
		order by a desc, b desc, c desc
		where a = const and b > const order by b,c
	不能使用的情况：
		order by a asc, b desc, c desc -- 排序不一致
		order by b,c
		order by a,d
		where a in (...) order by b,c

group by:
	和order by差不多
	1. group by 实质是先排序后进行分组，遵照索引建的最佳左前缀
	2.当无法使用索引列，增大max_lengh_for_sort_data的参数设置+增大sort_buffer_size参数的设置
	3.where高于having，能写where限定的条件就不要写having限定
*/