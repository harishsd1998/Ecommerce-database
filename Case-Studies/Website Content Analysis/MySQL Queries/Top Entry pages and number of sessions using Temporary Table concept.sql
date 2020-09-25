use mavenfuzzyfactory;
/* Here we are focusing on fuzzyfactory website and understand where the customers are landing on the website.
And,how they are making their way to the convertion funnel on the way in placing the order
"Website Content Analysis" is understanding about which pages are seen the most by our users
 and to identify where to focus on improving our business*/
 
 /* Suppose we have three pages A, B, and C.
	and Page A got 550 sessions, Page B got 1,750 sessions and Page C got 625 sessions over the same timeperiod.
    So, Starting with Page B will be the most reasonable way to improve the business.

   Some Common Use Cases are:
   1. Finding the most viewd pages that customers viewed on our site.
   2.Identifying the most common entry pages for our website ie., the first thing a user sees.
   3.For most cases Marketers and Website Managers will spend a lot of time in analyzing how the most viewed 
     pages and Most common entry pages will impact the Business Objectives.

   Creating Temporary Tables
   Allows us to create a dataset stored as a table which we can query another time.
   Syntax: CREATE TEMPORARY TABLE newTempTableName;

	Finding Top pages
	1. when we are finding top pages ie., most viewed pages, we can analyze our pageviews data 
    and GROUP BY url to see which pages are viewd the most.
    2.To find the top entry pages , we will limit to just the first page a user sees during a 
    given session, using a temporary table.
    
	when we are coming to a new business or website, performing a top page analysis is a good way to decide 
	where to focus. */

/*SELECT 
	pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pageviews
	FROM website_pageviews
    WHERE website_pageview_id < 1000
GROUP BY
	pageview_url 
ORDER BY
	pageviews DESC;*/
-- Top Entry Pageview-id's
CREATE TEMPORARY TABLE first_pageviewed
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_page_view_id
FROM website_pageviews
WHERE website_pageview_id <1000
GROUP BY website_session_id;

SELECT 
	website_pageviews.pageview_url as landing_page,
    COUNT(DISTINCT first_pageviewed.website_session_id) AS sessions
FROM first_pageviewed
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageviewed.min_page_view_id
GROUP BY
	landing_page;
    
