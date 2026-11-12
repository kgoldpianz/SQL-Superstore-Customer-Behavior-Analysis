# SQL-Superstore-Customer-Behavior-Analysis
SQL Server data analysis project exploring customer segmentation, regional reach, purchase frequency, and seasonal sales trends using the Superstore dataset.

## Project Overview
This project leverages advanced T-SQL queries and reporting metrics to analyze customer segmentation, geographic market penetration, repeat-purchase behavior, and seasonal revenue spikes in the Superstore dataset.

## Key SQL Queries & Analyses
* **Regional Segmentation (Task 1):** Evaluated unique customer counts and percentage market reach across regions (East, West, Central, South).
* **Customer Loyalty & Frequency (Task 2 & 4):** Measured repeat-purchase rates, identified top-frequency customers, and calculated average order counts per customer segment (Corporate, Consumer, Home Office).
* **High-Value Spend Analysis (Task 3):** Ranked top spending customers and analyzed their category-specific spending patterns.
* **Seasonal Sales Trends (Task 5):** Aggregated monthly order volumes, sales totals, and profits to uncover peak demand windows.

## Key Insights & Findings
* **Regional Concentration:** The West and East regions dominate the consumer footprint (~32% and ~28% reach), while the South is underpenetrated (~17%).
* **Exceptional Retention:** Over 95% of customers are repeat buyers.
* **Seasonal Surge:** Q4 (November–December) accounts for a massive surge in annual revenue and order volume.

## Tools & Skills Used
* **SQL Server (T-SQL):** Window functions (`ROW_NUMBER()`, `SUM() OVER()`), Common Table Expressions (CTEs), multi-table joins, date parts, and aggregates.
* **Business Intelligence:** Customer lifetime behavior analysis, discount impact evaluation, and strategy formulation.

* ## Conclusion
This analysis demonstrates that while Superstore benefits from stellar customer retention (~95% repeat rate) and high engagement in coastal regions, revenue is heavily bottlenecked by seasonal Q4 surges and discount dilution among top spenders. To maximize long-term profitability, Superstore should shift acquisition focus toward underpenetrated regions (South/Central), transition high-value buyers from margin-eroding discounts to loyalty perks, and run targeted off-season promotional campaigns in Q1.
