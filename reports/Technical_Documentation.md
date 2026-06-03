# 📓 Customer Data Intelligence: Preprocessing & Feature Engineering Documentation

This notebook serves as the definitive technical and business documentation for the customer data pipeline. It outlines the transition from raw transactional data to the **Gold Customer Dataset**, designed for high-impact analytics and machine learning.

---

## 1. Project Overview

### Business Problem
Understanding customer value is complex when looking at raw transactions. Static metrics often fail to capture the nuances of loyalty, discount dependency, and long-term potential. The business needs a unified view of the customer that quantifies their "health" and "value" beyond a single purchase.

### Project Objective
The objective is to transform raw customer data into a **Gold-standard dataset** by:
- Cleaning and standardizing transactional attributes.
- Engineering sophisticated features that quantify customer engagement and risk.
- Creating a foundation for downstream tasks like Churn Prediction, Segment-based Marketing, and CLV Modeling.

### Dataset Purpose
To provide a clean, feature-rich, and statistically validated dataset that represents the "Ground Truth" of customer behavior across different geographic locations and product categories.

### Expected Outcomes
- **Enhanced Segmentation:** Ability to identify "Bargain Hunters" vs. "Full Price Shoppers".
- **Predictive Readiness:** Features that correlate strongly with customer retention and high-value behavior.
- **Business Clarity:** A standardized data dictionary and feature set for all stakeholders.

---

## 2. Dataset Overview

- **Dataset Granularity:** Customer-level (1 row per unique Customer ID).
- **Number of Rows:** 3,900
- **Number of Columns:** 22 (after feature engineering)
- **Primary Key:** `Customer ID`

The dataset captures customer demographics, purchase behavior, payment preferences, and calculated intelligence metrics.

---

## 3. Data Dictionary

| Column Name | Full Form | Data Type | Description | Business Interpretation |
| :--- | :--- | :--- | :--- | :--- |
| **Customer ID** | Unique Identifier | Integer | Primary key for the customer. | Unique tracking ID. |
| **Age** | Customer Age | Integer | Age of the customer in years. | Demographic segmenting factor. |
| **Gender** | Gender (Encoded) | Binary | 1 = Male, 0 = Female. | Demographic segmenting factor. |
| **Item Purchased** | Item Name | Object | The specific product bought in the transaction. | Product preference. |
| **Category** | Product Category | Object | Broad group (Clothing, Footwear, etc.). | High-level interest area. |
| **Purchase Amount** | Amount (USD) | Integer | Transaction value in US Dollars. | Immediate revenue per transaction. |
| **Location** | US State | Object | Geographic location of the customer. | Regional market analysis. |
| **Size** | Product Size | Object | Size category (S, M, L, XL). | Fit and inventory analysis. |
| **Color** | Product Color | Object | Color of the item. | Aesthetic preference. |
| **Season** | Purchase Season | Object | Season of purchase (Winter, Spring, etc.). | Seasonal buying patterns. |
| **Review Rating** | Customer Rating | Float/Object | Rating from 1-5 or "Unengaged". | Sentiment and satisfaction proxy. |
| **Subscription Status**| Active Subscription | Binary | 1 = Yes, 0 = No. | Predictable revenue indicator. |
| **Shipping Type** | Shipping Method | Object | Method used (Express, Standard, etc.). | Logistics preference/Urgency. |
| **Discount Applied** | Discount Used | Binary | 1 = Yes, 0 = No. | Immediate price sensitivity. |
| **Promo Code Used** | Promo Code Flag | Binary | 1 = Yes, 0 = No. | Campaign engagement. |
| **Previous Purchases**| Purchase History | Integer | Count of prior successful orders. | Historical loyalty and tenure. |
| **Payment Method** | Payment Type | Object | Mode of payment used. | Fintech preference. |
| **Frequency** | Purchase Frequency | Ordinal | 1 (Weekly) to 5 (Annually). | Interaction velocity. |
| **Discount_Dep** | Discount Dependency | Integer | Sum of Discount + Promo (0 to 2). | Structural price sensitivity. |
| **Discount_Risk** | Risk Profile | Category | Segment based on spend and discounts. | Churn and margin risk flag. |
| **eCLV** | Estimated CLV | Integer | Amount $\times$ (1 + Frequency). | Long-term revenue potential. |
| **Engagement_Score** | Engagement Score | Integer | Composite loyalty score (-3 to 10). | Overall "Customer Health" metric. |

---

## 4. Data Preprocessing Journey

### Step 1: Missing Value Strategy for Review Ratings
- **Purpose:** 37 records had missing `Review Rating`. Mean imputation for subjective ratings can lead to biased models.
- **Method Used:** Imputed with the label **"Unengaged"**.
- **Impact:** Allows the model to distinguish between "Neutral" reviews and "No Interaction," which often acts as a churn signal.

### Step 2: Categorical to Binary Encoding
- **Purpose:** Convert human-readable "Yes/No" or "Male/Female" into machine-learning-ready numeric format.
- **Method Used:** Mapped `Gender`, `Subscription Status`, `Discount Applied`, and `Promo Code Used` to $1$ and $0$.
- **Impact:** Reduces computational overhead and prepares the dataset for regression and classification algorithms.

### Step 3: Ordinal Frequency Mapping
- **Purpose:** Raw frequency labels like "Fortnightly" or "Annually" are difficult to compare mathematically.
- **Method Used:** Mapped labels to an ordinal scale:
    - Weekly = 1
    - Bi-Weekly/Fortnightly = 2
    - Monthly = 3
    - Quarterly/Every 3 Months = 4
    - Annually = 5
- **Impact:** Converts categorical time-series data into a numeric feature where lower values represent higher velocity.

---

## 5. Feature Engineering Documentation

### Feature: Discount Dependency
- **Business Meaning:** Measures how reliant a customer is on price drops to make a purchase.
- **Calculation Logic:** 
$$Discount\_Dependency = \text{Discount\_Applied} + \text{Promo\_Code\_Used}$$
- **Why It Matters:** High dependency (score of 2) identifies "Deal Chasers" who may never buy at full price, impacting profit margins.

---

### Feature: Discount Risk Profile
- **Business Meaning:** Classifies customers by their value-to-risk ratio.
- **Calculation Logic:**
    - **High Risk:** Used both (Score 2) AND Spend < Median.
    - **Heavy Discounter:** Used both (Score 2).
    - **Casual Saver:** Used one (Score 1).
    - **Full Price Shopper:** Used none (Score 0).
- **Interpretation:** High Risk customers are the most likely to churn if discounts are removed. Full Price Shoppers are the "Loyalists" providing the best margins.

---

### Feature: Estimated CLV (eCLV)
- **Business Meaning:** A projected value of the customer based on their current spend and interaction frequency.
- **Calculation Logic:**
$$eCLV = \text{Purchase Amount (USD)} \times (1 + \text{Frequency Index})$$
- **Why It Matters:** Helps prioritize high-value customers for premium support or exclusive offers.

---

## 6. Customer Intelligence: Engagement Score

The **Engagement Score** is a composite metric designed to reflect the overall "health" of the customer relationship.

### Scoring Logic

| Attribute | Weight | Rationale |
| :--- | :---: | :--- |
| **Active Subscription** | $+3$ | Recurring revenue is high-value. |
| **History (>15 items)** | $+3$ | Proven long-term tenure. |
| **High Frequency (1-2)**| $+2$ | Weekly/Bi-weekly shoppers are highly active. |
| **Satisfaction (Rating $\ge$ 4)** | $+2$ | Happy customers are better advocates. |
| **Casual Discounting** | $-2$ | Penalty for reliance on single-use deals. |
| **Bargain Hunter (2)** | $-3$ | Heavy penalty for customers who only buy on double-deals. |

**Scale:** Minimum $-3$ to Maximum $+10$.

---

## 7. Final Gold Dataset Summary

### Why "Gold"?
This dataset is **"Gold"** because it is:
1.  **Denoised:** Subjective missing values are handled logically.
2.  **Quantified:** Abstract concepts like "Loyalty" and "Risk" are now numeric scores.
3.  **Standardized:** All categorical inputs are encoded for modeling.

### Downstream Use Cases
- **Churn Prediction:** Use `Engagement_Score` and `Discount_Risk_Profile` as key features.
- **Marketing Personalization:** Target "Casual Savers" with promo codes while keeping "Full Price Shoppers" on brand-loyalty tracks.
- **Revenue Forecasting:** Aggregate `eCLV` by location or category.

---

## 8. Data Quality Validation

- **Missing Values:** 0% in final features (handled `Review Rating`).
- **Duplicates:** 0 duplicate Customer IDs (1:1 granularity maintained).
- **Consistency:** `Discount_Risk_Profile` aligns with `Purchase Amount` distributions.
- **Schema Validation:** Data types are optimized (int/float for scores, category for profiles).

---

## 9. Executive Summary

We have successfully transformed a raw transactional file into a **high-intelligence customer dataset**. By moving beyond simple demographics, we have engineered features that capture the **behavioral DNA** of the customer base.

**Key Achievements:**
- Created a **Multi-factor Engagement Score** that identifies high-value loyalists.
- Developed a **Risk Profiling** system to protect profit margins from over-discounting.
- Established an **eCLV metric** for long-term strategic planning.
