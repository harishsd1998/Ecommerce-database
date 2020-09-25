USE mavenfuzzyfactory;

SELECT YEAR(website_sessions.created_at) AS yr,
	MONTH(website_sessions.created_at) AS mon,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,
    COUNT(DISTINCT CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one_orders,
	COUNT(DISTINCT CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two_orders

FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE 
	website_sessions.created_at < '2013-04-01'
    AND website_sessions.website_session_id > '2012-04-01'
GROUP BY 1,2;

-- From the output it is clear that the conversion rate and revenue rate are improving over time and its hard to find whether the growth from january month is due to the new product launch or just a continuation of overall business improvements