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
 
 