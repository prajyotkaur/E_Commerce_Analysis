-- E_Commerce_Analytics.vw_products_performance source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `e_commerce_analytics`.`vw_products_performance` AS
select
    `p`.`Product_Name` AS `product_name`,
    `p`.`Category` AS `category`,
    sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))) AS `total_revenue`,
    sum(((`od`.`quantity` * (`p`.`Unit_Price` - `p`.`Cost_Price`)) * (1 - (`od`.`discount` / 100)))) AS `total_profit`,
    round(((sum(((`od`.`quantity` * (`p`.`Unit_Price` - `p`.`Cost_Price`)) * (1 - (`od`.`discount` / 100)))) / nullif(sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))), 0)) * 100), 2) AS `profit_margin_pct`
from
    ((`e_commerce_analytics`.`order_details` `od`
join `e_commerce_analytics`.`products` `p` on
    ((`od`.`product_id` = `p`.`Product_ID`)))
join `e_commerce_analytics`.`orders` `o` on
    ((`od`.`order_id` = `o`.`Order_ID`)))
where
    (`o`.`Order_Status` = 'Completed')
group by
    `p`.`Product_Name`,
    `p`.`Category`
order by
    `total_revenue` desc;