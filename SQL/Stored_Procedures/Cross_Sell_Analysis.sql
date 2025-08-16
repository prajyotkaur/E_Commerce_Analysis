CREATE DEFINER=`root`@`localhost` PROCEDURE `E_Commerce_Analytics`.`Cross_Sell_Analysis`(
	IN start_date DATE,
    IN end_date DATE,
    IN min_threshold INT
)  

BEGIN
	SELECT t.product_A, t.product_B, t.orders_together
	FROM (
		SELECT p1.product_ID as p1_ID,
			p2.product_ID as p2_ID,
			p1.product_name as product_A,
			p2.product_name as product_B,
			count(distinct od1.order_id) as orders_together
			
			from 
			Order_Details od1 JOIN Order_Details od2 ON
				od1.order_id = od2.order_id
			AND od1.product_id < od2.product_id
    		JOIN Orders o    ON o.order_id = od1.order_id
    		JOIN Products p1 ON p1.product_id = od1.product_id
    		JOIN Products p2 ON p2.product_id = od2.product_id
    		WHERE o.order_status = 'Completed'
      AND (start_date IS NULL OR o.order_date >= start_date)
      AND (end_date   IS NULL OR o.order_date <= end_date)
    GROUP BY p1.product_id, p1.product_name, p2.product_id, p2.product_name
  ) AS t
	WHERE t.orders_together >= COALESCE(min_threshold, 0)
  ORDER BY t.orders_together DESC, t.product_A, t.product_B;
END		
