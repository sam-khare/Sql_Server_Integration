CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
drop table activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

SELECT * FROM activity;

/*Find total active users each day*/

SELECT event_date, COUNT( DISTINCT user_id) as Total_Active_Users
FROM activity
GROUP BY event_date;

/*Find total active users each week*/

SELECT datepart(week,event_date) as Weekpart, COUNT( DISTINCT user_id) as Total_Active_Users
FROM activity
GROUP BY datepart(week,event_date);

/*date wise total number of users who made the purchase same day they installed the app*/
WITH Tot_user
AS(
SELECT a.event_date, COUNT(DISTINCT a.user_id) as total_user
FROM activity a   JOIN 
activity b on a.user_id = b.user_id and a.event_name <> b.event_name and a.event_date = b.event_date
GROUP BY a.event_date 
)

SELECT Distinct a.event_date, ISNULL(total_user,0) as total_user
FROM activity a LEFT JOIN 
Tot_user tu ON a.event_date = tu.event_date

/*Another Approach*/

SELECT event_date, COUNT(new_user) as total_user
FROM
(
	SELECT user_id, event_date, 
	CASE WHEN COUNT(DISTINCT event_name)=2 THEN user_id else null end as new_user
	from activity
	GROUP BY  user_id, event_date
)m
GROUP BY event_date

/*Question 4 Percentage of paid users in INdia, USA and any other country should be tagged as other country*/

select * from activity;


WITH country_users AS (
Select (CASE WHEN country in ('USA','India') THEN country else 'Others' end) as new country,
COUNT(distinct user_id) as user_cnt
FROM activity
WHERE event_name = 'app-purchase'
GROUP BY CASE WHEN country IN ('USA','India') THEN country else 'Others' end
),

total as (SELECT sum(user_cnt) as total_users from country_users)

SELECT new_country, user_cnt*1/total_users*100 as perc_users 
country_users,total


/*Question 5 Among all the users who installed the app on a given day, how many did in app purchased on the very next day*/

SELECT * FROM activity;


/*One apprach*/
WITH Tot_user
AS(
SELECT b.event_date, COUNT(DISTINCT a.user_id) as total_user
FROM activity a   JOIN 
activity b on a.user_id = b.user_id and a.event_name <> b.event_name and a.event_date = DATEADD(day,-1,b.event_date)
GROUP BY b.event_date 
)

SELECT Distinct a.event_date, ISNULL(total_user,0) as total_user
FROM activity a LEFT JOIN 
Tot_user tu ON a.event_date = tu.event_date

/*Another appraoch*/
WITH lag_data
AS(
SELECT *  ,
lag(event_name,1) over(partition by user_id order by event_date) as prev_event_name,
lag(event_date,1)over(partition by user_id order by event_date) as prev_event_date

FROM activity
)

SELECT * FROM
lag_data
WHERE event_name = 'app-purchase' and prev_event_name = 'app-installed' and DATEDIFF(day,prev_event_date,event_date) = 1