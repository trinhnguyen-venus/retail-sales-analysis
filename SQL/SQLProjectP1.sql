-- ===== SQL PROJECT 1: RETAIL SALES ANALYSIS =====

-- CREATE DATABASE SQL_Project_1;
CREATE DATABASE SQL_Project_1

-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT);

-- ===== IMPORT DATA =====

-- Basic validation: find rows with NULL in required columns =====
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Optional: remove rows with nulls in required columns (use transaction when needed)
DELETE FROM retail_sales
WHERE transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- ===== DATA EXPLORATION QUERIES =====

-- 1) How many sales rows (transactions) do we have?
SELECT COUNT(*) AS total_transactions
FROM retail_sales;
-- Good to use distinct transaction id if there may be duplicates:
-- SELECT COUNT(DISTINCT transactions_id) AS total_unique_transactions FROM dbo.retail_sales;

-- 2) How many unique customers?
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales;

-- 3) Which categories are sold?
SELECT DISTINCT category
FROM retail_sales
ORDER BY category;

-- 4) All sales on specific date (example)
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 5) Clothing transactions in Nov 2022 with quantity >= 4
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;

-- 6) Total sales and number of orders per category
SELECT category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_sales DESC;

-- 7) Average age of customers who purchased 'Beauty'
SELECT ROUND(AVG(CAST(age AS FLOAT)), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 8) Transactions where total_sale > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- 9) Number of transactions by gender for each category
SELECT category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;

-- 10) Monthly total sales (year-month)
SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;

-- 11) Average monthly sales across years (e.g., average sales for January across all years)
WITH monthly_totals AS (
  SELECT YEAR(sale_date) AS year, MONTH(sale_date) AS month, SUM(total_sale) AS total_sales
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT
  month,
  ROUND(AVG(total_sales), 2) AS avg_sales_across_years
FROM monthly_totals
GROUP BY month
ORDER BY month;

-- 12) Best-selling month for each year
;WITH year_month_sales AS (
  SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS total_sales,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale) DESC) AS rk
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year, month, total_sales
FROM year_month_sales
WHERE rk = 1
ORDER BY year;

-- 13) Top 5 customers by total sales (SQL Server syntax)
SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- 14) Number of unique customers per category
SELECT category,
    COUNT(DISTINCT customer_id) AS num_customers
FROM retail_sales
GROUP BY category
ORDER BY num_customers DESC;

-- 15) Create shifts (Morning/Afternoon/Evening) and count orders
SELECT
  CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(*) AS total_orders
FROM retail_sales
GROUP BY
  CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END
ORDER BY total_orders DESC;

-- END OF SCRIPT
