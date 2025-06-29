SELECT TOP (1000) [Match]
      ,[Innings]
      ,[match_date]
      ,[Versus]
      ,[Ground]
      ,[How Dismissed]
      ,[Runs]
      ,[Balls_faced]
      ,[strike_rate]
  FROM [BansalSQL].[dbo].[sachin_scores]

  /*Find the sachin's milestoone innings/match*/
  with
  cte as
  (
  SELECT  match,innings, runs,
  sum(runs) over(order by match rows between unbounded preceding and current row) as rolling_sum,
  count(innings) over(order by match rows between unbounded preceding and current row) as rolling_innings,
  count(match) over(order by match rows between unbounded preceding and current row) as rolling_match
  FROM (SELECT distinct * FROM sachin_scores)k
  ),

  cte_2 as
  (
  SELECT *,
  lag(rolling_sum,1) over (order by match) as prev_roll,
  lead(rolling_sum,1) over(order by match) as next_roll
  from cte
  )

  Select row_number() over (order by match) as rnum,
  rolling_match,
  rolling_innings,
  CASE WHEN rolling_sum > 1000 and rolling_sum < 5000 then 1000
		WHEN rolling_sum > 5000 and rolling_sum < 10000 then 5000
		when rolling_sum > 10000  then 10000
		end as 'total'
  from cte_2
  where (rolling_sum > 1000
  and prev_roll < 1000)
  OR
  (rolling_sum > 5000
  and prev_roll < 5000)
  OR
  (rolling_sum > 10000
  and prev_roll < 10000)


  /*Another approach*/
  with
  cte as
  (
  SELECT  match,innings, runs,
  sum(runs) over(order by match rows between unbounded preceding and current row) as rolling_sum
 
  FROM (SELECT distinct * FROM sachin_scores)k
  ),

  cte_2 as
  ( SELECT 1 as milestone_number, 1000 as milestone_runs

  union all
  SELECT 2 as milestone_number, 5000 as milestone_runs

  union all
  SELECT 3 as milestone_number, 10000 as milestone_runs
  
  )

  SELECT milestone_number,milestone_runs,min(match) as milestone_match, min(innings) as milestone_innings
  FROM cte_2
  inner join cte on rolling_sum > milestone_runs
  group by milestone_number,milestone_runs