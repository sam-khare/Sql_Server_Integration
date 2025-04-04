create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;



WITH 
resource_agg as (SELECT name, STRING_AGG(resources,',') as used_resources from (SELECT distinct name, resources from entries)k group by name),

total_visits as ( SELECT name, count(*) as total_visit from entries group by name),

floor_visit as
(
SELECT name, floor, COUNT(*) as most_visit,
		RANK() OVER (PARTITION BY name ORDER BY COUNT(*) DESC) as rnk
FROM entries
group by name,floor
)
SELECT fv.name, tv.total_visit, fv.floor, rg.used_resources from floor_visit fv 
INNER JOIN total_visits tv ON tv.name = fv.name
INNER JOIN resource_agg rg ON rg.name = fv.name
where rnk = 1





