/*create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);*/
/* Find the winner in each group. the winner in each group is the player who scored maximum total points within the group. in case of tie 
lower player_id wins
*/

/*First is my approach*/

/*SELECT player_id, group_id, total_score_sum
FROM

(SELECT player_id, group_id, (ISNULL(SUM(mf.first_score),0) + ISNULL(SUM(ms.second_score),0)) as total_score_sum  

,rank() over (partition by group_id order by (ISNULL(SUM(mf.first_score),0) + ISNULL(SUM(ms.second_score),0)) DESC,player_id ASC) as rnk

FROM Players p
LEFT JOIN matches mf on mf.first_player = player_id
LEFT JOIN matches ms on ms.second_player = player_id
GROUP BY player_id, group_id
)k
where rnk = 1
;*/

/*Another Approach*/

WITH player_scores as
(
SELECT first_player AS player_id, first_score as score FROM Matches
UNION ALL
SELECT second_player AS player_id, second_score as score from matches
),

player_Scores_tot as
(
	SELECT player_id, SUM(score) as total_score FROM player_scores
	GROUP By player_id
),

player_group as
(
SELECT ps.player_id,group_id, total_score 
,rank() over (partition by group_id ORDER BY total_score DESC,  ps.player_id asc) as rnk
FROM player_Scores_tot ps
INNER JOIN players p ON ps.player_id= p.player_id

)

SELECT * FROM player_group
WHERE rnk = 1