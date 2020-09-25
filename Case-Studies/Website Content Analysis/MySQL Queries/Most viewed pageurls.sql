USE mavenfuzzyfactory;
-- Here we will be working with Website Manager of the Ecommerce Website
-- Task: He wants to pull out the most viewed pages ranked by session volume.
-- They want to show us the pageview_url and the number of sessions.
SELECT 
	pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pageviews
	FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY
	pageview_url
ORDER BY
	pageviews DESC;
/*Seeing the output we can say that home, products, the-original-mr-fuzzy urls seems to get most 
number of pageviews, So , we needd to further dig to check that will these page urls represent the 
top entry pages. And also analyze the performance of each of the top pages to look for improvement 
oppurtunities.
