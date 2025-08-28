Retail sales exploration using SQL

\# Retail Sales Analysis



\*\*Short description:\*\* Exploratory analysis on a retail sales dataset to understand sales patterns, top customers, category performance, and temporal trends.



\## Project contents

\- `data/` — original CSV.

\- `sql/` — main script: `SQLProjectP1.sql` (table creation, import, cleaning, exploratory queries).

\- `results/` — example output files (CSV / images) exported from queries.

\- `README.md` — this file.



\## Objective

Provide actionable insights for merchandising and operations:

\- Which categories generate the most revenue

\- Top customers and potential loyalty targets

\- Seasonal patterns and best-selling months

\- Shifts (time-of-day) with highest order volume



\## How to run (SQL Server)

1\. Import the CSV into SQL Server: Right-click database → Tasks → Import Flat File → follow wizard.

2\. Open `sql/SQLProjectP1.sql` in SSMS and run queries in order.

3\. Export results you want to `results/` (CSV or screenshots) and add them to the repo.



\## Queries / Explanations

\- \*\*Total transactions\*\* — count total rows (transactions).

\- \*\*Unique customers\*\* — number of distinct customers.

\- \*\*Category performance\*\* — net sales and order counts per category.

\- \*\*Top customers\*\* — top 5 customers by total sales.

\- \*\*Monthly \& seasonal analysis\*\* — total sales by year-month; best month per year.

\- \*\*Shift analysis\*\* — morning/afternoon/evening order volumes.



\## Notes \& assumptions

\- Currency fields use `DECIMAL(12,2)` for accuracy.

\- The script removes rows with missing essential fields (ID, date, time, category, quantity, cogs, total\_sale).

\- Do \*\*not\*\* upload sensitive or full proprietary datasets to GitHub public repos. Include a small sample or instructions to download/import.



\## 👤 Author

Trinh Nguyen

ng.trinh3023@gmail.com

