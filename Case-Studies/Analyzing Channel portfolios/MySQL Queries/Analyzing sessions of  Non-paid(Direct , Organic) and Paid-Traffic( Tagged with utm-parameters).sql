-- ANALYZING DIRECT TRAFFIC

/* Analyzing branded or direct traffic is all about keeping a pulse on how well our brand is doing with the customers
   , and how well our brand drives business. */

/* When we operate a website doing well and eventually customers are typing in the domain name in to their browser, we love
this because this is the traffic we dont need to pay for. and we can know that our brand is getting attraction in
the market place. */

/* Some common use cases are:
   1) Calculating how much traffic we are getting from our direct traffic, because its such a high margin revenue
   because it doesnt involve the direct cost of customers.
   
   2) understanding whether or not our paid traffic is generating a "halo effect" and promoting additional direct traffic.alter
   
   3) we can use direct traffic to access the impact of vrarious initiatives on how many customers seek out our business.
*/
USE mavenfuzzyfactory;
SELECT 
	 CASE  
	    WHEN http_referer IS NULL THEN 'direct_type_in'
        WHEN http_referer = 'https://www.gsearch.com' AND utm_source IS NULL THEN 'gsearch_organic'
	    WHEN http_referer = 'https://www.bsearch.com' AND utm_source IS NULL THEN 'bsearch_organic'
        ELSE 'other'
        END AS CASES,
        COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000
	-- AND utm_source IS NULL
GROUP BY 1
ORDER BY 2 DESC;