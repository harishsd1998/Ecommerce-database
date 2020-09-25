-- Product level website analysis
/* It all about understanding and learning how well the customers will interact with each of the products
   and how well each product converts products. we should also understand the impact of adding a new product to the 
   product portfolio.*/
   
   /* Common use cases
	
		1) understanding which of the products generate the most interest on multi-product showcase pages.
			ie., Analyzing click-through-rates
        2) Analyze the impact of adding new product on website conversion rates 
        3) Build product-specific conversion funnels to understand whether certain products convert better than others.
	*/
 /*   SET GLOBAL_max_allowed_packet = 1073741824;
    USE mavenfuzzyfactory;
    
    SELECT 
		DISTINCT pageview_url
    FROM website_pageviews
    WHERE created_at BETWEEN '2013-02-01' AND '2013-03-01';
    */
    
     SELECT 
        website_pageviews.pageview_url,
        COUNT(DISTINCT website_pageviews.website_session_id) AS sessions,
        COUNT(DISTINCT orders.order_id) AS orders,
        COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_pageviews.website_session_id) AS viewed_product_to_order_rate
		FROM website_pageviews
        LEFT JOIN orders
			ON orders.website_session_id = website_pageviews.website_session_id
    WHERE website_pageviews.created_at BETWEEN '2013-02-01' AND '2013-03-01'
    AND website_pageviews.pageview_url IN ('/the-original-mr-fuzzy','/the-forever-love-bear')
    GROUP BY 1