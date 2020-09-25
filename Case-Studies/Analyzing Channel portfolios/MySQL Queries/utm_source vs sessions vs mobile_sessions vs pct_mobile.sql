-- Comaparing channel characteristics
USE mavenfuzzyfactory;

SELECT 
	utm_source,
    COUNT(DISTINCT website_session_id) AS total_sessions,
	COUNT(CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
	COUNT(CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id )AS pct_mobile
FROM website_sessions
WHERE 
	created_at > '2012-08-22'
	AND created_at < '2012-11-30'
    AND utm_campaign = 'nonbrand'
    AND utm_source IN('bsearch','gsearch')
GROUP BY
	utm_source;
