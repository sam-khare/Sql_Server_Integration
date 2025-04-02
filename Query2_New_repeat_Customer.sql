create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders 
	values	(1,100,cast('2022-01-01' as date),2000),
			(2,200,cast('2022-01-01' as date),2500),
			(3,300,cast('2022-01-01' as date),2100),
			(4,100,cast('2022-01-02' as date),2000),
			(5,400,cast('2022-01-02' as date),2200),
			(6,500,cast('2022-01-02' as date),2700),
			(7,100,cast('2022-01-03' as date),3000),
			(8,400,cast('2022-01-03' as date),1000),
			(9,600,cast('2022-01-03' as date),3000);

select * from customer_orders;

--Find the new and repeat customer everyday

SELECT customer_id, order_date, order_amount, row_number() over(partition by customer_id order by order_date asc) as rnum
from customer_orders; ---subquery run

SELECT order_Date,
		SUM(CASE WHEN rnum = 1 THEN 1 ELSE 0 END) AS Unique_customer,
		SUM(CASE WHEN rnum > 1 THEN 1 ELSE 0 END) AS Repeat_Customer
		FROM
(
SELECT customer_id, order_date, order_amount, row_number() over(partition by customer_id order by order_date asc) as rnum
from customer_orders
)k
GROUP BY Order_date;

-----Another Approach

WITH first_visit AS
(SELECT customer_id, min(order_date) as first_visit_date
from customer_orders
group by customer_id

),
visit_flag AS 
(
select co.*,fv.first_visit_date 
		,CASE WHEN order_date = first_visit_date THEN 1 ELSE 0 END AS Unique_customer
		,CASE WHEN order_date <> first_visit_date THEN 1 ELSE 0 END AS repeat_customer
from customer_orders co
INNER JOIN first_visit fv on co.customer_id = fv.customer_id
)
SELECT order_date,
		SUM(unique_customer) as unique_customer_count,
		SUM(repeat_Customer) as repeat_Customer_count
FROM visit_flag
GROUP BY order_date;