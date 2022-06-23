--Employee Bonus |

--Table:Employee
+-------+--------+-----------+--------+
| empId |  name  | supervisor| salary |
+-------+--------+-----------+--------+
|   1   | John   |  3        | 1000   |
|   2   | Dan    |  3        | 2000   |
|   3   | Brad   |  null     | 4000   |
|   4   | Thomas |  3        | 4000   |
+-------+--------+-----------+--------+
--empId is the primary key column for this table.

--Table: Bonus
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
--empId is the primary key column for this table.

--Select all employee’s name and bonus whose bonus is < 1000.

--solution:
SELECT name, bonus
FROM Employee LEFT JOIN Bonus
ON Employee.empId = Bonus.empId
WHERE bonus<1000 OR bonus IS NULL;

--Find Customer Referee | 
--Given a table customer holding customers information and the referee.
+------+------+-----------+
| id   | name | referee_id|
+------+------+-----------+
|    1 | Will |      NULL |
|    2 | Jane |      NULL |
|    3 | Alex |         2 |
|    4 | Bill |      NULL |
|    5 | Zack |         1 |
|    6 | Mark |         2 |
+------+------+-----------+
--Write a query to return the list of customers NOT referred by the person with id ‘2’.

--solution:
SELECT name
FROM customer
WHERE referee_id != '2' OR referee_id IS NULL;

--Customer Placing the Largest Number of Orders | 
--Query the customer_number from the orders table for the customer who has placed the largest number of orders.
| order_number | customer_number | order_date | required_date | shipped_date | status | 
|--------------|-----------------|------------|---------------|--------------|--------|
| 1            | 1               | 2017-04-09 | 2017-04-13    | 2017-04-12   | Closed |         
| 2            | 2               | 2017-04-15 | 2017-04-20    | 2017-04-18   | Closed |         
| 3            | 3               | 2017-04-16 | 2017-04-25    | 2017-04-20   | Closed |         
| 4            | 3               | 2017-04-18 | 2017-04-28    | 2017-04-25   | Closed |         
----------------------------------------------------------------------------------------

--solution:
SELECT customer_number FROM orders
GROUP BY customer_number
ORDER BY COUNT(1) DESC
LIMIT 1

-- Shortest Distance in a Plane | 
--Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane. Write a query to find the shortest distance between these points rounded to 2 decimals.

| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |

--solution:
SELECT ROUND(MIN(SQRT((t1.x-t2.x)*(t1.x-t2.x) + (t1.y-t2.y)*(t1.y-t2.y))), 2) as shortest
FROM point_2d AS t1, point_2d AS t2
WHERE t1.x!=t2.x OR t1.y!=t2.y

--Exchange Seats | 
--Mary is a teacher in a middle school and she has a table seat storing students’ names and their corresponding seat ids.
--The column id is continuous increment. Mary wants to change seats for the adjacent students.
--Can you write a SQL query to output the result for Mary?
+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+

--solution:
SELECT
IF(id<(SELECT MAX(id) FROM seat),IF(id%2=0,id-1, id+1),IF(id%2=0, id-1, id)) AS id, student
FROM seat
ORDER BY id;

--Customers Who Bought All Products | 
--Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.
--Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
--Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+

--solution:
SELECT customer_id
FROM Customer
GROUP NY customer_id
HAVING count(DISTINCT product_key) = (
    SELECT count(1)
    FROM Product)
    
--    


