
USE E_Commerce_Analytics; 
-- 1. Element count for all tables
select count(*) from Budgets;
select count(*) from Orders;
select count(*) from Products;
select count(*) from Order_Details;
select count(*) from Customers;

-- 2. Sample Data
select * from Budgets limit 5;
select * from Orders limit 5;
select * from Products limit 5;
select * from Order_Details limit 5;
select * from Customers limit 5;

-- 3. Total Sales Value
select sum(od.quantity * p.unit_price) as tot_sales
from Order_Details od JOIN Products p ON
od.Product_ID = p.Product_ID; 

-- 4. Orders by Country
select c.country, count(o.order_id)  total_orders
from Orders o JOIN Customers c
on o.Customer_ID = c.Customer_ID 
group by c.Country order by total_orders desc;

-- 5. Customers per Segment
select segment, count(*) from Customers
group by segment;

-- 6. Products by Total Revenue
/* Total Revenue is calculated as Money earned before subtracting any other costs
 * Quantity * Unit Price * (1-Discount/100) */
select p.product_name, p.category, 
ROUND(SUM(od.quantity * p.unit_price * (1-od.discount/100)),2) as Total_Revenue
From Order_Details od JOIN Products p on
od.product_id = p.Product_ID 
group by p.product_id, p.Product_Name, p.Category 
order by Total_Revenue desc;

-- 7. Monthly Sales Trend
/* Sales over time (Monthly Revenue). Helps spot 
 * 1. Seasonal Trends
 * 2. Measures Growth or Decline
 * 3. Budgeting & Forecasting
 * 4. Planning Inventory
 */

select month(o.Order_Date) as month,
ROUND(SUM(od.quantity * p.unit_price * (1-od.discount/100)),2) as Monthly_Revenue
From Orders o JOIN
Order_Details od on o.Order_ID  = od.order_id JOIN Products p ON 
od.product_id = p.Product_ID 
where o.Order_Status = 'Completed'
group by month(o.Order_Date) order by month;


-- 8. Customer Lifetime Revenue
/* total revenue that the business earns from a single customer till date.
*/

select c.customer_Id, CONCAT(c.First_Name, ' ', c.Last_Name) as Customer_Name,
ROUND(SUM(od.quantity * p.unit_price * (1-od.discount/100)),2) as Customer_Revenue
from Customers c JOIN Orders o on
o.Customer_ID  = c.Customer_ID JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
where o.Order_Status = 'Completed'
group by Customer_ID, Customer_Name
order by Customer_Revenue Desc;

-- 9. Repeat Purchase Customers
select o.customer_ID, CONCAT(c.First_Name, ' ', c.Last_Name) as Customer_Name,
count(distinct order_ID) as Total_Orders
From Orders o join Customers c on 
o.Customer_ID = c.Customer_ID 
where Order_Status = 'Completed'
group by Customer_ID having Total_Orders >1;


-- Advanced Analytics

-- 10. Profitability by Category
/*Total profit generated from all sales by category after subtracting all costs
 * = Sum of Profit (Grouped by Category)
 * Profit = Unit Price - Cost Price
 */
select p.category, 
round(sum((Unit_Price- Cost_Price) * od.quantity * (1-od.discount/100)),2) as total_profit,
ROUND(SUM(od.quantity * p.unit_price * (1-od.discount/100)),2) as total_revenue,
ROUND( (sum((Unit_Price- Cost_Price) * od.quantity * (1-od.discount/100))/ SUM(od.quantity * p.unit_price * (1-od.discount/100))) , 2) AS Proft_Margin
from Order_details od JOIN Products p on
od.product_id = p.Product_ID 
group by p.category
order by total_profit desc;

-- 11. Budget vs Actuals
/* Purpose is to calculate Budgeted Sales - Actuals Sales for each year, month & category
 * to identify the performance (Variance : +Ve or -ve) */

Select b.year, b.month, b.category,
ROUND(b.budgeted_Sales, 2) as Budgeted_Sales,
ROUND(SUM(od.quantity * p.unit_price * (1 - od.discount / 100)), 2) AS Actual_sales,
ROUND(SUM(od.quantity * p.unit_price * (1 - od.discount / 100)) - b.budgeted_sales, 2) AS variance_sales,
ROUND(b.budgeted_profit, 2) AS budgeted_profit,
ROUND(SUM((p.unit_price - p.cost_price) * od.quantity * (1 - od.discount / 100)), 2) AS actual_profit,
ROUND(SUM((p.unit_price - p.cost_price) * od.quantity * (1 - od.discount / 100)) - b.budgeted_profit, 2) AS variance_profit
FROM Budgets b
LEFT JOIN Products p ON
b.category = p.Category 
LEFT JOIN Order_Details od ON
od.product_id = p.Product_ID 
LEFT JOIN ORDERS o ON
od.order_id = o.Order_ID 
and o.order_status = 'Completed'
group by b.year, b.month, b.category, b.budgeted_sales, b.budgeted_profit
order by b.year, b.month, b.category; 


-- 12. Customer Segmentation by Revenue
select c.customer_Id, CONCAT(c.First_Name, ' ', c.Last_Name) as Customer_Name,
CASE
	WHEN SUM(od.quantity * p.unit_price * (1 - od.discount / 100)) >= 5000 then 'High Value'
	WHEN SUM(od.quantity * p.unit_price * (1 - od.discount / 100)) BETWEEN 2000 AND 4999 THEN 'Medium Value'
    ELSE 'Low Value'
END as Customer_Segment,
ROUND(SUM(od.quantity * p.unit_price * (1 - od.discount / 100)), 2) AS total_spent    
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;

-- 13. Monthly Sales Trend by Category
with monthly_cat_sales as(
select CONCAT(year(o.order_date), '-', month(o.order_date)) as ym,
p.category as category,
ROUND(SUM(od.quantity * p.unit_price * (1 - od.discount/100)), 2) AS monthly_revenue
From Orders o
Join Order_Details od on o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category, CONCAT(year(o.order_date), '-', month(o.order_date))
)

select ym, category, monthly_revenue,
round(sum(monthly_revenue) over (Partition by category order by ym rows between unbounded preceding and current row), 2) as running_total_by_category,
round(avg(monthly_revenue) over (Partition by category order by ym rows between 2 preceding and current row), 2) as threemonth_yavg_bycategory
from monthly_cat_sales
order by category, ym;


-- 14. Calling Stored Proc for Churn % Calculation
CALL Monthly_Churn_Calculation('2024-01-01','2025-08-01');
CALL Monthly_Churn_Calculation('2024-04-01', '2024-06-30');
CALL Monthly_Churn_Calculation('2024-01-01', '2024-12-31');


--- 15. Calling Stored Proc for identifying products that are often sold together
CALL Cross_Sell_Analysis('2024-01-01', '2024-12-31', 5);
CALL Cross_Sell_Analysis(NULL, NULL, 10);


--- 16. Financial Summary
CALL Financial_Summary(NULL, NULL);
CALL Financial_Summary('2024-01-01', '2024-06-30');





