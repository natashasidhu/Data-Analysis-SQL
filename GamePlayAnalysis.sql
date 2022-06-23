--Game Play Analysis I 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

--Write an SQL query that reports the first login date for each player.

--solution:
SELECT player_id, MIN(event_date) as first_login
FROM Activity
GROUP BY player_id

--Game Play Analysis II 
--Write a SQL query that reports the device that is first logged in for each player.

--solution:
SELECT DISTINCT player_id, device_id
FROM Activity
WHERE (player_id, event_date) in (
    SELECT player_id, min(event_date)
    FROM Activity
    GROUP BY player_id)
    
--Game Play Analysis III
--Write an SQL query that reports for each player and date, how many games played so far by the player.
--That is, the total number of games played by the player until that date.

--solution:
SELECT player_id, event_date,
SUM(games_played) OVER (PARTITION BY player_id ORDER BY event_date) AS games_played_so_far
FROM Activity;

--Game Play Analysis IV
--Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. 
--In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, 
--then divide that number by the total number of players.

--solution:
SELECT ROUND(COUNT(DISTINCT b.player_id)/COUNT(DISTINCT a.player_id),2) AS fraction
FROM
  (SELECT player_id, MIN(event_date) AS event_date FROM Activity
  GROUP BY player_id) a
  LEFT JOIN Activity b
  ON a.player_id = b.player_id AND a.event_date+1 = b.event_date;
  
  --Game Play Analysis V | Hard |
  --We define the install date of a player to be the first login day of that player. We also define day 1 retention of some date X to be the number of players
 -- whose install date is X and they logged back in on the day right after X , divided by the number of players whose install date is X, rounded to 2 decimal places.
  --Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention. 
--Result table:
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+

--solution:


SELECT
    install_dt,
    COUNT(player_id) installs,
    ROUND(COUNT(retention)/COUNT(player_id),2) Day1_retention  
FROM
    (
    SELECT a.player_id, a.install_dt, b.event_date retention 
    FROM
        (SELECT player_id, MIN(event_date) install_dt   
        FROM Activity
        GROUP BY player_id) a LEFT JOIN Activity b ON   
            a.player_id = b.player_id AND
            a.install_dt + 1=b.event_date
    ) AS tmp
GROUP BY
    install_dt
