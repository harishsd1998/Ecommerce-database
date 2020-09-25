-- Analyzing Conversion Funnel Tests
-- Here we are calculating what % of sessions on those pages(billing & billing-2) end up placing an order :)

-- first, finding the starting point to frame the analysis;

SELECT 
	MIN(website_pageviews.website_pageview_id) AS first_pv_id
FROM website_pageviews
WHERE pageview_url = '/billing-2'; -- New billing page

-- first we'll look at this without orders, then we'll add in orders

SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550 -- first pageview_id where test was live
	AND website_pageviews.created_at < '2012-11-10' -- time of assignment
    AND website_pageviews.pageview_url IN ('/billing','billing-2');
    
-- Now, we will look at what sessions of billing and billing-2 pages are converted into orders.
SELECT
	billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rate
FROM(
SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550 -- first pageview_id where test was live
	AND website_pageviews.created_at < '2012-11-10' -- time of assignment
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')) AS billing_sessions_w_orders
GROUP BY
	billing_version_seen;
-- From the output we can tell the new billing-2 page is good in performance since it is driving lot of customers to place orders.
    
    
    

 