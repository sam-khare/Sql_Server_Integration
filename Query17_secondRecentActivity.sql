create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

/*Get the second most recent activity and in case of only 1 activity then return first*/
/*Lengthy approch*/
WITH firstq
AS(
SELECT username, count(*) as cnt
FROM UserActivity
GROUP BY username
),

secondq as
(
SELECT username,activity
, row_number() over(partition by username order by startDate) as act_rnk

FROM UserActivity
)

SELECT sq.username,activity
FROM secondq sq INNER JOIN firstq fq ON sq.username = fq.username
WHERE act_rnk = ( CASE WHEN fq.cnt > 1 THEN 2
	else  1 end )

;

/*better approach*/
SELECT username,activity, startdate, enddate
FROM
(
SELECT username,activity, startdate, enddate
, row_number() over(partition by username order by startDate) as act_rnk
, count(1) over (partition by username) as cnt
FROM UserActivity
)k
WHERE cnt = 1 or act_rnk = 2