Create Table Trade_tbl(
TRADE_ID varchar(20),
Trade_Timestamp time,
Trade_Stock varchar(20),
Quantity int,
Price Float
)

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20)
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15)
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30)
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32)
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19)
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19)

/*
	Write SQL to find all the couple of trades for same stoc that happend in the range of 10 seconds and 
	having price difference by more than 10%. output result should also list the percentge of price difference between the 2 trade
*/
SELECT * FROM Trade_tbl;

WITH CTE 
as
(
SELECT 
t2.trade_id as t2trade_id, 
t1.trade_id  as t1trade_id,
t2.price as t2price,
t1.price as t1price,
ROUND((ABS(t2.price - t1.price) / t2.price) *100,2) as percent_diff,

DATEDIFF(SECOND, t2.Trade_Timestamp, t1.Trade_Timestamp  ) as time_diff
from Trade_tbl t1
join trade_tbl t2 on t1.trade_id <> t2.trade_id 
AND DATEDIFF(SECOND, t2.Trade_Timestamp, t1.Trade_Timestamp ) <= 10
AND DATEDIFF(SECOND, t2.Trade_Timestamp, t1.Trade_Timestamp ) > 0
)

SELECT t2trade_id AS First_Trade,
t1trade_id AS Second_Trade,
t2price AS First_Trade_Price,
t1price AS Second_Trade_Price,
percent_diff
FROM
CTE 
WHERE percent_diff > 10

;



