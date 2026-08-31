India UPI Spending Behaviour Analysis

Project Overview:
Analysed 15,900 raw transaction records from the BudgetWise Personal Finance dataset (150 users, multi-year data) to understand UPI spending patterns by category, city, and transaction size. Includes data cleaning, SQL analysis, Excel pivot tables, a Power BI dashboard, and a linear regression trend-fit analysis of monthly spending.

Tools:
●	Excel -- data cleaning + pivot table analysis (no dashboard; Power BI is the single dashboard for this project)
●	SQL (MySQL Workbench) -- 6 analytical queries
●	Power BI -- interactive dashboard with live link below
●	Python -- distribution analysis (boxplot) and a linear regression trend fit (R²) on monthly totals -- kept deliberately narrow to complement, not duplicate, Excel/Power BI. No forward-looking forecast.

Dataset:
BudgetWise Personal Finance Dataset (Kaggle)
15,900 raw rows | 900 duplicates removed
150 users | 9 columns | Multi-year date range (2021-2024)

Data Quality Issues Fixed:
●	900 exact duplicate rows removed
●	4 mixed date formats in one column standardised
●	5 amount formats (plain, Rs., $, INR, rupee symbol) cleaned
●	127 negatives flagged as refunds (not deleted)
●	76 sentinel values (999999999) flagged as outliers
●	31 raw category variants standardised to 15 categories
●	9 raw payment mode variants standardised to 4 modes
●	20 raw city variants (codes + case) standardised to 10 cities, incl. Pune
●	1,262 null cities filled via each user's most common city

Key Findings:
●	Food has the highest transaction count (3,050 txns, 20.40% of total), but Bonus has the highest average value (Rs 15,319.54) -- volume and value are driven by different categories.
●	Monthly totals show a mild upward drift (yearly spend: Rs 4.52Cr in 2021 -> Rs 5.06Cr in 2022 -> Rs 4.72Cr in 2023 -> Rs 5.14Cr in 2024), but month-to-month values are noisy: the linear trend fit gives R² = 0.091, meaning the straight-line trend explains only ~9% of month-to-month variation -- spending is closer to flat/volatile than steadily rising.
●	Others has the widest spending spread (IQR ≈ Rs 7,574, from Rs 3,819 to Rs 11,393), while Rent has the most residual outliers on the boxplot (49 points beyond the whiskers, even after IQR-based outlier flagging already removed the extreme values) -- Rent is volatile at the low-probability/high-amount end more than any other category.
●	Refunds are concentrated in Rent (31 refunds, Rs 24,000 refund value), followed by Food (28 refunds, Rs 20,500).
●	Transaction-size skew is extreme: LARGE txns (>Rs 2,000) are only 12,139 of ~14,949 rows across the four tiers by count but ~98.7% of total value (Rs 19.19Cr of Rs 19.44Cr) -- most spending volume sits in a small number of high-value transactions.
●	Jaipur has the highest average transaction value (Rs 14,070.16) despite Pune having the highest total city spend (Rs 1.94Cr) and highest transaction count (1,441).

View Power BI Dashboard:
[Click here to view  dashboard](https://github.com/SushilMali2611/India-UPI-Spending-Behaviour-Analysis/blob/main/05_z_India_UPI_Spending_Behavior_Analysis.png)
SQL Queries (MySQL Workbench)

See 04_upi.sql:
●	Query 1: Category summary (GROUP BY + window % calc)
●	Query 2: User spending rank (RANK + DENSE_RANK)
●	Query 3: Month-on-month growth (CTE + LAG + DATE_FORMAT)
●	Query 4: Transaction size tiers (CASE WHEN)
●	Query 5: City spending analysis (NULLIF + HAVING)
●	Query 6: Refund analysis by category (ABS + subset analysis)

Python -- EDA & Trend Analysis:
●	01_data_cleaning.ipynb: full cleaning pipeline (see Data Quality section)
●	02_eda_visualisation.ipynb: monthly trend chart + boxplot of amount distribution by category (outlier spread analysis)
●	03_trend_model.ipynb: linear regression trend fit on monthly totals (R²)

Trend Model:
Linear regression fit on monthly transaction totals (2021-2024, 48 months).
R2 score: 0.091 (weak linear fit -- slope is positive, roughly +Rs 11,408/month, but monthly totals swing enough that a straight line explains only ~9% of the variation).
Describes how well spending follows a linear trend across the observed months.Stated purely as a fit-strength.

