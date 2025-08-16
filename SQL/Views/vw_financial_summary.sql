-- E_Commerce_Analytics.vw_financial_summary source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `e_commerce_analytics`.`vw_financial_summary` AS
select
    date_format(`o`.`Order_Date`, '%Y-%m') AS `ym`,
    `p`.`Category` AS `category`,
    round(sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))), 2) AS `total_revenue`,
    round(sum(((`od`.`quantity` * (`p`.`Unit_Price` - `p`.`Cost_Price`)) * (1 - (`od`.`discount` / 100)))), 2) AS `total_profit`,
    round(((sum(((`od`.`quantity` * (`p`.`Unit_Price` - `p`.`Cost_Price`)) * (1 - (`od`.`discount` / 100)))) / nullif(sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))), 0)) * 100), 2) AS `profit_margin_pct`,
    round((sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))) - coalesce(`b`.`budgeted_sales`, 0)), 2) AS `revenue_variance`,
    round((sum(((`od`.`quantity` * (`p`.`Unit_Price` - `p`.`Cost_Price`)) * (1 - (`od`.`discount` / 100)))) - coalesce(`b`.`budgeted_profit`, 0)), 2) AS `profit_variance`
from
    (((`e_commerce_analytics`.`orders` `o`
join `e_commerce_analytics`.`order_details` `od` on
    ((`o`.`Order_ID` = `od`.`order_id`)))
join `e_commerce_analytics`.`products` `p` on
    ((`od`.`product_id` = `p`.`Product_ID`)))
left join `e_commerce_analytics`.`budgets` `b` on
    (((`b`.`category` = `p`.`Category`) and (`b`.`year` = year(`o`.`Order_Date`)) and (`b`.`month` = month(`o`.`Order_Date`)))))
where
    (`o`.`Order_Status` = 'Completed')
group by
    `ym`,
    `p`.`Category`
order by
    `ym`,
    `p`.`Category`;