USE mavenfuzzyfactory;
-- Traffic Source BID OPTIMIZATION
-- aCTUALLY WE AS ANALYST ARE NOT DIFFERENTIATING BIDS BASED ON DEVICE TYPE. 
/*On the other day, when tom tried to use the site with his mobile device, he found that the experience is not good.
So, he want me to pull the conversion rates from session to order with the help of device type.
He mentioned that if desktop is better than mobile, he may spend on the desktop to get more volume of users.*/

SELECT 
	website_sessions.device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
	COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_convertion_rate
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-05-11'
	  AND website_sessions.utm_source = 'gsearch'
      AND website_sessions.utm_campaign= 'nonbrand'
GROUP BY website_sessions.device_type;
/*Finally we have found that Desktop device_type is bringing in many orders and sessions. 
So, it clears Tom to increase the BID on Desktop Device_Type in the campaigns.*/

