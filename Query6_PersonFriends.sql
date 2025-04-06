/*Write a query to find PersonID,Name ,Number of Friends, sum of marks of person who have friends
with total score greater than 100*/

WITH Score AS 
(SELECT a.PersonID,
COUNT(a.FriendID) AS FCount,
SUM(b.Score) AS Tot_Score



FROM [master].[dbo].[Friend] a

LEFT JOIN [master].[dbo].[Person] b ON a.FriendID = b.PersonID

GROUP BY a.PersonID
HAVING SUM(b.Score) > 100)


SELECT c.PersonID,c.Name,FCount,Tot_Score  FROM [master].[dbo].[Person] c INNER JOIN Score s ON c.PersonID = s.PersonID



