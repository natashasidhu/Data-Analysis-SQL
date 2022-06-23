--Monthly Transactions I | Medium |
--Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+

--Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

--solution:

WITH t1 AS(
SELECT DATE_FORMAT(trans_date,'%Y-%m') AS month, country, COUNT(state) AS trans_count, sum(amount) AS trans_total_amount
FROM transactions
GROUP BY country, month(trans_date)),

t2 AS (
SELECT DATE_FORMAT(trans_date,'%Y-%m') AS month, country, COUNT(state) AS approved_count, sum(amount) AS approved_total_amount
FROM transactions
WHERE state = 'approved'
GROUP BY country, month(trans_date))

SELECT t1.month, t1.country, COALESCE(t1.trans_count,0) AS trans_count, COALESCE(t2.approved_count,0) AS approved_count, COALESCE(t1.trans_total_amount,0) AS trans_total_amount, COALESCE(t2.approved_total_amount,0) AS approved_total_amount
FROM t1 LEFT JOIN t2
ON t1.country = t2.country and t1.month = t2.month

--Result table:
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
