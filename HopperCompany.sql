HARD QUERIES

--Hopper Company Queries I | Hard |
--Drivers table:
+-----------+------------+
| driver_id | join_date  |
+-----------+------------+
| 10        | 2019-12-10 |
| 8         | 2020-1-13  |
| 5         | 2020-2-16  |
| 7         | 2020-3-8   |
| 4         | 2020-5-17  |
| 1         | 2020-10-24 |
| 6         | 2021-1-5   |
+-----------+------------+
--Rides table:
+---------+---------+--------------+
| ride_id | user_id | requested_at |
+---------+---------+--------------+
| 6       | 75      | 2019-12-9    |
| 1       | 54      | 2020-2-9     |
| 10      | 63      | 2020-3-4     |
| 19      | 39      | 2020-4-6     |
| 3       | 41      | 2020-6-3     |
| 13      | 52      | 2020-6-22    |
| 7       | 69      | 2020-7-16    |
| 17      | 70      | 2020-8-25    |
| 20      | 81      | 2020-11-2    |
| 5       | 57      | 2020-11-9    |
| 2       | 42      | 2020-12-9    |
| 11      | 68      | 2021-1-11    |
| 15      | 32      | 2021-1-17    |
| 12      | 11      | 2021-1-19    |
| 14      | 18      | 2021-1-27    |
+---------+---------+--------------+
--AcceptedRides table:
+---------+-----------+---------------+---------------+
| ride_id | driver_id | ride_distance | ride_duration |
+---------+-----------+---------------+---------------+
| 10      | 10        | 63            | 38            |
| 13      | 10        | 73            | 96            |
| 7       | 8         | 100           | 28            |
| 17      | 7         | 119           | 68            |
| 20      | 1         | 121           | 92            |
| 5       | 7         | 42            | 101           |
| 2       | 4         | 6             | 38            |
| 11      | 8         | 37            | 43            |
| 15      | 8         | 108           | 82            |
| 12      | 8         | 38            | 34            |
| 14      | 1         | 90            | 74            |
+---------+-----------+---------------+---------------+

--Write an SQL query to report the following statistics for each month of 2020:

--The number of drivers currently with the Hopper company by the end of the month (active_drivers). 
--The number of accepted rides in that month (accepted_rides). Return the result table ordered by month in ascending order, 
--where month is the month’s number (January is 1, February is 2, etc.).

solution:
WITH RECURSIVE t1 AS (SELECT 1 AS month UNION ALL SELECT month+1 FROM t1 WHERE month<12)


SELECT t1.month, COUNT(DISTINCT d.driver_id) as active_drivers, COUNT(DISTINCT v.ride_id) AS accepted_rides
 FROM t1 LEFT JOIN
(SELECT driver_id, (CASE WHEN YEAR(join_date)<2020 THEN 1 ELSE MONTH(join_date) END) AS drivermonth FROM drivers WHERE YEAR(join_date)<=2020) d
 ON d.drivermonth<=t1.month
 
LEFT JOIN
(SELECT a.ride_id, MONTH(r.requested_at) as ridemonth FROM acceptedrides a JOIN rides r
 ON a.ride_id=r.ride_id WHERE YEAR(r.requested_at)=2020) v
 
 ON t1.month=v.ridemonth
 
 GROUP BY t1.month
ORDER BY t1.month

--Result table:
+-------+----------------+----------------+
| month | active_drivers | accepted_rides |
+-------+----------------+----------------+
| 1     | 2              | 0              |
| 2     | 3              | 0              |
| 3     | 4              | 1              |
| 4     | 4              | 0              |
| 5     | 5              | 0              |
| 6     | 5              | 1              |
| 7     | 5              | 1              |
| 8     | 5              | 1              |
| 9     | 5              | 0              |
| 10    | 6              | 0              |
| 11    | 6              | 2              |
| 12    | 6              | 1              |
+-------+----------------+----------------+

-- Hopper Company Queries II | Hard | 

--Write an SQL query to report the percentage of working drivers (working_percentage) for each month of 2020 where:
--percentage=100*(drivers that accepted atleast one ride during the month)/(available drivers during the month)
--Return the result table ordered by month in ascending order, where month is the month’s number (January is 1, February is 2, etc.). 
--Round working_percentage to the nearest 2 decimal places.

--solution:
WITH RECURSIVE t1 AS (SELECT 1 as month UNION ALL SELECT month+1 FROM t1 WHERE month<12)

SELECT t2.month, (CASE WHEN t2.available_drivers=0 THEN 0 ELSE ROUND(100*t2.accepted/t2.available_drivers,2) END) AS working_percentage
FROM
(SELECT t1.month, COUNT(DISTINCT d.driver_id) AS available_drivers, COUNT(DISTINCT v.driver_id) AS accepted
FROM t1 LEFT JOIN 
(SELECT driver_id, (CASE WHEN YEAR(join_date)<2020 THEN 1 ELSE MONTH(join_date) END) AS month FROM drivers WHERE YEAR(join_date)<=2020) d
ON d.month<=t1.month 
LEFT JOIN 
(SELECT a.driver_id, MONTH(r.requested_at) as month FROM acceptedrides a LEFT JOIN 
rides r ON a.ride_id=r.ride_id WHERE YEAR(r.requested_at)=2020) v
ON t1.month=v.month
GROUP BY t1.month) t2

--Result table:
+-------+--------------------+
| month | working_percentage |
+-------+--------------------+
| 1     | 0.00               |
| 2     | 0.00               |
| 3     | 25.00              |
| 4     | 0.00               |
| 5     | 0.00               |
| 6     | 20.00              |
| 7     | 20.00              |
| 8     | 20.00              |
| 9     | 0.00               |
| 10    | 0.00               |
| 11    | 33.33              |
| 12    | 16.67              |
+-------+--------------------+

-- Hopper Company Queries III | Hard |

--Write an SQL query to compute the average_ride_distance and average_ride_duration of every 3-month window starting from 
--January - March 2020 to October - December 2020. Round average_ride_distance and average_ride_duration to the nearest two decimal places.

--The average_ride_distance is calculated by summing up the total ride_distance values from the three months and dividing it by 3. 
--The average_ride_duration is calculated in a similar way.

--Return the result table ordered by month in ascending order, where month is the starting month’s number (January is 1, February is 2, etc.).

--solution:
WITH RECURSIVE CTE AS (SELECT 1 as first,2 as second, 3 as third
 UNION ALL SELECT first+1,second+1,third+1 FROM CTE WHERE first<10),
 t1 AS
(SELECT MONTH(r.requested_at) as month, a.ride_distance, a.ride_duration FROM acceptedrides a LEFT JOIN rides r
ON a.ride_id=r.ride_id WHERE YEAR(r.requested_at)=2020)

SELECT CTE.first AS month, ROUND(SUM(t1.ride_distance)/3,2) AS average_ride_distance, ROUND(SUM(t1.ride_duration)/3,2) AS average_ride_duration
FROM CTE LEFT JOIN t1 ON CTE.first=t1.month OR CTE.second=t1.month OR CTE.third=t1.month
GROUP BY CTE.first, CTE.second,CTE.third

--Result table:
+-------+-----------------------+-----------------------+
| month | average_ride_distance | average_ride_duration |
+-------+-----------------------+-----------------------+
| 1     | 21.00                 | 12.67                 |
| 2     | 21.00                 | 12.67                 |
| 3     | 21.00                 | 12.67                 |
| 4     | 24.33                 | 32.00                 |
| 5     | 57.67                 | 41.33                 |
| 6     | 97.33                 | 64.00                 |
| 7     | 73.00                 | 32.00                 |
| 8     | 39.67                 | 22.67                 |
| 9     | 54.33                 | 64.33                 |
| 10    | 56.33                 | 77.00                 |
+-------+-----------------------+-----------------------+

