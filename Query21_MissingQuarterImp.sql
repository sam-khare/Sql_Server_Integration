DDL and DML:
CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

/*We have to find the missing quarter for each store*/
Select * FROM STORES;


/*1+2+3+4 = 10*/
SELECT Store, 'Q'+ cast(10-SUM(CAST(RIGHT(Quarter,1) as int)) as char(2))  as q_no
FROM stores
GROUP BY store;

/*Method 2 recusrsive  */
WITH cte as
(
	SELECT distinct store, 1 as q_no from stores
	UNION ALL
	SELECT store, q_no+1
	FROM cte
	where q_no < 4
)
,
q as(
SELECT store, 'Q'+CAST(q_no as char(1)) as q_no from cte
)
SELECT * FROM	q
LEFT JOIN stores s on q.store = s.store and q.q_no = s.Quarter
WHERE s.Quarter IS NULL

----Using Cross Join 
WITH cte as
(
	SELECT  DISTINCT s1.store, s2.quarter
	FROM stores s1,stores s2
)

SELECT * FROM	cte c
LEFT JOIN stores s on c.store = s.store and c.quarter = s.Quarter
WHERE s.Quarter IS NULL