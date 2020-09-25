USE mavenfuzzyfactory;
-- Traffic Source Trending Weekly wise especially for gsearch nonbrand
SELECT 
	-- YEAR(created_at) AS year,
    -- WEEK(created_at) AS week,
    MIN(DATE(created_at)) AS week_started_at,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-10'
	AND utm_source='gsearch'
    AND utm_campaign='nonbrand'
GROUP BY
	YEAR(created_at),
	WEEK(created_at);
/*From the output , we noticed that we dont want to spend more on the ads than we can afford. 
Beacause in the output we can notice that at last the sessions are decreased which means the traffic is leading to less number of users */
-- 