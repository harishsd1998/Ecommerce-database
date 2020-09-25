USE mavenfuzzyfactory;
/*Here we are going to find what percentage of sessions (especially through the gsearch , nonbrand )are converted into sales for the company 
Here we wanna pull sessions ,orders and session to order convertion rate*/
SELECT 
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
      COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
    FROM website_sessions
    LEFT JOIN orders
    ON  orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-04-14'
	AND utm_source = 'gsearch'
    AND utm_campaign= 'nonbrand';
-- We have saved some dollars of the company since the session to order convertion rate did not meet the 4% threshold.

