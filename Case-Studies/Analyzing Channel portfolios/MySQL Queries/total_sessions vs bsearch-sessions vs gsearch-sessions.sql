USE mavenfuzzyfactory;
SELECT
	YEARWEEK(created_at) AS yrwk,
	COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
	COUNT(CASE WHEN utm_source ='gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
	COUNT(CASE WHEN  utm_source ='bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions
WHERE 
		created_at > '2012-08-22'
	AND created_at < '2012-11-29'
    AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);
