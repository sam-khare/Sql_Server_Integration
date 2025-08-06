create table purchase_history
(userid int
,productid int
,purchasedate date
);
SET DATEFORMAT dmy;
insert into purchase_history values
(1,1,'23-01-2012')
,(1,2,'23-01-2012')
,(1,3,'25-01-2012')
,(2,1,'23-01-2012')
,(2,2,'23-01-2012')
,(2,2,'25-01-2012')
,(2,4,'25-01-2012')
,(3,4,'23-01-2012')
,(3,1,'23-01-2012')
,(4,1,'23-01-2012')
,(4,2,'25-01-2012')
;

/*Write a sql query to find users who purchased different products on different dates
i.e. products purchased on a given day are not repeated on any other day
*/
select * from purchase_history

SELECT *

with cte as
(
SELECT userid,  count(distinct(purchasedate)) as shp_count
from purchase_history
group by userid
having count(distinct(purchasedate)) > 1
),
cte2 as
(
select distinct p.userid
from purchase_history p inner join purchase_history q 
on p.userid = q.userid and p.productid = q.productid and p.purchasedate <> q.purchasedate
)
select distinct p.userid from purchase_history p
inner join cte c on c.userid = p.userid
left join cte2 c2 on p.userid  = c2.userid
where c2.userid is null


/*Shorter trick*/
SELECT distinct userid
from
(
SELECT userid,  count(distinct(purchasedate)) as shp_count,
count(productid) cnt_product,
count(distinct productid) dis_cnt_prod
from purchase_history
group by userid
having count(distinct(purchasedate)) > 1
)k
WHERE cnt_product = dis_cnt_prod

AND count(productid) cnt_product = count(distinct productid)