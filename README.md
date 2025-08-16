# E-Commerce Analytics Case Study

## Project Overview
This project analyzes an e-commerce dataset to generate insights on customers, sales, products, and profitability using SQL.
The goal is to demonstrate advanced SQL skills including *stored procedures, views, window functions, aggregations, and analytics queries.

## Database & Schema
The database `E_Commerce_Analytics` contains the following tables:

| Table Name      | Description                                      |
|-----------------|--------------------------------------------------|
| Customers       | Customer details including segments and country |
| Orders          | Order-level information                           |
| Order_Details   | Product-level details for each order            |
| Products        | Product catalog with prices and costs           |
| Budgets         | Budgeted sales and profit by category/month     |

---

## SQL Scripts

### **Stored Procedures**
- `Monthly_Churn_Calculation.sql` – Calculates monthly customer churn percentage.
- Cross_Sell_Analysis – Analyzes purchasing patterns to identify products frequently bought together.
- Financial_Summary – Summarizes revenue, profit, profit margin, and contribution margin across different product categories.

### **Views**
- vw_Customer_Segmentation_Insights.sql – Calculates customer lifetime value and segments customers by spending.
- vw_Financial_Summary.sql – Summarizes revenue, profit, profit margin, and contribution margin by product category.
- vw_Monthly_Sales_By_Category.sql – Tracks monthly sales revenue for each product category.
- vw_Products_Performance.sql – Evaluates individual product performance based on revenue, quantity sold, and profitability.

### **Queries**
- `Sample_Queries.sql` – Key analytics queries including:
  - Total count of elements in all tables
  - Vieweing all records from each table
  - Total sales value
  - Orders by country
  - Customers per segment
  - Products by total revenue
  - Monthly sales trend
  - Customer lifetime revenue
  - Repeat purchase customers
  - Profitability by category
  - Budget vs actual sales/profit
  - Customer segmentation by revenue
  - Monthly sales trend by category
  - Churn percentage calculation (via stored procedure)
  - Cross Sell Analysis (via stored procedure)
  - Financial Summary (via stored procedure)

---

## Sample Data Outputs
Key results exported as CSV files (also usable for further analysis):

| Analysis                      | CSV File |
|--------------------------------|---------|
| Budget vs Actuals           | `/SQL/Sample_Data/Budget_vs_Actuals.csv` |
| Montly Revenue              | `/SQL/Sample_Data/Monthly_Revenue.csv` |
| Profit Margin by Category   | `/SQL/Sample_Data/Profit_Margin_By_Category.csv` |
| Cross Sell Analysis         | `/SQL/Sample_Data/Cross_Sell_Analysis_NULL_NULL_10.csv` |
| Monthly Churn Calculations  | `/SQL/Sample_Data/Monthly_Churn_Calculation_2024_01_01_2025_08_01.csv` |
| Financial Summary           | `/SQL/Sample_Data/Financial_Summary_NULL_NULL.csv` |

> Optional: Screenshots or CSV previews can be included for visualization if desired.

---

## Key Insights
- **Top 5 products** contribute a significant portion of total revenue.  
- **High-value customers** represent a large share of total sales.  
- **Monthly trends** indicate seasonal peaks and sales growth patterns.  
- **Profitability** varies by category, highlighting areas for cost optimization.  
- **Budget vs Actuals** analysis identifies underperforming and overperforming segments.  

---

## How to Run
1. Use the database `E_Commerce_Analytics`.  
2. Execute scripts in the following order:  
   1. Views → `/SQL/Views/*.sql`  
   2. Stored Procedures → `/SQL/Stored_Procedures/*.sql`  
   3. Queries → `/SQL/Queries/*.sql`  
3. Review exported CSVs in `/SQL/Sample_Data` for actual results.  
4. (Optional) Export additional query outputs or load CSVs into Excel/Power BI for visualization.  
