/*create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success') */


SELECT MIN(date_value) AS Start_date,
		MAX(date_value) AS END_Date,
		state
		FROM
(
SELECT date_value, state, row_number() OVER (PARTITION BY state oRDER BY date_value) as rnum
	, DATEADD(DAY, -1*(row_number() OVER (PARTITION BY state oRDER BY date_value)), date_value) AS grp_date
FROM tasks
)k
GROUP BY state,grp_date
ORDER BY Start_date

/*Another solution*/
With t1 as(
 select date_value as d, state,
  Row_number() over(partition by state order by date_value) as r,
  Row_number() over(order by date_value) as r2 
  from tasks )
    
 select min(d) as start_date, max(d) as end_date , min(state)
 from t1
 group by (r2-r) Order by start_date;



