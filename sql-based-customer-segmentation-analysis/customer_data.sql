/*
    DATA ASSET: Gold Layer Table Schema
    GOAL: Defines the final refined dataset after Python-based feature engineering. 
          Includes calculated fields like Engagement_Score and eCLV.
*/

CREATE TABLE customer_data (
    customer_id INT PRIMARY KEY,
    age INT,
    gender INT,
    item_purchased VARCHAR(255),
    category VARCHAR(255),
    purchase_amount_usd INT,
    location VARCHAR(255),
    size VARCHAR(50),
    color VARCHAR(50),
    season VARCHAR(50),
    review_rating VARCHAR(50), -- Numeric or 'Unengaged'
    subscription_status INT,
    shipping_type VARCHAR(255),
    discount_applied INT,
    promo_code_used INT,
    previous_purchases INT,
    payment_method VARCHAR(255),
    frequency_of_purchases INT,
    discount_dependency INT,
    discount_risk_profile VARCHAR(255),
    eclv INT,
    engagement_score INT
);
