create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
;

/*Customer retention and Churn*/

SELECT MONTH(this_month.order_date) as month_val, COUNT(last_month.cust_id) as cust_id_Count FROM 
transactions this_month
LEFT JOIN transactions last_month
ON this_month.cust_id = last_month.cust_id and DATEDIFF(month, last_month.order_Date,this_month.order_Date) = 1
GROUP BY MONTH(this_month.order_date)
;



SELECT MONTH(last_month.order_date) as month_val, COUNT(last_month.cust_id) as cust_id_Count from
--MONTH(this_month.order_date) as month_val, COUNT(last_month.cust_id) as cust_id_Count FROM 
transactions last_month
LEFT JOIN transactions this_month
ON this_month.cust_id = last_month.cust_id and DATEDIFF(month, last_month.order_Date,this_month.order_Date) = 1
WHERE  this_month.cust_id  iS NULL
GROUP BY MONTH(last_month.order_date)
;