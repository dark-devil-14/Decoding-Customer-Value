/*
    BUSINESS QUESTION: Which product categories drive the highest long-term retention and engagement?
    GOAL: Analyze "Category Tenacity" by comparing average tenure (previous purchases), 
          Lifetime Value (eCLV), and Engagement across different product lines.
*/

SELECT 
    category,
    ROUND(AVG(previous_purchases), 2) AS avg_purchase_tenure,
    ROUND(AVG(eclv), 2) AS avg_eclv,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(discount_dependency), 2) AS avg_discount_dependency
FROM customer_data
GROUP BY category
ORDER BY avg_eclv DESC;
