
create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);
delete from billings;
insert into billings values
('Sachin','01-JAN-1990',25)
,('Sehwag' ,'01-JAN-1989', 15)
,('Dhoni' ,'01-JAN-1989', 20)
,('Sachin' ,'05-Feb-1991', 30)
;

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
insert into HoursWorked values
('Sachin', '01-JUL-1990' ,3)
,('Sachin', '01-AUG-1990', 5)
,('Sehwag','01-JUL-1990', 2)
,('Sachin','01-JUL-1991', 4)

/*Total charge as per billing rate*/

WITH date_range
AS(
Select *, lead(dateadd(day,-1,bill_date),1,'9999-12-31') over(partition by emp_name order by bill_date) as end_date 
FROM billings
)

SELECT hw.emp_name,sum(bill_hrs*bill_rate) as total_pay FROM date_range dr
INNER JOIN HoursWorked hw ON dr.emp_name = hw.emp_name and work_date between dr.bill_date and dr.end_date
GROUP BY hw.emp_name