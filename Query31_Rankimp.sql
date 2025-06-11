CREATE TABLE [emp](
 [emp_id] [int] NULL,
 [emp_name] [varchar](50) NULL,
 [salary] [int] NULL,
 [manager_id] [int] NULL,
 [emp_age] [int] NULL,
 [dep_id] [int] NULL,
 [dep_name] [varchar](20) NULL,
 [gender] [varchar](10) NULL
) ;
insert into emp values(1,'Ankit',14300,4,39,100,'Analytics','Female')
insert into emp values(2,'Mohit',14000,5,48,200,'IT','Male')
insert into emp values(3,'Vikas',12100,4,37,100,'Analytics','Female')
insert into emp values(4,'Rohit',7260,2,16,100,'Analytics','Female')
insert into emp values(5,'Mudit',15000,6,55,200,'IT','Male')
insert into emp values(6,'Agam',15600,2,14,200,'IT','Male')
insert into emp values(7,'Sanjay',12000,2,13,200,'IT','Male')
insert into emp values(8,'Ashish',7200,2,12,200,'IT','Male')
insert into emp values(9,'Mukesh',7000,6,51,300,'HR','Male')
insert into emp values(10,'Rakesh',8000,6,50,300,'HR','Male')
insert into emp values(11,'Akhil',4000,1,31,500,'Ops','Male')

/*Write a sql query to find details of employees with third highhest salart in each department
in case there are less than 3 employees in a departmentthen return employee details with lowest salary in that dep*/


/*Approach 1*/
SELECT *
FROM
(
SELECT *,
RANK() OVER(PARTITION By DEP_id oRDEr by salary DESC) as high_sala,
RANK() OVER(PARTITION By DEP_id oRDEr by salary ASC) as low_sala,
COUNT(1) OVER (PARTITION BY dep_id) as cnt_dept
FROM emp
)k
WHERE high_sala = (
CASE	WHEN cnt_dept >= 3 THEN 3
		WHEN cnt_dept = 2 THEN 2
		WHEN cnt_dept = 1 THEN 1
		end)

/*Approach 2 shorter and better*/


SELECT *
FROM
(
SELECT *,
RANK() OVER(PARTITION By DEP_id oRDEr by salary DESC) as rnum,
COUNT(1) OVER (PARTITION BY dep_id) as cnt_dept
FROM emp
)k
WHERE rnum =3 OR (cnt_dept<3 and rnum=cnt_dept)