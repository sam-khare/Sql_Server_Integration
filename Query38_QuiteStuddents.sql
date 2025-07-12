drop table students;
drop table exams;
create table students
(
student_id int,
student_name varchar(20)
);
insert into students values
(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');

create table exams
(
exam_id int,
student_id int,
score int);

insert into exams values
(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
,(40,2,70),(40,4,80);

SELECT * FROM students;

select * from exams;

/*Write a sql query to identify students who took atleast one exam and neither score highes nor lowest */

with cte as
(
SELECT exam_id, max(score) as max_score, min(score) as min_score
from exams group by exam_id
)

SElect e.*, student_name
FROM exams e inner join cte c on e.exam_id = c.exam_id and e.score < c.max_score and e.score > c.min_score
left join students s on s.student_id = e.student_id
WHERE e.student_id NOT IN (SELECT  student_id
from exams e INNER join cte c on e.exam_id = c.exam_id and (e.score = c.max_score or e.score = c.min_score))
order by student_id


/*shorter approach*/

with cte as
(
SELECT exam_id, max(score) as max_score, min(score) as min_score
from exams group by exam_id
)

SElect e.student_id
student_name
FROM exams e inner join cte c on e.exam_id = c.exam_id 
left join students s on s.student_id = e.student_id

GROUP BY e.student_id
HAVING MAX(case when e.score = min_score or score= max_score then 1 else 0 end)=0
order by e.student_id