USE mavenfuzzyfactory;

-- Step 1: select all pageviews for relevant sessions
-- Step 2: figure out which pageviews urls to look for
-- Step 3: pull all pageviews and identify the funnel steps
-- Step 4: create the session-level conversion funnel view
-- Step 5: aggregate the data to assess funnel performance

CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT
	website_session_id,
    website_pageview_id,
    pageview_url AS product_page_seen
FROM website_pageviews

WHERE created_at < '2013-04-10' -- date of assignment
	AND created_at > '2013-01-06' -- product 2 launch
    AND pageview_url IN ('/the-original-mr-fuzzy','the-forever-love-bear');
    
    
SELECT * FROM sessions_seeing_product_pages;

-- finding the right pageview_urls to build the funnels

SELECT DISTINCT
	website_pageviews.pageview_url
    FROM sessions_seeing_product_pages
    LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
;

-- we'll look at the inner query first to look over the page-view level results
-- then, turn it into a subquery and make it the summary with flags

SELECT 
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
	CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
	CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
    FROM sessions_seeing_product_pages
		LEFT JOIN website_pageviews
			ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
            AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id -- Logic for the pageviews seen AFTER the the-original-mr-fuzzy page and 'the-forever-love-bear' page
	ORDER BY
		sessions_seeing_product_pages.website_session_id,
        website_pageviews.created_at
;

CREATE TEMPORARY TABLE session_product_level_made_it_flags
SELECT 
	website_session_id,
    CASE 
    WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
    WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
    ELSE 'check_your_logic'
	END AS product_seen,
	MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(

SELECT 
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
	CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
	CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
    FROM sessions_seeing_product_pages
		LEFT JOIN website_pageviews
			ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
            AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id -- Logic for the pageviews seen AFTER the the-original-mr-fuzzy page and 'the-forever-love-bear' page
	ORDER BY
		sessions_seeing_product_pages.website_session_id,
        website_pageviews.created_at
) AS pageview_level
GROUP BY
	website_session_id,
    CASE 
    WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
    WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
    ELSE 'check_your_logic'
	END ;
    
-- final output part 1

SELECT 
	product_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_product_level_made_it_flags
GROUP BY product_seen;


-- final output part 2 - click rates
SELECT 
	product_seen,
	COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/ COUNT(DISTINCT website_session_id) AS product_page_click_rate,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rate,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_cart_click_rate,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rate
FROM session_product_level_made_it_flags
GROUP BY product_seen;

-- lovebear produced more click rates than mr_fuzzy