create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);

INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');


SELECT * FROM icc_world_cup;

SELECT Team_1, 
		COUNT(TEAM_1) AS Total_Match_Played,
		SUM(win_flag) AS Total_Match_Won,
		COUNT(Team_1)-SUM(win_flag) AS Total_Lost_Match
		FROM
(
select Team_1,
		CASE WHEN Team_1 = Winner THEN 1 ELSE 0 END AS win_flag
		from icc_world_cup
UNION ALL
select Team_2,
		CASE WHEN Team_2 = Winner THEN 1 ELSE 0 END AS win_flag
		from icc_world_cup
)k
GROUP BY Team_1
ORDER BY Total_Match_Won DESC;
