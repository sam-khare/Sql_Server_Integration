create table tbl_orders (
order_id integer,
order_date date
);
insert into tbl_orders
values (1,'2022-10-21'),(2,'2022-10-22'),
(3,'2022-10-25'),(4,'2022-10-25');

select * into tbl_orders_copy from  tbl_orders;

select * from tbl_orders;

SELECT * from tbl_orders_copy

insert into tbl_orders
values (5,'2022-10-26'),(6,'2022-10-26');
delete from tbl_orders where order_id in (1);

/*Write a sql query with a flag depicting new insert as 'I' in the main table and deleted as 'D' 
from the main table which is avilable in the copied table  */

SELECT coalesce(a.order_id, b.order_id) as order_id,
CASE WHEN b.order_id is NULL THEN 'I'
 WHEN a.order_id is NULL THEN 'D'
end as flag
FROM tbl_orders a
full outer join tbl_orders_copy b
on a.order_id = b.order_id
where a.order_id is null or b.order_id is null