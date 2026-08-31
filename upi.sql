USE upi_project;

SELECT
COUNT(*) AS total_rows,
COUNT(DISTINCT user_id) AS unique_users,
MIN(date_clean) AS earliest_date,
MAX(date_clean) AS latest_date,
COUNT(DISTINCT category_clean) AS unique_categories,
COUNT(DISTINCT location_clean) AS unique_cities
FROM upi_transactions;

-- Query 1:- Category Summary(Core analysis)
SELECT
category_clean AS category,
COUNT(*) AS transaction_count,
ROUND(SUM(amount_clean), 2) AS total_value,
ROUND(AVG(amount_clean), 2) AS avg_value,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_of_total_txns
FROM upi_transactions
WHERE is_refund = 'NO'
  AND is_outlier = 'NO'
GROUP BY category_clean
ORDER BY transaction_count DESC;

-- Query 2:- User Ranking (Customer Segmentation)
SELECT 
user_id,
ROUND(SUM(amount_clean),2) as total_spent,
COUNT(*) as txn_count,
ROUND(AVG(amount_clean), 2) as avg_txn,
RANK()OVER(ORDER BY SUM(amount_clean) DESC) as spending_rank,
DENSE_RANK()OVER(ORDER BY COUNT(*) DESC) as frequency_rank
FROM upi_transactions
WHERE is_refund = 'NO'
AND is_outlier = 'NO'
AND YEAR(date_clean) BETWEEN 2021 AND 2024
GROUP BY user_id 
ORDER BY spending_rank
LIMIT 20;

-- Query 3:-Month-on-Month Growth (CTE + LAG)
WITH monthly_totals as (
SELECT
DATE_FORMAT(date_clean, '%Y-%m') as month,
COUNT(*) AS txn_count,
ROUND(SUM(amount_clean), 2) as total_value
FROM upi_transactions
WHERE is_refund = 'NO'
AND is_outlier = 'NO'
AND YEAR(date_clean) BETWEEN 2021 AND 2024
GROUP BY 1
),
with_growth as (
SELECT
month,
txn_count,
total_value,
LAG(txn_count) OVER (ORDER BY month) AS prev_month_count,
ROUND((txn_count - LAG(txn_count) OVER (ORDER BY month)) * 100.0 / NULLIF(LAG(txn_count) OVER (ORDER BY month), 0), 2) as mom_growth_pct
FROM monthly_totals
)
SELECT * FROM with_growth ORDER BY month;

-- Query 4:- Transaction Size Tier (Case When) 
SELECT 
CASE 
WHEN amount_clean<100 THEN 'MICRO(under rs 100)'
WHEN amount_clean BETWEEN 100 AND 500 THEN'SMALL(rs 100 - 500)'
WHEN amount_clean BETWEEN 501 AND 2000 THEN 'MEDIUM(rs 501 - 2000)'
ELSE'LARGE'
END as size_tier,
COUNT(*) as txn_count,
ROUND(SUM(amount_clean),2) as total_value,
ROUND(AVG(amount_clean),2) as avg_value
FROM upi_transactions
WHERE is_refund='NO'
AND is_outlier='NO'
AND YEAR(date_clean) BETWEEN 2021 AND 2024
GROUP BY size_tier
ORDER BY
CASE size_tier
WHEN 'MICRO(under rs 100)' THEN 1
WHEN 'SMALL(rs 100 - 500)' THEN 2
WHEN 'MEDIUM(rs 501 - 2000)' THEN 3
ELSE 4
END;

-- Query 5:- City Analysis (NULLIF + HAVING)
SELECT 
location_clean as city,
COUNT(*) as txn_count,
ROUND(SUM(amount_clean),2) as total_spent,
ROUND(SUM(amount_clean) / NULLIF(COUNT(*), 0), 2) as avg_per_txn,
RANK() OVER (ORDER BY AVG(amount_clean) DESC) as avg_value_rank
FROM upi_transactions
WHERE is_refund = 'NO' 
AND is_outlier = 'NO'
AND location_clean != 'UNKNOWN'
AND YEAR(date_clean) BETWEEN 2021 AND 2024
GROUP BY location_clean
HAVING COUNT(*) > 50
ORDER BY total_spent 
DESC
LIMIT 15;

-- Query 6:- Refund Analysis (ABS + SUBSET Analysis)
SELECT 
category_clean as category,
COUNT(*) as refund_count,
ROUND(SUM(ABS(amount_clean)), 2) AS refund_value
FROM upi_transactions
WHERE is_refund = 'YES'
GROUP BY category
ORDER BY refund_value
DESC;










