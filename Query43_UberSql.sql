create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));

insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

/*Write a query to print total rides and profit rides for each driver.
profit ride is when the end locaiton of the current ride is same as start locaiton on the next ride
*/
WITH CTE
AS
(
SELECT *,
row_number() over (partition by id order by start_time) as rnum
FROM drivers
)

SELECT c1.id, count(c2.id) as cnt_p, count(c1.id) as total_ride
from cte c1
LEFT JOIN cte c2 on c1.rnum = c2.rnum-1 and c1.end_loc = c2.start_loc and c1.id = c2.id
GROUP by c1.id


-------------------------------------Another approach ----------

select id, count(id) as total_ride, 
sum(case when end_loc = lead_col then 1 else 0 end) as profit_ride 
from
(
select *,
lead(start_loc,1) over (partition by id order by start_time) lead_col
from drivers
)k
group by id