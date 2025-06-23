create table business_city (
business_date date,
city_id int
);
delete from business_city;
insert into business_city
values(cast('2020-01-02' as date),3),(cast('2020-07-01' as date),7),(cast('2021-01-01' as date),3),(cast('2021-02-03' as date),19)
,(cast('2022-12-01' as date),3),(cast('2022-12-15' as date),3),(cast('2022-02-28' as date),12);

/*Write a sql toidentify yearwise count of new cities where usaan started their operations*/

SELECT ydate, count(*) as new_cities
from
(
SELECT *, YEAR(business_date) as ydate,
row_number() over(partition by city_id order by business_date asc) as rnum
FROM business_city
)k
where rnum = 1
group by ydate;

---------------------- another approach ----------------
with cte as
(
Select datepart(year,business_date) as bus_year,city_id
from business_city
)

select c1.bus_year, count(distinct case when c2.city_id is null then c1.city_id end) as cnt
from cte as c1 left join cte as c2
on c1.bus_year >  c2.bus_year and c1.city_id = c2.city_id
group by c1.bus_year
