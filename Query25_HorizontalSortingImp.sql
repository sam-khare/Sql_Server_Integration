CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

/*Find total number of messages exchange between each person per day*/

SELECT * from subscriber

/**/

SELECT sms_date, c1,c2 , sum(sms_no) as total_sms
from
(
SELECT *,

CASE WHEN sender < receiver THEN sender else receiver end as c1,

case WHEN sender > receiver THEN sender else receiver end as c2


FROM subscriber
)k
GROUP BY sms_date, c1,c2


-------------------------------

SELECT SENder, receiver , SUM(Total) as cnt
FROM

(
SELECT SENder, receiver, SUM(sms_no) as total
FROM subscriber
GROUP BY SENder, receiver

UNION 

SELECT receiver as sender,SENder as receiver,  SUM(sms_no) as total
FROM subscriber
GROUP BY SENder, receiver
)k

GROUP BY SENder, receiver