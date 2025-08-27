create table section_data
(
section varchar(5),
number integer
)
insert into section_data
values ('A',5),('A',7),('A',10) ,('B',7),('B',9),('B',10) ,('C',9),('C',7),('C',9) ,('D',10),('D',3),('D',8);

/*Problem statement : we have a table which stores data of multiple sections. every section has 3 numbers
we have to find top 4 numbers from any 2 sections(2 numbers each) whose addition should be maximum
so in this case we will choose section b where we have 19(10+9) then we need to choose either C or D
because both has sum of 18 but in D we have 10 which is big from 9 so we will give priority to D.
*/

WITH CTE
as
(
Select *,
SUM(number) OVER (PARTITION BY section order by number ROWS between 1 preceding and current row ) as sum_number,
--LEAD(number,1) over (partition by section order by number) as lead_number,
Rank() OVER  (Partition By section order by number desc) as rnk_sec
from section_data
)
,
cte2
as
(
SELECT top 2
section, number,
(sum_number - number) as sec_NUMBER
FROM cte
ORDER BY sum_number desc, number desc
)

SELECT section, number
FROM
(
SELECT section, number
FROM cte2

UNION ALL

SELECT section, sec_number AS number
FROM cte2
)k
ORDER BY section, number desc
----------------------- USing Unpivot----------------
WITH CTE AS (
    SELECT *,
        SUM(number) OVER (
            PARTITION BY section 
            ORDER BY number 
            ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
        ) AS sum_number,
        RANK() OVER (PARTITION BY section ORDER BY number DESC) AS rnk_sec
    FROM section_data
),
cte2 AS (
    SELECT TOP 2
        section, 
        number,
        (sum_number - number) AS sec_number
    FROM CTE
    ORDER BY sum_number DESC, number DESC
)

SELECT section, new_number as number
FROM (
    SELECT section, number, sec_number
    FROM cte2
) AS src
UNPIVOT (
    new_number FOR x IN (number, sec_number)
) AS unpivoted;

---------------------------------