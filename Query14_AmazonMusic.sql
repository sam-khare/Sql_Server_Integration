drop table users;
drop table events;
create table users
(
user_id integer,
name varchar(20),
join_date date
);
insert into users
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

/*Given the following two tables, return the fraction of users, rounded to two decimal places,
who accessed Amazon music and upgraded to prime membership within the first 30 days of signing up*/


SELECT  SUM(CASE WHEN type = 'P' THEN 1 else 0 end) as Prime,  SUM(CASE WHEN type = 'Music' THEN 1 else 0 end) as Music,
	ROUND(1.0*(SUM(CASE WHEN type = 'P' THEN 1 else 0 end))/(SUM(CASE WHEN type = 'Music' THEN 1 else 0 end)),2) as Fraction
	
FROM
(SELECT u.*,type,access_date, DATEDIFF(day,join_date,access_date) as diffdate FROM users u
inner JOIN events e on u.user_id =  e.user_id
WHERE type IN ('Music','P')
AND  DATEDIFF(day,join_date,access_date) < 31
)k






;

SELECT * FROM users;
Select * FROM events;