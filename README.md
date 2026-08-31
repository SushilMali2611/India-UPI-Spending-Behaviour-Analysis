❄️ India UPI Spending Behaviour Analysis

An end-to-end analytics project exploring UPI transaction behaviour across India — spanning data cleaning, SQL analysis, Excel pivot tables, a Power BI dashboard, and a Python trend-fit model.

Purpose
This project analyses 15,900 raw UPI transaction records from the BudgetWise Personal Finance dataset (150 users, multi-year data, 2021-2024) to understand spending patterns by category, city, and transaction size. It is intended for use by personal-finance analysts, fintech product teams, and anyone studying digital-payment behaviour in India who wants a reproducible pipeline from messy raw data to a decision-ready dashboard.

Tech Stack
●	📊 Power BI Desktop — main dashboard/visualisation layer (single interactive dashboard, live link below)
●	📂 Excel — data cleaning + pivot table analysis (no dashboard sheet; Power BI is the single dashboard for this project)
●	🛢️ SQL (MySQL Workbench) — 6 analytical queries (window functions, CTEs, RANK/DENSE_RANK, CASE WHEN tiering)
●	🐍 Python (Pandas, Matplotlib, Seaborn, scikit-learn) — data cleaning pipeline, distribution/outlier analysis (boxplot), and a linear regression trend fit (R²) on monthly totals — kept deliberately narrow to complement, not duplicate, Excel/Power BI. No forward-looking forecast.
●	📁 File formats — .csv (clean data), .sql (queries), .xlsx (pivots), .ipynb (notebooks), .pbix (dashboard), .png (chart/dashboard previews)

Data Source
Source: BudgetWise Personal Finance Dataset (Kaggle).
15,900 raw rows | 900 duplicates removed | 150 users | 9 columns | multi-year date range (2021-2024). Each row is a single UPI transaction with date, category, payment mode, location, and amount, before cleaning.

Features / Highlights

Business Problem
Raw UPI transaction exports are messy — mixed date formats, inconsistent currency notations, misspelled categories/cities, and sentinel/refund values mixed in with genuine spend. Without cleaning and structure, it's hard to answer basic questions like which categories drive spend, which cities have the highest-value transactions, or whether spending is trending up.

Goal of the Project
●	Build a reproducible cleaning pipeline that fixes duplicate, date, amount, category, payment-mode, and location issues.
●	Answer core spend questions via SQL (category summary, user ranking, month-on-month growth, size tiers, city analysis, refunds).
●	Surface the findings in a single interactive Power BI dashboard.
●	Use Python only where Excel/Power BI can't — distribution/outlier visualisation and a linear trend fit.

Walkthrough of Key Visuals / Queries
●	Category Summary (SQL Query 1) — transaction count, total value, avg value, and % of total per category.
●	User Ranking (SQL Query 2) — top 20 users by spend and frequency, with RANK/DENSE_RANK.
●	Month-on-Month Growth (SQL Query 3) — CTE + LAG to compute month-over-month % change, 2021-2024.
●	Transaction Size Tiers (SQL Query 4) — MICRO/SMALL/MEDIUM/LARGE buckets by amount.
●	City Analysis (SQL Query 5) — spend and avg-value ranking across 10 cities.
●	Refund Analysis (SQL Query 6) — refund count and value by category.
●	Monthly Trend Chart (Python) — total spend by month, 2021-2024.
●	Boxplot by Category (Python) — spread and outliers in transaction amount per category.
●	Live Power BI Dashboard — all of the above surfaced interactively with slicers by city/category/date.

Business Impact & Insights
●	Category strategy: Food drives the most transactions (20.40% of volume) but Bonus payouts carry the highest average ticket size (Rs 15,319.65) — volume and value need different playbooks.
●	Growth signal is weak, not absent: yearly totals drifted up (Rs 4.52Cr → 5.06Cr → 4.72Cr → 5.14Cr, 2021-2024), but a linear fit only explains ~9% of month-to-month variation (R² = 0.091) — spend is closer to 

flat/volatile than steadily rising.
●	Risk concentration: Rent is the biggest source of refunds (31 refunds, Rs 24,000) and has the most amount outliers on the boxplot (49 beyond the whiskers) — the category most worth auditing for billing/refund issues.
●	Spend concentration: LARGE transactions (>Rs 2,000) are ~81% of transaction count but ~98.7% of total value — a small share of high-value transactions dominates total spend.
●	Regional targeting: Jaipur has the highest average transaction value (Rs 14,070.16) even though Pune leads on total spend and transaction count — useful for city-level campaign or partner-bank targeting.

Data Quality Issues Fixed
●	900 exact duplicate rows removed
●	4 mixed date formats in one column standardised
●	5 amount formats (plain, Rs., $, INR, rupee symbol) cleaned
●	127 negatives flagged as refunds (not deleted)
●	76 sentinel values (999999999) flagged as outliers
●	31 raw category variants standardised to 15 categories
●	9 raw payment mode variants standardised to 4 modes
●	20 raw city variants (codes + case) standardised to 10 cities, incl. Pune
●	1,262 null cities filled via each user's most common city

Key Findings
●	Food has the highest transaction count (3,050 txns, 20.40% of total), but Bonus has the highest average value (Rs 15,319.54) -- volume and value are driven by different categories.
●	Monthly totals show a mild upward drift (yearly spend: Rs 4.52Cr in 2021 -> Rs 5.06Cr in 2022 -> Rs 4.72Cr in 2023 -> Rs 5.14Cr in 2024), but month-to-month values are noisy: the linear trend fit gives R² = 0.091, meaning the straight-line trend explains only ~9% of month-to-month variation -- spending is closer to flat/volatile than steadily rising.
●	Others has the widest spending spread (IQR ≈ Rs 7,574, from Rs 3,819 to Rs 11,393), while Rent has the most residual outliers on the boxplot (49 points beyond the whiskers, even after IQR-based outlier flagging already removed the extreme values) -- Rent is volatile at the low-probability/high-amount end more than any other category.
●	Refunds are concentrated in Rent (31 refunds, Rs 24,000 refund value), followed by Food (28 refunds, Rs 20,500).
●	Transaction-size skew is extreme: LARGE txns (>Rs 2,000) are only 12,139 of ~14,949 rows across the four tiers by count but ~98.7% of total value (Rs 19.19Cr of Rs 19.44Cr) -- most spending volume sits in a small number of high-value transactions.
●	Jaipur has the highest average transaction value (Rs 14,070.16) despite Pune having the highest total city spend (Rs 1.94Cr) and highest transaction count (1,441).

View Power BI Dashboard
[Click here to view  dashboard](YOUR_POWER_BI_LINK_HERE)

SQL Queries (MySQL Workbench)
See 04_upi.sql:
●	Query 1: Category summary (GROUP BY + window % calc)
●	Query 2: User spending rank (RANK + DENSE_RANK)
●	Query 3: Month-on-month growth (CTE + LAG + DATE_FORMAT)
●	Query 4: Transaction size tiers (CASE WHEN)
●	Query 5: City spending analysis (NULLIF + HAVING)
●	Query 6: Refund analysis by category (ABS + subset analysis)

Python -- EDA & Trend Analysis
●	01_data_cleaning.ipynb: full cleaning pipeline (see Data Quality section)
●	02_eda_visualisation.ipynb: monthly trend chart + boxplot of amount distribution by category (outlier spread analysis)
●	03_trend_model.ipynb: linear regression trend fit on monthly totals (R² only -- no forward forecast)

Trend Model
Linear regression fit on monthly transaction totals (2021-2024, 48 months).
R2 score: 0.091 (weak linear fit -- slope is positive, roughly +Rs 11,408/month, but monthly totals swing enough that a straight line explains only ~9% of the variation).
Describes how well spending follows a linear trend across the observed months. Not used to project future months -- stated purely as a fit-strength / directional indicator, not a forecast.

Screenshots / Demo
[Add a Power BI dashboard screenshot here, e.g. dashboard_preview.png]
[Add chart_trend.png and chart_boxplot.png previews here]
