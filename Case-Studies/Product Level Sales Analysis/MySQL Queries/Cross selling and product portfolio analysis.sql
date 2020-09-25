-- CROSS-SELLING PRODUCTS
/* Cross-sell analysis is about understanding which products users are most likely to purchase together, and offer
   smart product recommendations to make revenue*/
   
/* Coomon use cases
 1) Understand which products are often purchased together.
 2) testing and optimizing the way you cross-sell products on website
 3) understanding the conversion rate impact and the overall revenue impact of trying to cross-sell additional 
	products */
SELECT 
	orders.primary_product_id,
	COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END) AS x_sell_prod1,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END) AS x_sell_prod2,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END) AS x_sell_prod3,
	COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT orders.order_id) AS x_sell_prod1_rt,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT orders.order_id) AS x_sell_prod2_rt,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT orders.order_id) AS x_sell_prod3_rt


FROM orders
	LEFT JOIN order_items
		ON order_items.order_id = orders.order_id
        AND order_items.is_primary_item = 0 -- cross sell only

WHERE orders.order_id BETWEEN 10000 AND 11000
GROUP BY 1; 


-- if is_primary from order_items table is 0 then it is cross sold product and if it is 1 then it is definitely primary_product