-- E_Commerce_Analytics.vw_customer_segmentation_insights source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `e_commerce_analytics`.`vw_customer_segmentation_insights` AS
select
    `c`.`Customer_ID` AS `customer_id`,
    concat(`c`.`First_Name`, ' ', `c`.`Last_Name`) AS `customer_name`,
    sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))) AS `total_spent`,
    (case
        when (sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))) >= 5000) then 'High Value'
        when (sum(((`od`.`quantity` * `p`.`Unit_Price`) * (1 - (`od`.`discount` / 100)))) between 2000 and 4999) then 'Medium Value'
        else 'Low Value'
    end) AS `customer_segment`,
    count(distinct `o`.`Order_ID`) AS `total_orders`
from
    (((`e_commerce_analytics`.`customers` `c`
join `e_commerce_analytics`.`orders` `o` on
    ((`c`.`Customer_ID` = `o`.`Customer_ID`)))
join `e_commerce_analytics`.`order_details` `od` on
    ((`o`.`Order_ID` = `od`.`order_id`)))
join `e_commerce_analytics`.`products` `p` on
    ((`od`.`product_id` = `p`.`Product_ID`)))
where
    (`o`.`Order_Status` = 'Completed')
group by
    `c`.`Customer_ID`,
    concat(`c`.`First_Name`, ' ', `c`.`Last_Name`)
order by
    `total_spent` desc;