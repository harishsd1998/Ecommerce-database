USE mavenfuzzyfactory;
-- Traffic Source Segment Trending

SELECT 
	MIN(DATE(created_at)) AS week_started_at,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions
	FROM website_sessions
WHERE created_at < '2012-06-09'
	AND created_at > '2012-04-15'
    AND utm_source ='gsearch'
    AND utm_campaign= 'nonbrand'
GROUP BY
	YEAR(created_at),
    WEEK(created_at)
/* It is pretty clear that the mobile device are reducing the number of sessions 
   ie., users accessing the device using mobiles are decreasing ie., from 243 to 151 */

