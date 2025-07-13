create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled datetime
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');

/*Write a sql to find out callers whose first and last call was to the same person on a given day*/

with cte
as
( 
  SELECT callerid,  CONVERT(DATE,DateCalled) as Day_d, min(DateCalled) as first_call, max(DateCalled) as last_call 
  from phonelog
  group by callerid, CONVERT(DATE,DateCalled)

)

SELECT p.callerid,p.recipientid, CONVERT(DATE,p.DateCalled) as d_day
from phonelog p
JOIN phonelog q on p.callerid = q.callerid and p.recipientid = q.recipientid and CONVERT(DATE,p.DateCalled) = CONVERT(DATE,q.DateCalled) AND p.DateCalled < q.DateCalled
INNER JOIN  cte c on p.callerid = c.callerid and CONVERT(DATE,p.DateCalled) = c.Day_d AND c.first_call = p.DateCalled and C.last_call = q.datecalled


/*Another better solution*/

with cte
as
( 
  SELECT callerid,  CONVERT(DATE,DateCalled) as called_date, min(DateCalled) as first_call, max(DateCalled) as last_call 
  from phonelog
  group by callerid, CONVERT(DATE,DateCalled)

)

SELECT c.*,p1.recipientid,p2.recipientid as p2_rec,p1.datecalled , p2.datecalled as p2called from cte c
INNER jOin phonelog p1 on c.callerid = p1.callerid and c.first_Call = p1.datecalled
INNER JOIN phonelog p2 on c.callerid = p2.callerid and c.last_call = p2.datecalled
WHERE p1.recipientid = p2.recipientid


/**/

WITH cte AS (SELECT Callerid, Recipientid, CAST(Datecalled AS DATE) as Datecalled
FROM phonelog),
cte2 AS (SELECT *,
FIRST_VALUE(Recipientid) OVER(PARTITION BY Datecalled ORDER BY Datecalled) as first_value,
LAST_VALUE(Recipientid) OVER(PARTITION BY Datecalled ORDER BY Datecalled) as last_value
FROM cte)


SELECT Callerid, Datecalled, MAX(first_value) AS Recipientid FROM cte2
WHERE first_value = last_value
GROUP BY Callerid, Datecalled;

/**/

with cte as (select *,ROW_NUMBER()over(partition by callerid,cast(datecalled as date) order by Datecalled) as rn,
ROW_NUMBER()over(partition by callerid,cast(datecalled as date) order by Datecalled DESC) as rnk
from  phonelog),

cte2 as (select * from cte
where rn=1 or rnk=1)

select callerid,recipientid,CAST(Datecalled AS DATE) as Datecalled
from cte2
group by callerid,recipientid,CAST(Datecalled AS DATE)
having count(*)>1