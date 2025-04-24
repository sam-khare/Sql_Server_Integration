create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

SELECT company_id
from 
(
SELECT company_id, user_id, count(distinct language) as cnt
FROM company_users
WHERE language in ('English','German')
group by  company_id, user_id
having count(distinct language) =2
)k

GROUP BY company_id
HAVING COUNT(cnt)>=2
;

SELECT company_id, user_id, language 
,rank() over (partition by company_id,user_id order by language) as rnk

FROM company_users
WHERE language in ('English','German')