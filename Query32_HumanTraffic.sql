create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);

/*Write a query to display records which have 3 or more consecutive records with the no of of people more than 100*/
SELECT id, visit_date, 
no_of_people
FROM

(
SELECT id, visit_date, 

lag(no_of_people,2) over (order by visit_date) as lg_p2,
lag(no_of_people,1) over (order by visit_date) as lg_p,
no_of_people,
lead(no_of_people,1) over(order by visit_date) as lead_p,
lead(no_of_people,2) over(order by visit_date) as lead_p2
FROM stadium

)k
WHERE (lg_p2 >= 100 and lg_p>= 100 and no_of_people >= 100)
OR
(no_of_people >= 100 and lead_p>=100 and lead_p2>=100)


------------------------------------


with cte as(
select *,
sum(case when no_of_people >= 100 then 1 else 0 end) over(order by visit_date rows between 2 preceding and current row) as Prev_2,
sum(case when no_of_people >= 100 then 1 else 0 end) over(order by visit_date rows between 1 preceding and 1 following) as Prev_next_1,
sum(case when no_of_people >= 100 then 1 else 0 end) over(order by visit_date rows between current row and 2 following) as next_2
 from stadium)
 select id, visit_date, no_of_people
 from cte
 where Prev_2 >=3
 or Prev_next_1 >=3 
 or next_2 >= 3

----------------------------------
WITH cte as
(
SELECT *,
ROW_NUmber() OVER (ORDER BY visit_Date) as rn,
(id - (ROW_NUmber() OVER (ORDER BY visit_Date))) as diff
FROM stadium
WHERE no_of_people >= 100
)

SELECT * FROM CTE
WHERE diff in ( SELECT diff from cte group by diff having count(1) >= 3)

