Project Employees I | 
--Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

--Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+

--Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

--solution:

SELECT
    p.project_id,
    ROUND(AVG(e.experience_years),2) average_years
FROM
    Project p JOIN Employee e ON
    p.employee_id = e.employee_id
GROUP BY
    p.project_id
    
--Result table:
+-------------+---------------+
| project_id  | average_years |
+-------------+---------------+
| 1           | 2.00          |
| 2           | 2.50          |
+-------------+---------------+

--Project Employees II |
--Write an SQL query that reports all the projects that have the most employees.

--solution:

SELECT project_id
FROM Project
GROUP BY project_id
HAVING COUNT(employee_id) = (SELECT COUNT(employee_id)
                            FROM Project
                            GROUP BY project_id
                            ORDER BY COUNT(employee_id) DESC
                            LIMIT 1)
                            
 --Result table:
+-------------+
| project_id  |
+-------------+
| 1           |
+-------------+

-- Project Employees III |
--Write an SQL query that reports the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.

--solution:

SELECT
    p.project_id,
    e.employee_id
FROM
    Project p LEFT JOIN Employee e ON
    p.employee_id = e.employee_id
WHERE (p.project_id,
       e.experience_years) IN (SELECT
                                p.project_id,
                                MAX(e.experience_years)
                            FROM
                                Project p JOIN Employee e ON
                                p.employee_id = e.employee_id
                            GROUP BY
                                p.project_id)
                                
  --Result table:
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+                              
