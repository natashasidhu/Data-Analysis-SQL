--Question. MEDIUM 
-- Write an SQL query to find all numbers that appear at least three times consecutively.
--Logs table:
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
--Result table:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+

--solution:
SELECT DISTINCT a.num AS consecutivenum FROM logs a
LEFT JOIN logs b ON a.id=b.id+1 
LEFT JOIN logs c ON a.id=c.id+2
WHERE a.num=b.num AND a.num=c.num

--question EASY
--The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.
+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
--Given the Employee table, write a SQL query that finds out employees who earn more than their managers. 

--Solution:
SELECT E.Name as "Employee"
FROM Employee E
JOIN Employee M
ON E.ManagerId = M.Id
AND E.Salary > M.Salary;

--question MEDIUM
--Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+

--solution:
SELECT Email
FROM Person
GROUP BY Email
HAVING count(*) > 1

--question MEDIUM
--The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
--The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
--Write a SQL query to find employees who have the highest salary in each of the departments.

--solution:

SELECT Department.Name AS Department, Employee.Name AS Employee, Salary
FROM Employee
JOIN Department
ON Employee.DepartmentId = Department.Id
WHERE (DepartmentId, Salary) IN(
        SELECT  DepartmentId, MAX(Salary) AS Salary
        FROM Employee
        GROUP BY DepartmentId
        );
        
--same question HARD
--Write a SQL query to find employees who earn the top three salaries in each of the department. 
--solution:

WITH department_ranking AS (
SELECT Name AS Employee, Salary ,DepartmentId
  ,DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) AS rnk
FROM Employee
)

SELECT d.Name AS Department, r.Employee, r.Salary
FROM department_ranking AS r
JOIN Department AS d
ON r.DepartmentId = d.Id
WHERE r.rnk <= 3
ORDER BY d.Name ASC, r.Salary DESC;

--question EASY
--Write an SQL query to find all dates’ id with higher temperature compared to its previous dates (yesterday).
Weather
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+

--Solution:
SELECT t.Id
FROM Weather t
JOIN Weather y
ON DATEDIFF(t.recordDate, y.recordDate) = 1 AND
t.temperature > y.temperature;

--question





 
