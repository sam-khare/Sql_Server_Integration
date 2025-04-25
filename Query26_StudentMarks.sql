CREATE TABLE [students](
 [studentid] [int] NULL,
 [studentname] [nvarchar](255) NULL,
 [subject] [nvarchar](255) NULL,
 [marks] [int] NULL,
 [testid] [int] NULL,
 [testdate] [date] NULL
)
data:
insert into students values (2,'Max Ruin','Subject1',63,1,'2022-01-02');
insert into students values (3,'Arnold','Subject1',95,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject1',61,1,'2022-01-02');
insert into students values (5,'John Mike','Subject1',91,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject2',71,1,'2022-01-02');
insert into students values (3,'Arnold','Subject2',32,1,'2022-01-02');
insert into students values (5,'John Mike','Subject2',61,2,'2022-11-02');
insert into students values (1,'John Deo','Subject2',60,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject2',84,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject3',29,3,'2022-01-03');
insert into students values (5,'John Mike','Subject3',98,2,'2022-11-02');

SELECT * FROM students
ORDER BY studentid,marks;

---write a sqk query to get the list of students who scored above the average marks in each subject

SELECT s.studentname,s.marks, s.subject, m.subject as msub, m.avg_marks
from students s
LEFT JOIN 
(
SELECT subject, avg(marks) as avg_marks
from students
GROUP BY subject
)m ON s.subject = m.subject
WHERE marks > avg_marks

--- Write a sql query to get the percentage of the students whi score more than 90 in any subject amonst the total students
WITh cte
AS(
SELECT COUNT(DISTINCT studentid) as total_stud
FROM students
)
,
cte2 as (
select  COUNT(DISTINCT k.studentid) as high_mark_stud
FROM students k

WHERE MARKS > 90
)

select (1.0*high_mark_stud/total_stud)*100 as result
FROM cte c1
inner join cte2 c2 on 1 =1

---- simple approach -----

SELECT (1.0 * COUNT(distinct CASE WHEN marks > 90 THEN studentid else null end)/COUNT(distinct studentid)) * 100 as percentage_Stud
FROM students


----Write a sql query to get the second highest and second lowest marks fro each subject
WITH cte as
(
SELECT subject,marks,
ROW_number() over (partition by subject order by marks desc) as high_low,
ROW_number() over (partition by subject order by marks asc) as low_high
FROM students
)

SELECT c1.subject, c1.marks AS second_lowest, c2.marks AS second_highest
FROM cte as c1
INNER JOIN cte as c2 on c1.high_low = c2.low_high AND c1.subject = c2.subject
WHERE c1.high_low = 2 and c2.low_high = 2


---------------------
SELECT subject,
SUM(CASE WHEN high_low = 2 THEN marks else null end) as second_lowest_marks,
SUM(CASE WHEN low_high = 2 THEN marks else null end) as second_highest_marks
FROM
(SELECT subject,marks,
ROW_number() over (partition by subject order by marks desc) as high_low,
ROW_number() over (partition by subject order by marks asc) as low_high
FROM students
)k
GROUP BY subject


--- FOr each student and test, identitify if their marks increased or decreased from previous test.
 SELECT studentid, MARKS,testdate,
 CASE  WHEN  lag_marks IS NULL THEN 'No_test' 
		WHEN marks > lag_marks THEN 'Increased' else 'decreased' end as result
 from
 (SELECT studentid,
 lag(marks,1) over(partition by studentid order by testdate,subject) as lag_marks,
 marks,  
 lead(marks,1) over(partition by studentid order by testdate) as lead_marks,
 testdate

 FROM students
 )k
