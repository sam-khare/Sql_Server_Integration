create table movie(
seat varchar(50),occupancy int
);
insert into movie values('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);

SELECT * FROM movie;

SELECT seat, occupancy

FROM

(
SELECT TOP 30 
CAST(substring(seat,2,len(seat)) as int) as cnt,
seat, occupancy,
	 sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by substring(seat,1,1) order by seat rows between current row and 3 following ) as next_3,
	 sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by substring(seat,1,1) order by seat rows between 1 preceding and 2 following ) as next_2,
	 sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by substring(seat,1,1) order by seat rows between 2 preceding and 1 following ) as next_1,
	 sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by substring(seat,1,1) order by seat rows between 3 preceding and current row ) as next_0,

substring(seat,1,1) as grp

from movie
order by grp,cnt
)k
WHERE next_3 = 4 
OR next_2 = 4
OR next_1 = 4
OR next_0 = 4

--------------------------------


with cte
as
(
	SELECT   seat, occupancy,
	left(seat,1) as row_id,
CAST(substring(seat,2,len(seat)) as int) as cnt
from movie
),

cte2 as
(
select *,

sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by row_id order by cnt rows between current row and 3 following ) as next_3,
	 sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by row_id order by cnt rows between 1 preceding and 2 following ) as next_2,
	 sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by row_id order by cnt rows between 2 preceding and 1 following ) as next_1,
	 sum(case WHEN occupancy=0 then 1 else 0 end) over (partition by row_id order by cnt rows between 3 preceding and current row ) as next_0

	 from cte
	 )
select seat, occupancy

FROM cte2
where next_3 = 4 
OR next_2 = 4
OR next_1 = 4
OR next_0 = 4