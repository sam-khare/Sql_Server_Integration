
create table orders1
(
order_id int,
customer_id int,
product_id int,
);

insert into orders1 VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products1 (
id int,
name varchar(10)
);
insert into products1 VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');


SELECT o1.order_id,o1.product_id as p1, o2.product_id as p2  FROM orders1 o1
INNER JOIN orders1 o2 ON o1.order_id = o2.order_id
WHERE o1.order_id = 1


/*Example of cross join*/

SELECT (p1.name + ' '+ p2.name) AS Pair , COUNT(1) AS purch_freq FROM orders1 o1
INNER JOIN orders1 o2 ON o1.order_id = o2.order_id
INNER JOIN products1 p1 ON  o1.product_id = p1.id
INNER JOIN products1 p2 ON  o2.product_id = p2.id
WHERE  o1.product_id < o2.product_id
GROUP BY p1.name,p2.name
