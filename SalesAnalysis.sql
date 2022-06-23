-- Sales Analysis I | 
--Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+

--Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+

--Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.

--solution:
SELECT seller_id
FROM Sales
GROUP BY seller_id
HAVING SUM(price) = (SELECT SUM(price)
                    FROM Sales
                    GROUP BY seller_id
                    ORDER BY SUM(price) DESC
                    LIMIT 1)
   
 --Result table:
+-------------+
| seller_id   |
+-------------+
| 1           |
| 3           |
+-------------+

--Sales Analysis II |
--Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.

--solution:

SELECT DISTINCT s.buyer_id
FROM Sales s LEFT JOIN Product p ON
    s.product_id = p.product_id
WHERE p.product_name = 'S8' AND
      s.buyer_id NOT IN (SELECT s.buyer_id
                        FROM Sales s LEFT JOIN Product p ON
                            s.product_id = p.product_id
                        WHERE p.product_name = 'iPhone')
                        
--Result table:
+-------------+
| buyer_id    |
+-------------+
| 1           |
+-------------+

--Sales Analysis III |
--Report the products that were only sold in spring 2019. That is, between 2019-01-01 and 2019-03-31 inclusive. Select the product that were only sold in spring 2019.

--solution:

(SELECT DISTINCT s.product_id, p.product_name
FROM Sales s LEFT JOIN Product p ON
    s.product_id = p.product_id
WHERE s.sale_date >= '2019-01-01' AND
      s.sale_date <= '2019-03-31')
EXCEPT 
(SELECT DISTINCT s.product_id, p.product_name
FROM Sales s LEFT JOIN Product p ON
    s.product_id = p.product_id
WHERE s.sale_date < '2019-01-01' OR
      s.sale_date > '2019-03-31')
   
 --Result table:
+-------------+--------------+
| product_id  | product_name |
+-------------+--------------+
| 1           | S8           |
+-------------+--------------+  
      
