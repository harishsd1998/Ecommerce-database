	/* Analyzing business patterns is about generating insights to help us maximize efficiency and anticipate
	   future trends */

/* Some Common use cases :
	1) Day parting analysis to understand how much support staff we should need at different times of day
      or days of week.
	
    2) Analyzing seasonality to better prepare for upcoming spikes or slowdowns in demand.

*/

USE mavenfuzzyfactory;

SELECT hr,
	-- ROUND(AVG(website_sessions,1)) AS avg_sessions,
    ROUND(AVG(CASE WHEN  wkday = 0 THEN website_sessions ELSE NULL END),1) AS mon,
	ROUND(AVG(CASE WHEN  wkday = 1 THEN website_sessions ELSE NULL END),1) AS tue,
	ROUND(AVG(CASE WHEN  wkday = 2 THEN website_sessions ELSE NULL END),1) AS wed,
	ROUND(AVG(CASE WHEN  wkday = 3 THEN website_sessions ELSE NULL END),1) AS thur,
    ROUND(AVG(CASE WHEN  wkday = 4 THEN website_sessions ELSE NULL END),1) AS fri,
    ROUND(AVG(CASE WHEN  wkday = 5 THEN website_sessions ELSE NULL END),1) AS sat,
    ROUND(AVG(CASE WHEN  wkday = 6 THEN website_sessions ELSE NULL END),1) AS sun



  
FROM (
SELECT 
	DATE(created_at) AS created_at,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS website_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3
) AS daily_hourly_sessions
GROUP BY 1
ORDER BY 1

-- from 8 to 17 hr website sessions are good , so its better to appoint some staff for live chat support