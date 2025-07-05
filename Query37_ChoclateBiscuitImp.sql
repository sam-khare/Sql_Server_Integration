create table brands 
(
category varchar(20),
brand_name varchar(20)
);
insert into brands values
('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');

SELECT * FROM brands
/*Write a sql to populate values ti the last not null value*/
with cte1
as(
SELECT category, brand_name,
row_number() over (order by (select null)) as rnum
from brands
),

cte2 as
(
SELECT *,
lead(rnum,1,9999)over(order by rnum) as next_rn
from cte1
where category is not null
)


select c2.category, c1.brand_name
from cte1 c1 INNER join cte2 c2 on c1.rnum >= c2.rnum and c1.rnum < c2.next_rn


-----------------------------------------

with cte1 as (
select * , 
row_number() over(order by (select null)) rn  
from brands
)
	select min(category) over(order by rn rows between unbounded preceding and current row) category, 
	brand_name
	from cte1