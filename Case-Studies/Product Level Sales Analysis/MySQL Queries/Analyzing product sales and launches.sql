-- Analyzing product sales

/* Analyzing product sales helps us understand how each product contributes to our business and how product 
launches impact the overall portfolio */

/* Coomon use cases
	1) Analyzing sales and revenue by product.
    2) Monitoring the impact of adding a new product to our product portfolio.
    3) Watching product sales trends to understand the health of our business.
    
/* Orders:
	Number of orders placed by the customer
    ie., COUNT(order_id)
    
    Revenue:
    Money the business brings from orders
    ie., 	SUM(price_usd)
    
    Margin:
    Revenue minus the cost of goods sold
    ie., SUM(price_usd - cogs_usd)
    
    Average Order Value:
    Average revenue generated per order.
    ie., AVG(price_usd)
*/


SELECT 
	primary_product_id,
	COUNT(order_id) AS orders,
    SUM(price_usd) AS revenue,
    SUM(price_usd - cogs_usd) AS margin,
    AVG(price_usd) AS average_order_value
FROM orders
WHERE order_id BETWEEN 10000 AND 11000

GROUP BY primary_product_id
ORDER BY orders DESC;