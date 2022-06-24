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

--Monthly Transactions II | Medium |
--Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 101  | US      | approved | 1000   | 2019-05-18 |
| 102  | US      | declined | 2000   | 2019-05-19 |
| 103  | US      | approved | 3000   | 2019-06-10 |
| 104  | US      | approved | 4000   | 2019-06-13 |
| 105  | US      | approved | 5000   | 2019-06-15 |
+------+---------+----------+--------+------------+
--Chargebacks table:
+------------+------------+
| trans_id   | trans_date |
+------------+------------+
| 102        | 2019-05-29 |
| 101        | 2019-06-30 |
| 105        | 2019-09-18 |
+------------+------------+

--Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.
--Note: In your query, given the month and country, ignore rows with all zeros.

--solution:
SELECT month, country,
    SUM(CASE WHEN type='approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(CASE WHEN type='approved' THEN amount ELSE 0 END) AS approved_amount,
    SUM(CASE WHEN type='chargeback' THEN 1 ELSE 0 END) AS chargeback_count,
    SUM(CASE WHEN type='chargeback' THEN amount ELSE 0 END) AS chargeback_amount
FROM (
    (
    SELECT left(t.trans_date, 7) AS month, t.country, amount,'approved' AS type
    FROM Transactions AS t
    WHERE state='approved'
    )
    UNION ALL (
    SELECT left(c.trans_date, 7) AS month, t.country, amount,'chargeback' AS type
    FROM Transactions AS t JOIN Chargebacks AS c
    ON t.id = c.trans_id
    )
) AS tt
GROUP BY tt.month, tt.country

--Result table:
+----------+---------+----------------+-----------------+-------------------+--------------------+
| month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
+----------+`---------+----------------+-----------------+-------------------+--------------------+
| 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
| 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
| 2019-09  | US      | 0              | 0               | 1                 | 5000               |
+----------+---------+----------------+-----------------+-------------------+--------------------+
