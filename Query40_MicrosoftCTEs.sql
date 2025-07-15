create table candidates (
emp_id int,
experience varchar(20),
salary int
);
delete from candidates;
insert into candidates values

(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);


/*company wants to hire a new employees. the budget if the company for the salaries is 70000 criteria
Keep hiring the senior with the smaalest salary unti you cannt hire more seniors
keep hiring the junior with the smallest salary until you canonot hire more juniors
write a sql to find the srniors and juniors hired under mentioned criteria
*/

SELECT * from candidates;

with cte1 
as
( SELECT emp_id, experience,salary,
sum(salary) over(partition by experience order by salary asc rows between unbounded preceding and current row) as r_sal
--use unbounded above due to the possiblity of duplicate salary then it may cause some issue

from candidates
),

cte2 as
(
select experience, MAX(70000 - r_sal) as rem_amt
from cte1
WHERE r_sal < 70000 and experience = 'senior'
GROUP BY experience
)


SELECT c1.emp_id, c1.experience, c1.salary
from cte1 c1
INNER JOIN cte2 c2 on 1 = 1
WHERE (r_sal < 70000 and c1.experience = 'senior') OR (r_sal <= c2.rem_amt and c1.experience = 'junior')


