

# Retail Sales Analysis



**Short description:** Exploratory analysis on a retail sales dataset to understand sales patterns, top customers, category performance, and temporal trends.



## Project contents

- `data/` — original CSV.

- `sql/` — main script: `SQLProjectP1.sql` (table creation, import, cleaning, exploratory queries).

- `README.md` — this file.



## Objective

Provide actionable insights for merchandising and operations:

- Which categories generate the most revenue

- Top customers and potential loyalty targets

- Seasonal patterns and best-selling months

- Shifts (time-of-day) with highest order volume

## Query

### Create database SQL_Project

```sql
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
```
### Import Data

### Data cleaning
```sql
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

-- Remove rows with nulls in required columns (use transaction when needed)
DELETE FROM retail_sales
WHERE transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

### Data exploration
#### 1) How many sales rows (transactions) do we have?
```sql
SELECT COUNT(*) AS total_transactions
FROM retail_sales;
-- Good to use distinct transaction id if there may be duplicates:
-- SELECT COUNT(DISTINCT transactions_id) AS total_unique_transactions FROM dbo.retail_sales;
```
#### 2) How many unique customers?
```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales;
3) Which categories are sold?
SELECT DISTINCT category
FROM retail_sales
ORDER BY category;
```
#### 4) All sales on specific date (example)
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

#### 5) Clothing transactions in Nov 2022 with quantity >= 4
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;
````

#### 6) Total sales and number of orders per category
```sql
SELECT category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_sales DESC;
```
#### 7) Average age of customers who purchased 'Beauty'
```sql
SELECT ROUND(AVG(CAST(age AS FLOAT)), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
````

#### 8) Transactions where total_sale > 1000
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;
```

#### 9) Number of transactions by gender for each category
```sql
SELECT category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

#### 10) Monthly total sales (year-month)
```sql
SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;
```

#### 11) Average monthly sales across years (e.g., average sales for January across all years)
```sql
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
```

#### 12) Best-selling month for each year
```sql
WITH year_month_sales AS (
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
```

#### 13) Top 5 customers by total sales (SQL Server syntax)
```sql
SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;
```

#### 14) Number of unique customers per category
```sql
SELECT category,
    COUNT(DISTINCT customer_id) AS num_customers
FROM retail_sales
GROUP BY category
ORDER BY num_customers DESC;
```

#### 15) Create shifts (Morning/Afternoon/Evening) and count orders
```sql
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
```

## How to run (SQL Server)

1. Import the CSV into SQL Server: Right-click database → Tasks → Import Flat File → follow wizard.

2. Open `sql/SQLProjectP1.sql` in SSMS and run queries in order.

3. Export results you want to `results/` (CSV or screenshots) and add them to the repo.



## Queries / Explanations

- **Total transactions** — count total rows (transactions).

- **Unique customers** — number of distinct customers.

- **Category performance**  — net sales and order counts per category.

- **Top customers** — top 5 customers by total sales.

- **Monthly & seasonal analysis** — total sales by year-month; best month per year.

- **Shift analysis** — morning/afternoon/evening order volumes.



## Notes & assumptions

- Currency fields use `DECIMAL(12,2)` for accuracy.

- The script removes rows with missing essential fields (ID, date, time, category, quantity, cogs, total\_sale).

- Do not upload sensitive or full proprietary datasets to GitHub public repos. Include a small sample or instructions to download/import.



## 👤 Author

Trinh Nguyen

ng.trinh3023@gmail.com

