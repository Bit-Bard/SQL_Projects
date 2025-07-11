# Begnieer Sql Project :  Retail Sales Analysis ,  Coffee Sales Analysis

## Retail Sales Analysis SQL Project 1 

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_sales_analysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_p1;
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
```
### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
```sql
SELECT COUNT(*) FROM retail_sales WHERE sale_date='2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * 
FROM retail_sales  
WHERE category = 'Clothing'  
  AND quantiy >= 4  
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
```
  
3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, 
	   SUM(total_sale) AS net_sale ,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category='Beauty'; 
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales 
WHERE total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category , gender, COUNT(transactions_id) 
FROM retail_sales 
group by category, gender
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, COUNT(DISTINCT customer_id) as cnt_unique
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
-- CTC hourly_sale reason we can't use ORDER BY directly
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


# Retail Sales Analysis SQL Project 1 

## Project Overview

**Project Title**: Coffee Sales Analysis  
**Level**: Beginner  
**Database**: `coffee_sales_analysis`

The goal of this project is to analyze the sales data of Monday Coffee, a company that has been selling its products online since January 2023, and to recommend the top three major cities in India for opening new coffee shop locations based on consumer demand and sales performance.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_p2`.
- **Table Creation** : Sales_table , customer_table, product_table , city_table
```sql
-- CREATE 4 table city, products, customers, sales

CREATE TABLE city
(
	city_id INT PRIMARY KEY,
    city_name VARCHAR(50),
    population BIGINT,
    estimated_rent FLOAT,
    city_rank INT
);

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE products(
	product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    Price float
);

CREATE TABLE sales(
	sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_id INT,
    customer_id INT,
    total FLOAT,
    rating INT,
    CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Load the repective data in respective Table 

SELECT * FROM city;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;
```

### Entity-Relationship Diagram
![ERD](Coffee%20Sales%20Analysis/Screenshot%202025-07-07%20150153.png)

### 2. Data Analysis & Findings

1. **Coffee Consumers Count**
How many people in each city are estimated to consume coffee, given that 25% of the population does?
```sql
SELECT city_name, 
	   ROUND((population*0.25)/1000000,2) AS Coffee_Lovers,
       city_rank
FROM city
ORDER BY 2 DESC;
```

Q.2 Total Revenue from Coffee Sales
What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
```sql
SELECT 
	ci.city_name ,
	SUM(s.total) as total_revenue
FROM sales AS s
JOIN customers as c
ON s.customer_id = c.customer_id

JOIN city AS ci
ON ci.city_id = c.city_id
	WHERE YEAR(s.sale_date) = 2023 AND QUARTER(s.sale_date) = 4
GROUP BY 1
ORDER BY 2 DESC;
```

Q.3 Sales Count for Each Product
How many units of each coffee product have been sold?
```sql
SELECT 
	p.product_name ,
	COUNT(s.sale_id) AS total_order
FROM products AS p
LEFT JOIN sales as s
ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 2 desc;
```

Q.4 Average Sales Amount per City
 What is the average sales amount per customer in each city? city abd total sale. no cx in each these city
 ```sql
SELECT 
	ci.city_name ,
	SUM(s.total) as total_revenue,
    COUNT(DISTINCT s.customer_id) as Total_customer,
    SUM(s.total)/ COUNT(DISTINCT s.customer_id) AS Avg_Sale_pr_customer
FROM sales AS s
JOIN customers as c
ON s.customer_id = c.customer_id
JOIN city AS ci
ON ci.city_id = c.city_id
GROUP BY 1
ORDER BY 2 DESC;
```

Q.5 City Population and Coffee Consumers (25%)
Provide a list of cities along with their populations and estimated coffee consumers.
return city_name, total current cx, estimated coffee consumers (25%)
```sql
WITH city_table as 
(
	SELECT 
		city_name,
		ROUND((population * 0.25)/1000000, 2) as coffee_consumers
	FROM city
),
customers_table
AS
(
	SELECT 
		ci.city_name,
		COUNT(DISTINCT c.customer_id) as unique_cx
	FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
)
SELECT 
	customers_table.city_name,
	city_table.coffee_consumers as coffee_consumer_in_millions,
	customers_table.unique_cx
FROM city_table
JOIN 
customers_table
ON city_table.city_name = customers_table.city_name;
```

Q6 Top Selling Products by City
What are the top 3 selling products in each city based on sales volume?
```sql
SELECT *
FROM
(SELECT 
	ci.city_name,
    p.product_name,
    COUNT(s.sale_id) AS Total_Orders,
	DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC ) AS ranking
FROM sales as s
JOIN products as p
ON s.product_id = p.product_id
JOIN customers as c
ON c.customer_id = s.customer_id
JOIN city as ci
ON ci.city_id = c.city_id
GROUP BY 1, 2) 
AS t1
WHERE ranking <=3;
```

Q.7 Customer Segmentation by City
How many unique customers are there in each city who have purchased coffee products?
```sql
SELECT 
	ci.city_name,
	COUNT(DISTINCT c.customer_id) as unique_cx
FROM city as ci
LEFT JOIN
customers as c
ON c.city_id = ci.city_id
JOIN sales as s
ON s.customer_id = c.customer_id
WHERE 
	s.product_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
GROUP BY 1;
```

Q.8 Average Sale vs Rent
Find each city and their average sale per customer and avg rent per customer
```sql
SELECT 
    ci.city_name,
    SUM(s.total) AS total_revenue,
    COUNT(DISTINCT s.customer_id) AS total_customers,

    ROUND(
        ci.estimated_rent / COUNT(DISTINCT s.customer_id),
        2
    ) AS avg_rent_per_customer,

    ROUND(
        SUM(s.total) / COUNT(DISTINCT s.customer_id),
        2
    ) AS avg_sale_per_customer

FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN city ci ON ci.city_id = c.city_id

GROUP BY ci.city_name, ci.estimated_rent
ORDER BY 4 DESC;
```
Q.9 Monthly Sales Growth
Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly) by each city
```sql
WITH Monthly_sales AS (
  SELECT
    ci.city_name,
    MONTH(s.sale_date) AS months,
    YEAR(s.sale_date) AS Years,
    SUM(s.total) AS total_sale
  FROM sales AS s
  JOIN customers AS c ON c.customer_id = s.customer_id
  JOIN city AS ci ON ci.city_id = c.city_id
  GROUP BY ci.city_name, MONTH(s.sale_date), YEAR(s.sale_date)
),
growth_ratio AS (
  SELECT
    city_name,
    months,
    Years,
    total_sale AS Current_month_sale,
    LAG(total_sale, 1) OVER (
      PARTITION BY city_name ORDER BY Years, months
    ) AS last_month_sale
  FROM Monthly_sales
)
SELECT
  city_name,
  months,
  Years,
  Current_month_sale,
  last_month_sale,
  ROUND(
    (Current_month_sale - last_month_sale) / last_month_sale * 100,
    2
  ) AS growth_percentage
FROM growth_ratio
WHERE last_month_sale IS NOT NULL;
```

Q.10 Market Potential Analysis
Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
```sql
WITH city_table AS (
	SELECT 
		ci.city_name,
		SUM(s.total) AS total_revenue,
		COUNT(DISTINCT s.customer_id) AS total_cx,
		ROUND(
			SUM(s.total) / COUNT(DISTINCT s.customer_id),
			2
		) AS avg_sale_pr_cx
	FROM sales AS s
	JOIN customers AS c ON s.customer_id = c.customer_id
	JOIN city AS ci ON ci.city_id = c.city_id
	GROUP BY ci.city_name
),
city_rent AS (
	SELECT 
		city_name, 
		estimated_rent,
		ROUND((population * 0.25) / 1000000, 3) AS estimated_coffee_consumer_in_millions
	FROM city
)
SELECT 
	cr.city_name,
	ct.total_revenue,
	cr.estimated_rent AS total_rent,
	ct.total_cx,
	cr.estimated_coffee_consumer_in_millions,
	ct.avg_sale_pr_cx,
	ROUND(
		cr.estimated_rent / ct.total_cx,
		2
	) AS avg_rent_per_cx
FROM city_rent AS cr
JOIN city_table AS ct ON cr.city_name = ct.city_name
ORDER BY ct.total_revenue DESC;
```
## Findings:
City 1: Pune
	1.Average rent per customer is very low.
	2.Highest total revenue.
	3.Average sales per customer is also high.

City 2: Delhi
	1.Highest estimated coffee consumers at 7.7 million.
	2.Highest total number of customers, which is 68.
	3.Average rent per customer is 330 (still under 500).

City 3: Jaipur
	1.Highest number of customers, which is 69.
	2.Average rent per customer is very low at 156.
	3.Average sales per customer is better at 11.6k.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Dhruv Devaliya-->Bit-Bard

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
Thank you for your support, and I look forward to connecting with you!

