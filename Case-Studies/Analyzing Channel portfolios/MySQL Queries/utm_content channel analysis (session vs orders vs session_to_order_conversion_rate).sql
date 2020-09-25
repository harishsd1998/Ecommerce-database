-- Channel Portfolio Optimization
/* Analyzing a portfolio of marketing channels is about bidding efficiently and using the data to maximize the
effectiveness of our marketing budget. */

/* we may have a portfolio of multiple channels like email, social media , network search and direct typing */

/*  Each of these gonna have different volumes and they cost us different amounts. our job as a analyst is to figure out
 each channel and understand how much volume we are getting from each one and how efficient they are and we have to make sure that 
 our marketers are doing a good job with the budgets */
 
 /* Common use cases are:
   1) understanding which marketing channels are driving the most sessions and orders through our website.
   2) understanding differences in user characteristics and conversion performance across marketing channels.
   3) optimizing bids and allocating marketing spend across a multi-channel portfolio to acheive maximum performance.
*/
/* utm-content is a parameter that a company will use to track the specific adds. A company may use multiple adds and they tag them differently so that
   they can analyze which add performs better. */
USE mavenfuzzyfactory;
   
SELECT 
	utm_content,
     COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
     COUNT(DISTINCT orders.order_id) AS orders,
     COUNT(DISTINCT orders.order_id)/ COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conversion_rate
     FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 1
ORDER BY sessions DESC; 

/* From the output we can observe that social_media traffic is has less session_to_order_conversion_rate
ie., less sessions are converted into orders. */
