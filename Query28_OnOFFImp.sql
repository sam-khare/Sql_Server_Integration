create table event_status
(
event_time varchar(10),
status varchar(10)
);
insert into event_status 
values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');


SELECT	CASE WHEN (lag_Status IS NULL OR lag_Status = 'off') and status = 'on' THEN event_time end AS login,
		CASE WHEN (lead_Status IS NULL OR lead_Status = 'off') and status = 'on' THEN lead_time end AS logout
		
FROM
(SELECT event_time,
		LAG(status,1) OVER (ORDER BY event_time) as lag_Status,
		status,
		Lead(status,1) OVER (ORDER BY event_time) as lead_Status,
		Lead(event_time,1) OVER (ORDER BY event_time) as lead_time

FROM event_status
)k

/*1st approach*/
SELECT MIN(event_time) as login, max(event_time) as logout, count(1)-1 as on_count
from
(
select *,  sum(case when status = 'on' and prev_status = 'off' then 1 else 0 end) over (order by event_time) as group_key
from
(
select  * 
, lag(status,1,status) over (order by event_time asc) as prev_status
from event_Status
)k
)m
GROUP by group_key

