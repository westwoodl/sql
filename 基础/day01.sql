select *
from role;


select role.roleid as ROLE_ID, role.rolename as ROLE_NAME, perid
from role
         join permission_role pr on role.roleid = pr.roleid
where perid = 1;

-- like
select * from user where username like '%a%';

-- between
select *
from role
where roleid between 1 and 3;

-- in
select *
from user
where username in ('1', '2', '3');
-- 比or简单，效率一样

-- is null
select *
from user
where username is not null;
-- = 或者<>不能用来判断null

-- 安全等于 <=>
select *
from user
where username <=> null;


-- 先按hh降序，（hh相同再按usename升序）
select *,userid * 10 hh,username + '=' as '用户名'
from user
order by hh desc, LENGTH(username) asc;

