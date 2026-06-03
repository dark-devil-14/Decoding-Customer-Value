/*
    BUSINESS QUESTION: What is the mix of "Full Price" vs. "Promo-Reliant" customers?
    GOAL: Quantify the percentage of the customer base within each Risk Profile 
          to identify the scale of discount dependency.
*/

SELECT 
    discount_risk_profile,     
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_total
FROM customer_data
GROUP BY discount_risk_profile
ORDER BY percentage_of_total DESC;
