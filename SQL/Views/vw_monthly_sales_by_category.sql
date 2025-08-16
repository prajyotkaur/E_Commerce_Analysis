-- E_Commerce_Analytics.vw_monthly_sales_by_category source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `e_commerce_analytics`.`vw_monthly_sales_by_category` AS
select
    date_format(`o`.`Order_Date`, '%Y-%m') AS `ym`,
    `p`.`Category` AS `category`,
    sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))) AS `monthly_revenue`,
    sum(((`od`.`quantity` * (`p`.`Unit_Price` - `p`.`Cost_Price`)) * (1 - (`od`.`discount` / 100)))) AS `monthly_profit`
from
    ((`e_commerce_analytics`.`orders` `o`
join `e_commerce_analytics`.`order_details` `od` on
    ((`o`.`Order_ID` = `od`.`order_id`)))
join `e_commerce_analytics`.`products` `p` on
    ((`od`.`product_id` = `p`.`Product_ID`)))
where
    (`o`.`Order_Status` = 'Completed')
group by
    `ym`,
    `p`.`Category`
order by
    `ym`,
    `p`.`Category`;