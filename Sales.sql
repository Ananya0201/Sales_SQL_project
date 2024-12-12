CREATE DATABASE Retail_sales;
USE retail_sales;

DROP TABLE sales;

CREATE TABLE Sales (
    transactions_id INT PRIMARY KEY ,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(100),
    age INT,
    category VARCHAR(100),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
    );

SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'config_file';

DELETE FROM sales
WHERE quantity = 0 AND price_per_unit = 0;

select count(*) from sales;

-- DATA EXPLORATION

-- HOW MANY SALE RECORD AND HOW MANY CUSTOMERS:

SELECT count(*) as total_sale FROM sales;

SELECT COUNT(distinct customer_id) FROM sales;

-- HOW MANY CATEGORIES WE HAVE?

SELECT category 
from sales 
group by category;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- 1.
SELECT * FROM sales
WHERE sale_date = '2022-11-05';

-- 2.
SELECT * FROM sales 
WHERE YEAR(sale_date) = 2022 and MONTH(sale_date) = 11 
and category = "Clothing" 
and quantity > 3;

-- 3.
SELECT category , SUM(total_sale) 
FROM sales
GROUP BY category
ORDER BY SUM(total_sale) DESC;

-- 4.
SELECT category , AVG(age)
FROM sales
WHERE category = "Beauty";

-- 5.
SELECT *
FROM sales
WHERE total_sale > 1000;

-- 6.
SELECT COUNT(transactions_id) , gender , category
FROM sales
GROUP BY gender, category;

-- 7.
SELECT 
       YEAR(sale_date) AS year,
       MONTH(sale_date) AS month,
       ROUND(AVG(total_sale),2) AS average_sale,
       RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC)
FROM sales
GROUP BY 1,2;
-- ORDER BY 1,3 DESC 


 -- 8.
 SELECT 
   SUM(total_sale), 
   customer_id
 FROM sales
 GROUP BY 2
 ORDER BY 1 DESC
 LIMIT 5;
 
 -- 9.
SELECT
     COUNT(DISTINCT customer_id),
     category
FROM sales
GROUP BY 2;
 
-- 10.
WITH hourly_sale
AS
(
SELECT *,
   CASE
     WHEN HOUR(sale_time) < 12 THEN 'Morning'
     WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening'
   END as Shift
FROM sales
)
SELECT Shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY Shift;
    
-- End of Project






