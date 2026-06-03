# Project Update: Decoding Customer Value

## Overview
This document summarizes the exact transformations and analysis performed in `Notebook.ipynb` for the Decoding Customer Value project. The notebook reads the source data from `Dataset.csv`, performs cleaning and feature engineering, computes customer-level metrics (eCLV and Engagement Score), validates segments with statistical tests, and writes the output to `Gold_Customer_Data.csv`.

Files produced or used:
- `Dataset.csv` (source)
- `Gold_Customer_Data.csv` (output saved at /Users/rajuram/Desktop/working_with_ai/Decoding_Customer_Value/Gold_Customer_Data.csv)

## Data ingestion & initial checks
- Data loaded via `pd.read_csv("/Users/rajuram/Desktop/working_with_ai/Decoding_Customer_Value/Dataset.csv")`.
- Performed `df.info()`, `df.describe()`, unique value checks, and `df.isnull().sum()` to inspect structure, types, and missingness.

## Preprocessing & Encoding (exact operations from the notebook)
1. Review Rating handling
   - Missing values in `Review Rating` were filled with the string `'Unengaged'` using:

```python
df['Review Rating'] = df['Review Rating'].fillna('Unengaged')
```

2. Binary / boolean encodings
   - `Gender` mapped: `{'Male': 1, 'Female': 0}`
   - `Subscription Status` mapped: `{'Yes': 1, 'No': 0}`
   - `Discount Applied` mapped: `{'Yes': 1, 'No': 0}`
   - `Promo Code Used` mapped: `{'Yes': 1, 'No': 0}`

3. Frequency ordinal mapping
   - The `Frequency of Purchases` column was converted to an ordinal integer scale with the notebook mapping:

```python
frequency_map = {
    'Weekly': 1,
    'Bi-Weekly': 2,
    'Fortnightly': 2,
    'Monthly': 3,
    'Every 3 Months': 4,
    'Quarterly': 4,
    'Annually': 5
}
df['Frequency of Purchases'] = df['Frequency of Purchases'].map(frequency_map)
```

4. Discount dependency (deal layering)
   - A numeric `Discount_Dependency` column was created to count how many deal layers a customer used per transaction (0, 1, or 2):

```python
df['Discount_Dependency'] = (df['Discount Applied'] == 1).astype(int) + (df['Promo Code Used'] == 1).astype(int)
```

5. Discount risk profile
   - Using `np.select`, customers were bucketed into four labels based on `Discount_Dependency` and purchase amount relative to the dataset median. The notebook uses the following logic and choices array:

```python
condition = [
    (df['Discount_Dependency'] == 2) & (df['Purchase Amount (USD)'] < df['Purchase Amount (USD)'].median()),
    (df['Discount_Dependency'] == 2),
    (df['Discount_Dependency'] == 1),
    (df['Discount_Dependency'] == 0)
]
choices = [
    'High Risk (Bargain Hunter)',
    'Heavy Discounter',
    'Casual Saver',
    'Full Price Shopper'
]
df['Discount_Risk_Profile'] = np.select(condition, choices, default='Other')
```

6. eCLV calculation (estimated CLV)
   - The notebook computes a simple eCLV metric:

```python
df['eCLV'] = df['Purchase Amount (USD)'] * (1 + df['Frequency of Purchases'])
```

7. Engagement score (composite loyalty metric)
   - The notebook defines `calculate_engagement_score(row)` that assigns integer weights and penalties:
     - `+3` points for `Subscription Status == 1`
     - `+3` points for `Previous Purchases > 15`
     - `+2` points for `Frequency of Purchases` in [1,2] (Weekly/Bi-Weekly)
     - `+2` points for `Review Rating >= 4` (numeric ratings only; non-numeric `'Unengaged'` is ignored)
     - `-3` points when `Discount_Dependency == 2`
     - `-2` points when `Discount_Dependency == 1`
   - Implementation detail: the function casts `Review Rating` to `float` inside a `try/except` to skip `'Unengaged'` safely. Result saved in `df['Engagement_Score']`.

## Statistical validation (what was run)
- Implemented three statistical checks using `scipy.stats`:
  - Two-sample t-test between `Full Price Shopper` and `Heavy Discounter` groups on `Purchase Amount (USD)`:

```python
group_a = df[df["Discount_Risk_Profile"] == "Full Price Shopper"]["Purchase Amount (USD)"]
group_b = df[df["Discount_Risk_Profile"] == "Heavy Discounter"]["Purchase Amount (USD)"]
t_stat, p_val = stats.ttest_ind(group_a, group_b, equal_var=False)
print("t-test p-value:", p_val)
```

  - One-way ANOVA across all `Discount_Risk_Profile` groups:

```python
groups = [
    df[df["Discount_Risk_Profile"] == label]["Purchase Amount (USD)"]
    for label in df["Discount_Risk_Profile"].unique()
]
f_stat, p_val = stats.f_oneway(*groups)
print("ANOVA p-value:", p_val)
```

  - Chi-square test on the contingency table of `Subscription Status` vs `Discount_Risk_Profile`:

```python
contingency = pd.crosstab(df["Subscription Status"], df["Discount_Risk_Profile"])
chi2, p_val, dof, expected = stats.chi2_contingency(contingency)
print("Chi-square p-value:", p_val)
```

Notes: the notebook prints the p-values; those outputs indicate strong statistical differences in the dataset used (very small p-values were observed when the notebook was run).

## Artifacts produced
- `Gold_Customer_Data.csv` — the notebook writes the final dataframe to disk with `df.to_csv(.../Gold_Customer_Data.csv, index=False)`. This file includes the engineered columns: `Discount_Dependency`, `Discount_Risk_Profile`, `eCLV`, and `Engagement_Score` in addition to the original columns.

## Recommended next steps (concrete and prioritized)
1. Model building: Train a predictive model for churn and CLV using `Engagement_Score`, `eCLV`, frequency, and discount features. Start with a `RandomForest` or `XGBoost` baseline and evaluate with cross-validation.
2. Explainability: Compute feature importances and SHAP values to validate which behaviors drive `Engagement_Score` and predicted churn.
3. Robustness checks: Re-run statistical tests on bootstrapped samples and test sensitivity to the median threshold used in `High Risk` segmentation.
4. A/B experimentation: Design targeted discount experiments for `Casual Savers` vs `Full Price Shoppers` to measure revenue lift and cannibalization.
5. Dashboarding: Create dashboards showing distribution of `Discount_Risk_Profile`, `Engagement_Score`, and regional maps of high-risk clusters.
6. Productionization: Create a small ETL script that reproducibly applies the same mappings and writes `Gold_Customer_Data.csv` on new data arrivals. Add unit tests for the mapping dictionaries.

## What I changed in the notebook vs. what to document
- The notebook code is the source of truth. This `update.MD` expands the earlier high-level notes to include the exact mappings, formulas, and code snippets used — useful for handoff, audits, and reproducibility.

If you'd like, I can now:
- run quick validations (re-run the statistical tests and attach p-values),
- add a small `etl.py` script that encapsulates the notebook transformations, or
- prepare a short report-ready dashboard notebook with summary plots.

---
Updated: consolidated, fully reproducible summary of Notebook.ipynb operations.

---

## Today's Progress (Wednesday, May 27, 2026)

### 1. 📂 Project Restructuring
To maintain professional standards, the workspace has been reorganized into modular directories:
- **`data/`**: Centralized storage for raw and processed datasets (`Dataset.csv`, `Gold_Customer_Data.csv`).
- **`sql-based-customer-segmentation-analysis/`**: Dedicated folder for the SQL logic layer.
- **`tables/`**: Results folder for exported SQL query outputs.

### 2. 🏛️ SQL Analysis Layer
Implemented a structured query layer to answer core business questions. New SQL files created:
- `loyal_customer.sql`: Identifies "Genuinely Loyal" vs. "Bargain Hunters."
- `geographic_credibility.sql`: Maps organic demand vs. discount-driven volume.
- `category_retention_funnel.sql`: Analyzes tenure and engagement by product category.
- `ideal_customer_profile.sql`: Defines the Top 10% customer characteristics.

### 3. 📊 Table Generation
Executed the SQL queries and exported the results into the `tables/` directory for use in reporting and dashboarding:
- `Genuinely_loyal_cust.csv`
- `geographic_credibility.csv`
- `cateogry_retention_funnel.csv`
- `ideal_customer_profile.csv`

### 4. 📈 Trend Analysis & Visualization Review
- Analyzed 4 key visualizations (`Genuinely_loyal_cust.png`, `cateogry_retention_funnel.png`, etc.).
- Identified that **Full Price Shoppers** are the primary revenue anchor with the highest engagement (~3.7).
- Confirmed that **High Risk (Bargain Hunters)** show significant discount sensitivity and lower tenure.

### 5. 🗺️ Final Roadmap
Created `next_task.md` to track remaining high-value deliverables:
- **Retention Playbook**: Designing the "Promotional Sunset Plan."
- **Executive Summary**: A 1-page strategic brief for the founding team.
- **Power BI Dashboard**: Finalizing the four-panel layout.

---

## Today's Progress (Wednesday, June 3, 2026)

### 6. 📓 Professional Documentation Layer
- **`notebook.md`**: Developed a comprehensive, business-friendly documentation file to explain the technical preprocessing and feature engineering journey.
- **Technical & Business Alignment**:
    - Created a **Data Dictionary** for all 22 columns in the Gold dataset.
    - Documented the **Preprocessing Journey**, including the strategic decision to label missing reviews as "Unengaged."
    - Detailed the logic and business rationale for the **Engagement Score**, **eCLV**, and **Discount Risk Profile**.
    - Provided LaTeX-formatted formulas for mathematical clarity.
- **Value Addition**: This artifact bridges the gap between the Jupyter Notebook's code and the strategic insights needed by stakeholders, ensuring the "Gold" dataset is ready for executive review and downstream ML modeling.

