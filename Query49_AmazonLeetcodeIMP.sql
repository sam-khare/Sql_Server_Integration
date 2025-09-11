create table hall_events
(
hall_id integer,
start_date date,
end_date date
);
delete from hall_events
insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');

SELECT * FROM hall_events;

/*Merge Overlapping Events in the same hall*/
/*Using recursive query*/


WITH cte
as
(
SELECT * 
,ROW_NUmber() over(order by hall_id, start_date) as event_id
FROM hall_events
),

rec as
( SELECT hall_id,start_date,end_date,event_id,1 as flag from cte where event_id = 1
	UNION ALL
		
	SELECT cte.hall_id,cte.start_date,cte.end_date, cte.event_id, 
	CASE when cte.hall_id = rec.hall_id and (cte.start_date between rec.start_Date and rec.end_date
	or rec.start_date between cte.start_date and cte.end_Date
	) then 0 else 1 end + flag as flag
	from rec 
	inner join cte on rec.event_id +1 = cte.event_id
)

SELECT hall_id, flag, min(start_date) as start_Date, max(end_date) as end_date

from rec
group by hall_id, flag
