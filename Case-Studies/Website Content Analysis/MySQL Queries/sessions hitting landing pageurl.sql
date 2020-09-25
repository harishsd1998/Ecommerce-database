use mavenfuzzyfactory;
/*This time we have to pull Top Entry Pages to our Ecommerce website. And we have to rank them according to 
entry volume.*/
CREATE TEMPORARY TABLE Top_pageview_id
SELECT 
    website_session_id,
    Min(website_pageview_id) AS min_pageview
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY  website_session_id;

SELECT 
	website_pageviews.pageview_url,
    COUNT(DISTINCT Top_pageview_id.website_session_id) AS sessions_hitting_landing_page
    FROM Top_pageview_id
    LEFT JOIN website_pageviews
    ON Top_pageview_id.min_pageview = website_pageviews.website_pageview_id
    GROUP BY website_pageviews.pageview_url
    ORDER BY sessions_hitting_landing_page DESC;
/*From the output it seems that Home page is getting more traffic ie., (the sessions)  as the 
landing page. We have to Analyze landing page performance for the homepage specifically.We need 
to think whether or not the homepage is the best initial experience for all customers.

   
