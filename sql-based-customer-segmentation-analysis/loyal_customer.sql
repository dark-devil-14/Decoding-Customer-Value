-- // 1. Identifying "Genuinely Loyal" vs. "Bargain Hunters"

SELECT discount_risk_profile,
        count(customer_id) as total_customers,
        avg(engagement_score) as avg_engagement,
        avg(eclv) as avg_cust_life_time_value
from customer_data
GROUP BY discount_risk_profile
ORDER BY avg_engagement desc
