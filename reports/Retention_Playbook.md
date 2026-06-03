# Retention Playbook: Decoding Customer Value

## Executive Summary
This playbook translates customer segmentation data into actionable retention and promotional strategies. We focus on protecting margins from "Bargain Hunters" while elevating the experience for our "Full Price Shoppers."

---

## 1. Data Preparation & Feature Engineering (Logic & Justification)

To analyze customer value, we engineered four core metrics. Every feature was designed to answer a specific business question.

### A. Discount Dependency
*   **What it measures:** The ratio of purchases made using a promo code vs. total purchases.
*   **Justification:** Distinguishes between customers who value the *product* and those who value the *deal*. High dependency signals a risk to margin sustainability.

### B. eCLV (Estimated Customer Lifetime Value)
*   **What it measures:** A weighted score combining `Purchase Amount`, `Previous Purchases`, and `Frequency`.
*   **Justification:** Helps the brand prioritize high-value customers for premium services (e.g., "A1 Service") rather than treating all customers as equal.

### C. Engagement Score
*   **What it measures:** A composite of `Review Rating` and `Subscription Status`.
*   **Justification:** Captures brand sentiment. A high-spending customer with a low rating is a churn risk; a low-spending customer with a high rating is a brand advocate.

### D. Discount Risk Profile
*   **What it measures:** Categorization into *Full Price Shopper*, *Heavy Discounter*, or *High Risk (Bargain Hunter)*.
*   **Justification:** This is the primary decision-making engine for the Promotional Sunset Plan.

---

## 2. Promotional Sunset Plan

**Objective:** Gradually stop discounting for segments that erode margin without long-term loyalty.

### Segment: High Risk (Bargain Hunters)
*   **Why:** This segment (approx. 21% of base) has the lowest eCLV ($157) and the lowest engagement. They vanish when promos disappear.
*   **Trigger Behavior:** Two consecutive purchases where `Promo Code Used = Yes` followed by a 60-day inactivity period.
*   **Rollout Timeline:**
    *   **Phase 1 (Month 1):** Reduce standard discount from 30% to 10%.
    *   **Phase 2 (Month 2):** Stop direct %-off discounts. Replace with "Partner Bundles" (e.g., cross-brand makeup kits or electronic watch vouchers).
    *   **Phase 3 (Month 3):** Move segment to "Stock Clearance Only" list. They only receive offers for non-trending, high-inventory items.
*   **Metrics to Track:** Gross Margin per User (Target: +15%) and Churn Rate (Target: <30% loss of this segment).
*   **The Trade-off:**
    *   **The Action:** Cutting deep discounts for bargain hunters.
    *   **The Risk:** A potential 20% drop in total transaction volume. However, these transactions were likely margin-negative or neutral.

### Segment: Heavy Discounters
*   **The Action:** Transition from "Always On" discounts to "Appreciation Discounts" every 6 months.
*   **The Risk:** Temporary dip in purchase frequency as they wait for the 6-month window.

---

## 3. Ideal Customer Profile (ICP)

**The "High-Value Loyalist"**

*   **Demographic Profile:**
    *   **Primary Gender:** Male.
    *   **Age Range:** 35–55 (Core concentration at 39-46).
    *   **Location:** Alabama, Hawaii, Alaska (Top performing organic regions).
*   **Purchasing Behavior:**
    *   **Category:** Clothing and Accessories.
    *   **Payment:** Credit Card or PayPal (indicates higher financial stability).
    *   **Shipping:** Standard or Express (willing to pay for speed, not just seeking "Free Shipping").
*   **Value Indicators:**
    *   **Discount Profile:** Full Price Shopper.
    *   **Average Spent:** $60+ per transaction.
    *   **Frequency:** Weekly or Fortnightly.
*   **Targeting Strategy:**
    *   Market "A1 Service" (Priority Shipping and Early Access) rather than price drops.
    *   Use 6-month "Family Appreciation" gifts (Surprise % off or exclusive items) to maintain high engagement (Avg 3.7+).

---

## 4. Operational Recommendations (User POV Integration)

### A. Delivery Priority (The "A1 Service" Model)
*   **Recommendation:** Prioritize logistics for Full Price Shoppers. "Bargain Hunters" are moved to lower priority/slower shipping tiers.
*   **Trade-off:** Saving on express logistics costs for low-margin customers. *Risk:* Potential negative reviews from Bargain Hunters, which could slightly lower the aggregate site rating.

### B. Stock-Out Strategy
*   **Recommendation:** Use the Bargain Hunter segment as an "Inventory Liquidation" channel. Offer them 30%+ discounts ONLY on out-of-trend or overstock items.
*   **Trade-off:** Clears warehouse space and recovers capital. *Risk:* Brand dilution if high-end shoppers see these deep discounts; must be targeted via private email/SMS, not public site-wide banners.

### C. Cross-Brand Collaborations
*   **Recommendation:** Partner with beauty (for women) and tech (for men) brands for non-monetary rewards.
*   **Trade-off:** Diversifies the value proposition. *Risk:* Brand misalignment if the partner brand's quality doesn't match ours.
