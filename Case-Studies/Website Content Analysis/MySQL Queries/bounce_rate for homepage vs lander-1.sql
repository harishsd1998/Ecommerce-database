/* Here we have to analyze bounce_rate for a new custom landing page(/lander-1) against the homepage(/home)
for our gsearch nonbrand traffic. we have to pull bounce rates for the two groups and we have to make sure that 
we just look at the time period where /lander-1 was getting traffic */

USE mavenfuzzyfactory;

SELECT 
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
	AND created_at IS NOT NULL;
-- The above query is pulling minimum timestamp url where the pageviewurl is '/lander-1'

CREATE TEMPORARY TABLE first_test_pageviews
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
	INNER JOIN website_sessions
    ON website_sessions.website_session_id = website_pageviews.website_session_id
    AND website_sessions.created_at < '2012-07-28'
    AND website_pageviews.website_pageview_id > 23504
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY
	website_pageviews.website_session_id;

-- next, we will bring in the landing page to each session , like last time, but restricting to home or lander-1 this time.

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page
SELECT 
	first_test_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_test_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_test_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url IN('/home','/lander-1');

-- then a table should be created to have count of pageviews  per session
	-- then limit it to just bounced_sessions
    
    
CREATE TEMPORARY TABLE nonbrand_test_bounced_sessionss
SELECT 
	nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM nonbrand_test_sessions_w_landing_page
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = nonbrand_test_sessions_w_landing_page.website_session_id
GROUP BY 
	nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1;
    

SELECT 
	nonbrand_test_sessions_w_landing_page.landing_page,
	COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS website_sessions,
	COUNT(DISTINCT nonbrand_test_bounced_sessionss.website_session_id) AS bounced_sessions,
    	COUNT(DISTINCT nonbrand_test_bounced_sessionss.website_session_id)/COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS bounce_rate
FROM nonbrand_test_sessions_w_landing_page
	LEFT JOIN nonbrand_test_bounced_sessionss
		ON nonbrand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessionss.website_session_id
GROUP BY
		nonbrand_test_sessions_w_landing_page.landing_page;

/* From the output we can see that fewer customers are in the bounce proportion ie., comapred to homepage(58%)
the bounce_rate for the lander-1 page is 53% means that the users who are staying static in only one page were 
reduced which improves the business to a certain extent ie., optimization of business performance. */

    


	
