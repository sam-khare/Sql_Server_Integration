create table call_details  (
call_type varchar(10),
call_number varchar(12),
call_duration int
);

insert into call_details
values ('OUT','181868',13),('OUT','2159010',8)
,('OUT','2159010',178),('SMS','4153810',1),('OUT','2159010',152),('OUT','9140152',18),('SMS','4162672',1)
,('SMS','9168204',1),('OUT','9168204',576),('INC','2159010',5),('INC','2159010',4),('SMS','2159010',1)
,('SMS','4535614',1),('OUT','181868',20),('INC','181868',54),('INC','218748',20),('INC','2159010',9)
,('INC','197432',66),('SMS','2159010',1),('SMS','4535614',1);

/*Write a sl to determine phone numbers that satisfy  below conditions
the numbers have both incoming and outgoing calls
the sum of durations of outgoing calls should dbe greater than sun durations of incoming calls
*/

with cte as
(
SELECT *,
row_number() over (partition by call_number order by call_type) as rnum,
count(1) over (partition by call_number) as cnt
from call_details
where call_type IN ('OUT','INC')
),

cte_2 as
(
SELECT call_number, call_type, sum(call_duration) as total_duration,
rank() over (partition by call_number order by sum(call_duration) desc) as rn
from cte
where cnt > 1
group by call_number, call_type
)

SELECT * FROM cte_2
where rn=1 
and call_type = 'OUT'

------------------------------------------

with cte

as(
select call_number,
sum(case when call_type = 'OUT' then call_duration else null end) as out_duration,
sum(case when call_type = 'INC' then call_duration else null end) as inc_duration
from call_details
group by call_number
)

select
call_number
from cte
where out_duration is not null
and inc_duration is not null
and out_duration > inc_duration