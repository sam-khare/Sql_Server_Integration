/*create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4); */

 /*Write a query to find for each seller, whether the brand of the second iem (by date) they sold  is their fav. if less than 2 than say 
 no. also result in seller id and 2nd fav brand as yes/no*/

 SELECT * FROM users;
 
 SELECT * FROM items;
 
 SELECT * FROM orders;

 WITH sell_order AS
 (SELECT seller_id, item_id, order_date,
 rank() over (partition by seller_id ORDER BY order_date ASC) as rnk
 FROM orders o
 ),

 item_order AS
 (
 SELECT so.*, item_brand
 
 FROM items u LEFT JOIN sell_order so ON u.item_id = so.item_id
 WHERE rnk = 2
 
 )
 
 SELECT user_id , favorite_brand, item_brand ,
 CASE WHEN item_brand = favorite_brand THEN 'Yes'
	ELSE 'No' END AS Return_result
			
 from users u left JOIN  item_order io on u.user_id = io.seller_id
