-- 2. Geographic Opportunity Map
-- Regions where demand is organic (Full Price Shoppers) 
-- vs. discount-driven. This answers Key Question #3.

SELECT
    location,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN discount_risk_profile = 'Full Price Shopper' THEN 1 ELSE 0 END) AS organic_customers,
    AVG(purchase_amount_usd) AS avg_spent,
    AVG(engagement_score) AS avg_engagement
FROM 
    customer_data
GROUP BY 
    location
HAVING 
    SUM(CASE WHEN discount_risk_profile = 'Full Price Shopper' THEN 1 ELSE 0 END) > 0
ORDER BY 
    avg_engagement DESC, 
    organic_customers DESC
LIMIT 20;