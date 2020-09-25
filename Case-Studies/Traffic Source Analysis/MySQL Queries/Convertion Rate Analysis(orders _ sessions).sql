USE mavenfuzzyfactory;
SELECT 
	website_sessions.utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
     COUNT(DISTINCT orders.order_id)/ COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id=website_sessions.website_session_id
        
WHERE website_sessions.website_session_id BETWEEN 1000 AND 2000 
GROUP BY utm_content
ORDER BY sessions DESC; -- we can write '2' instead of sessions because sessions is in the second order after the Select Statement.

    