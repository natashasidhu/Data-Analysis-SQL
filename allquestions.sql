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





 
