create table covid(city varchar(50),days date,cases int);
delete from covid;
insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);

insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);

insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);

insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);

/*Find cities where covid cases are increasing continuosly*/
Select city 
FROM
(
Select city, days, cases 
,DENSE_RANK() over (partition by city order by days) as drnk
,DENSE_RANK() over (partition by city order by cases) as crnk
,DENSE_RANK() over (partition by city order by days)-DENSE_RANK() over (partition by city order by cases) as diff
from covid

)k

GROUP BY CITY 
HAVING COUNT(distinct diff) = 1 and max(diff) = 0
;