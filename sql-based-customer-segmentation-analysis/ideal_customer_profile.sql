-- Defining the "Ideal Customer Profile"
WITH TopCustomers as (
    SELECT *, NTILE(10) over (order by eclv desc) as clv_percentile
    from customer_data
)

select
    ROUND(AVG(age), 2) as avg_age,
    CASE 
        WHEN gender = 1 THEN 'Male' 
        WHEN gender = 0 THEN 'Female' 
        ELSE 'Unknown' 
    END AS gender_label,
    category,
    payment_method,
    shipping_type, -- Fixed missing comma
    count(*) as customer_count
from TopCustomers
where clv_percentile = 1
group by 
    CASE 
        WHEN gender = 1 THEN 'Male' 
        WHEN gender = 0 THEN 'Female' 
        ELSE 'Unknown' 
    END, 
    category, 
    payment_method, 
    shipping_type
order by customer_count DESC
limit 10;