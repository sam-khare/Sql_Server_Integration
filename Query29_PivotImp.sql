create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');

SELECT player_groups,
MAX(CASE WHEN city = 'Bangalore' THEN name end) as Bangalore,
MAX(CASE WHEN city = 'Mumbai' THEN name end) as Mumbai,
MAX(CASE WHEN city = 'Delhi' THEN name end) as Delhi

FROM
(SELECT * ,
ROW_NUMBER() OVER (PARTITION BY CITY ORDER BY name asc) as player_groups
FROM players_location
)A
GROUP BY player_groups



-------------Another approch ----------------

SELECT Bangalore,Mumbai,Delhi,rnum FROM 
(
  SELECT name, city, row_number() over(partition by city order by name) rnum
   FROM players_location
) as source_table

PIVOT
(
 MAX(name) FOR city IN(Mumbai, Delhi ,Bangalore )
) as pvt;
