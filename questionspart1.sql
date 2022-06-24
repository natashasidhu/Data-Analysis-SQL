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
    
--  Active Businesses | Medium |
--Write an SQL query to find all active businesses.
--An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.
--Events table:
+-------------+------------+------------+
| business_id | event_type | occurences |
+-------------+------------+------------+
| 1           | reviews    | 7          |
| 3           | reviews    | 3          |
| 1           | ads        | 11         |
| 2           | ads        | 7          |
| 3           | ads        | 6          |
| 1           | page views | 3          |
| 2           | page views | 12         |
+-------------+------------+------------+

--solution:
SELECT business_id
FROM (SELECT a.business_id, a.event_type, a.occurences, b.event_avg  -- sub 2
      FROM Events a LEFT JOIN
        (SELECT event_type, AVG(occurences) event_avg   -- sub 1
         FROM Events
         GROUP BY event_type) b ON
      a.event_type = b.event_type) tmp
WHERE occurences > event_avg
GROUP BY business_id
HAVING COUNT(event_type) > 1

--Find the Team Size | Easy |
--Employee Table:
+-------------+------------+
| employee_id | team_id    |
+-------------+------------+
|     1       |     8      |
|     2       |     8      |
|     3       |     8      |
|     4       |     7      |
|     5       |     9      |
|     6       |     9      |
+-------------+------------+
--Write an SQL query to find the team size of each of the employees.

--solution:

SELECT employee_id, b.team_size
FROM employee e
JOIN
(
SELECT team_id, count(team_id) AS team_size
FROM employee
GROUP BY team_id) b
ON e.team_id = b.team_id

--Customers Who Bought Products A and B but Not C | Medium | 
--Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Diana         |
| 3           | Elizabeth     |
| 4           | Jhon          |
+-------------+---------------+
--Orders table:
+------------+--------------+---------------+
| order_id   | customer_id  | product_name  |
+------------+--------------+---------------+
| 10         |     1        |     A         |
| 20         |     1        |     B         |
| 30         |     1        |     D         |
| 40         |     1        |     C         |
| 50         |     2        |     A         |
| 60         |     3        |     A         |
| 70         |     3        |     B         |
| 80         |     3        |     D         |
| 90         |     4        |     C         |
+------------+--------------+---------------+
--Write an SQL query to report the customerid and customername of customers who bought products “A”, “B” but did not buy the product “C” 
--Return the result table ordered by customer_id.

--solution:
WITH t1 AS
(
SELECT customer_id
FROM orders
WHERE product_name = 'B' AND
customer_id IN (SELECT customer_id
FROM orders
WHERE product_name = 'A'))

SELECT t1.customer_id, c.customer_name
FROM t1 JOIN customers c
ON t1.customer_id = c.customer_id
WHERE t1.customer_id != all(SELECT customer_id
FROM orders
WHERE product_name = 'C')

--Calculate Salaries | Medium |
--Salaries table:
+------------+-------------+---------------+--------+
| company_id | employee_id | employee_name | salary |
+------------+-------------+---------------+--------+
| 1          | 1           | Tony          | 2000   |
| 1          | 2           | Pronub        | 21300  |
| 1          | 3           | Tyrrox        | 10800  |
| 2          | 1           | Pam           | 300    |
| 2          | 7           | Bassem        | 450    |
| 2          | 9           | Hermione      | 700    |
| 3          | 7           | Bocaben       | 100    |
| 3          | 2           | Ognjen        | 2200   |
| 3          | 13          | Nyancat       | 3300   |
| 3          | 15          | Morninngcat   | 1866   |
+------------+-------------+---------------+--------+

--Write an SQL query to find the salaries of the employees after applying taxes.

--The tax rate is calculated for each company based on the following criteria:

--0% If the max salary of any employee in the company is less than 1000$.
--24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
--49% If the max salary of any employee in the company is greater than 10000$.
--Return the result table in any order. Round the salary to the nearest integer.

--solution:
SELECT Salaries.company_id, Salaries.employee_id, Salaries.employee_name,
    ROUND(CASE WHEN salary_max<1000 THEN Salaries.salary
               WHEN salary_max>=1000 AND salary_max<=10000 THEN Salaries.salary * 0.76
               ELSE Salaries.salary * 0.51 END, 0) AS salary
FROM Salaries INNER JOIN (
    SELECT company_id, MAX(salary) AS salary_max
    FROM Salaries
    GROUP BY company_id) AS t
ON Salaries.company_id = t.company_id

--Result table:
+------------+-------------+---------------+--------+
| company_id | employee_id | employee_name | salary |
+------------+-------------+---------------+--------+
| 1          | 1           | Tony          | 1020   |
| 1          | 2           | Pronub        | 10863  |
| 1          | 3           | Tyrrox        | 5508   |
| 2          | 1           | Pam           | 300    |
| 2          | 7           | Bassem        | 450    |
| 2          | 9           | Hermione      | 700    |
| 3          | 7           | Bocaben       | 76     |
| 3          | 2           | Ognjen        | 1672   |
| 3          | 13          | Nyancat       | 2508   |
| 3          | 15          | Morninngcat   | 5911   |
+------------+-------------+---------------+--------+

--Group Sold Products By The Date | Easy | 
--Activities table:
+------------+-------------+
| sell_date  | product     |
+------------+-------------+
| 2020-05-30 | Headphone   |
| 2020-06-01 | Pencil      |
| 2020-06-02 | Mask        |
| 2020-05-30 | Basketball  |
| 2020-06-01 | Bible       |
| 2020-06-02 | Mask        |
| 2020-05-30 | T-Shirt     |
+------------+-------------+
--Write an SQL query to find for each date, the number of distinct products sold and their names.
--The sold-products names for each date should be sorted lexicographically. Return the result table ordered by sell_date.

--solution:

SELECT sell_date, COUNT(DISTINCT product) AS num_sold, group_concat(DISTINCT product) AS products
FROM activities
GROUP BY 1
ORDER BY 1

--Result table:
+------------+----------+------------------------------+
| sell_date  | num_sold | products                     |
+------------+----------+------------------------------+
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |
+------------+----------+------------------------------+
