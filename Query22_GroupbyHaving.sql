create table exams (student_id int, subject varchar(20), marks int);
delete from exams;
insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

SELECT * from exams;
/*Find students with same marks in Physics and chemistry*/

SELECT student_id, marks, count(distinct subject) as cnt
from exams
WHERE subject IN ('Chemistry','Physics')
group by student_id, marks
having count(distinct subject) = 2