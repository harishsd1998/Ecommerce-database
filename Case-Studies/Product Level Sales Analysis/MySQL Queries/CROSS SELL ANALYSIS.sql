-- CROSS SELL ANALYSIS

-- Step 1: Identify the relevant /cart page views and their sessions
-- Step 2: See which of those /cart sessions clicked through to the shipping page
-- Step 3: Find the orders associated with the /cart sessions, Analyze products purchased, AOV
-- Step 4: Aggregate and analyze a summary of our findings

CREATE TEMPORARY TABLE sessions_seeing_cart
SELECT 
	CASE 
		WHEN created_at < '2013-09-25' THEN 'A. Pre_Cross_Sell'
        WHEN created_at >= '2013-01-06' THEN 'B. Post_Cross_Sell'
        ELSE 'uh oh...check logic'
	END AS time_period,
	website_session_id AS cart_session_id,
    website_pageview_id AS cart_pageview_id
FROM website_pageviews
WHERE created_at BETWEEN '2013-08-25' AND '2013-10-25'
	AND pageview_url = '/cart';
    
    
CREATE TEMPORARY TABLE cart_sessions_seeing_another_page
SELECT 
	sessions_seeing_cart.time_period,
    sessions_seeing_cart.cart_session_id,
    MIN(website_pageviews.website_pageview_id) AS pv_id_after_cart
FROM sessions_seeing_cart
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_cart.cart_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_cart.cart_pageview_id
GROUP BY
		sessions_seeing_cart.time_period,
        sessions_seeing_cart.cart_session_id
HAVING 
	MIN(website_pageviews.website_pageview_id) IS NOT NULL;
    
CREATE TEMPORARY TABLE pre_post_sessions_orders
SELECT 
	time_period,
    cart_session_id,
    order_id,
    items_purchased,
    price_usd
FROM sessions_seeing_cart
	INNER JOIN orders -- cut of sessions that didnt have orders.
		ON sessions_seeing_cart.cart_session_id = orders.website_session_id


