/*
小表驱动大表：（小表先执行）
	当B表小于A表时
	select * from A where id in (select id from B)
	当A表小于B表时
	select * from A where exists (select 1 from B where B.id = A.id) // 先执行A


*/