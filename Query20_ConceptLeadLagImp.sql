/* 3 or more consecutive empty seats
method 1 : lead lag
method 2 : advance aggregation
method 3 : analytical row number function

*/

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

/*Lead Lag and unpivot*/

WITH temp AS
(
SELECT lag_seat0, seat_no,lead_seat2
FROM
(
Select 
lag(seat_no,1) over (order by seat_no) as lag_seat0,
lag(is_empty,1) over (order by seat_no) as lag_empty0,
seat_no,
is_empty,
lead(seat_no,1) over (order by seat_no) as lead_seat2,
lead(is_empty,1) over (order by seat_no) as lead_empty2
from bms
)k
WHERE lag_empty0 = 'Y' AND lead_empty2 = 'Y' AND is_empty = 'Y' 
)

SELECT DISTINCT value
FROM temp
UNPIVOT(
value FOR col_name in (lag_seat0, seat_no,lead_seat2)
) as UNPVOT;

/*Simple lead lag*/

SELECT * FROM
(
Select *,
lag(is_empty,1) over (order by seat_no) as lag_empty1,
lag(is_empty,2) over (order by seat_no) as lag_empty2,
lead(is_empty,1) over (order by seat_no) as lead_empty1,
lead(is_empty,2) over (order by seat_no) as lead_empty2
from bms
)k

WHERE is_empty = 'Y' and lag_empty1 = 'Y' and lag_empty2 = 'Y'
OR ( is_empty = 'Y' and lag_empty1 = 'Y' and lead_empty1 = 'Y')
OR ( is_empty = 'Y' and lead_empty2 = 'Y' and lead_empty1 = 'Y')


---Method 2

SELECT * FROM
(
Select *,
SUM(CASE WHEN is_empty='Y' THEN 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) as prev_2,
SUM(CASE WHEN is_empty='Y' THEN 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) as prev_next_1,
SUM(CASE WHEN is_empty='Y' THEN 1 else 0 end) over (order by seat_no rows between current row and 2 following) as next_2

from bms
)k
WHERE prev_2 = 3
OR (prev_next_1 =3)
OR (next_2 = 3)


---Method 3

WITH diff_num as
(
SELECT *,
row_number() over (order by seat_no) as rn,
seat_no - row_number() over (order by seat_no) as diff
FROM bms
WHERE is_empty = 'Y'
),

cnt as
(
SELECT diff, count(1) as c
FROM diff_num
group by diff
HAVING count(1)>=3
)

select * from diff_num
where diff in (select diff from cnt)