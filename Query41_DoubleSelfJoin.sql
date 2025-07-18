create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

drop table emp;

insert into emp
values
(1, 'Ankit', 100,10000, 4, 39);
insert into emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp
values (3, 'Vikas', 100, 12000,4,37);
insert into emp
values (4, 'Rohit', 100, 14000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 20000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (9, 'Mukesh',300,6000,6,51);
insert into emp
values (10, 'Rakesh',500,7000,6,50);

/*Write a sql to list emp name along with their manager and senior manager name*/

select * from emp;

SELECT a.emp_id, a.emp_name,  b.emp_name as manager_name,  c.emp_name as senior_manger_name
FROM emp a
INNER join emp b on a.manager_id = b.emp_id
INNER join emp c on b.manager_id = c.emp_id
