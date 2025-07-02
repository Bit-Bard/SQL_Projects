-- SQL Retail Sales Analysis
CREATE DATABASE sql_p1;
SHOW databases;

USE sql_p1;

-- CREATE TABLE
DROP TABLE IF exists retail_sales;

CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
    sale_time TIME,
    customer_id INT,
	gender	VARCHAR(50),
    age	INT,
    category VARCHAR(50),
	quantiy	INT,
    price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales LIMIT 10;

SELECT COUNT(*) AS total_rows
FROM retail_sales;
SHOW WARNINGS;

-- Cleaning Data

SELECT * FROM retail_sales WHERE transactions_id IS NULL;

SELECT * FROM retail_sales 
WHERE
	transactions_id IS NULL
    or
    sale_date IS NULL
    or
    sale_time IS NULL
    or
    customer_id IS NULL
    or 
    gender IS NULL
    OR
    age IS NULL 
    or
    category IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    
USE sql_p1;

-- DELETE
DELETE FROM retail_sales 
WHERE
	transactions_id IS NULL
    or
    sale_date IS NULL
    or
    sale_time IS NULL
    or
    customer_id IS NULL
    or 
    gender IS NULL
    OR
    age IS NULL 
    or
    category IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- 2. Data Exploration & Cleaning

-- **Record Count**: Determine the total number of records in the dataset.
-- **Customer Count**: Find out how many unique customers are in the dataset.
-- **Category Count**: Identify all unique product categories in the dataset.
-- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

SELECT COUNT(*) FROM retail_sales;
-- 1987
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
-- 155
SELECT COUNT(DISTINCT category) FROM retail_sales;
-- 3

-- 3. Data Analysis and Findings
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT COUNT(*) FROM retail_sales WHERE sale_date='2022-11-05';

-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
SELECT * 
FROM retail_sales  
WHERE category = 'Clothing'  
  AND quantiy >= 4  
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
  
-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
SELECT category, 
	   SUM(total_sale) AS net_sale ,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category='Beauty'; 

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
SELECT * FROM retail_sales 
WHERE total_sale>1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
SELECT category , gender, COUNT(transactions_id) 
FROM retail_sales 
group by category, gender
ORDER BY 1;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_sales
WHERE rnk = 1;

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
SELECT category, COUNT(DISTINCT customer_id) as cnt_unique
FROM retail_sales
GROUP BY category;

-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
-- CTC hourly_sale reason we can't use order by directly
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders   
FROM hourly_sale
GROUP BY shift;