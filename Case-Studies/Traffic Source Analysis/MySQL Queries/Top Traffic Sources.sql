Use mavenfuzzyfactory;
-- Here we are finding the "top traffic sources" and we are seeing the breakdown by UTM source, campaign and referring domain
SELECT 
	utm_source, 
    utm_campaign,
	http_referer,
    COUNT(DISTINCT website_session_id) AS number_of_sessions
    FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY
	utm_source,
    utm_campaign,
    http_referer
ORDER BY number_of_sessions DESC;
/*we found that largest session volume traffic sources are coming from utm_source = "gsearch" and utm_campaign= "nonbrand".
Now we have to drill deeper into gsearch nonbrand campaign to explore potential optimization oppurtunities */ 