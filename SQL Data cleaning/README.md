# SQL Data Cleaning and Validation for Dirty Shipments Dataset

This section covers the SQL steps used to clean and validate the `dirty_shipments` dataset.
The goal was to improve data quality by fixing text inconsistencies, handling null values, removing duplicates, validating dates, correcting numeric anomalies, and treating outliers.

---

## 1. Preview the Raw Dataset

First, I inspected the dataset to understand its structure and identify common data quality issues.

```sql
SELECT *
FROM `my-project-485806.sql_practice.dirty_shipments`
LIMIT 1000;
```

---

## 2. Standardize Text Fields

This step removes unnecessary spaces and standardizes text formatting across important categorical columns.

* `TRIM()` removes leading and trailing spaces
* `INITCAP()` converts text into proper case
* `UPPER()` standardizes state codes into uppercase

```sql
SELECT
    shipment_id,
    INITCAP(TRIM(origin_warehouse)) AS origin_warehouse,
    INITCAP(TRIM(destination_city)) AS destination_city,
    UPPER(TRIM(destination_state)) AS destination_state,
    INITCAP(TRIM(carrier)) AS carrier
FROM `my-project-485806.sql_practice.dirty_shipments`;
```

---

## 3. Handle `"NULL"` Strings and Missing Values

Some columns contained the literal string `"NULL"` instead of actual SQL `NULL` values.
This step converts those values properly and replaces missing entries with more meaningful placeholders.

* Converts `"NULL"` in `damage_reported` to actual `NULL`
* Replaces missing `destination_city` with `'Unknown'`
* Replaces missing `delivery_date` with `'Not Yet Delivered'`

```sql
SELECT
    shipment_id,
    CASE
        WHEN damage_reported = 'NULL' THEN NULL
        ELSE INITCAP(TRIM(damage_reported))
    END AS damage_reported,
    COALESCE(INITCAP(TRIM(destination_city)), 'Unknown') AS destination_city,
    COALESCE(delivery_date, 'Not Yet Delivered') AS delivery_date
FROM `my-project-485806.sql_practice.dirty_shipments`;
```

---

## 4. Remove Exact Duplicate Records

To ensure record uniqueness, I used `ROW_NUMBER()` to identify duplicate rows based on key shipment attributes and retained only the first occurrence.

```sql
WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                origin_warehouse,
                destination_city,
                carrier,
                ship_date,
                CAST(weight_kg AS STRING),
                CAST(freight_cost AS STRING)
            ORDER BY shipment_id
        ) AS rn
    FROM `my-project-485806.sql_practice.dirty_shipments`
)
SELECT * EXCEPT(rn)
FROM ranked
WHERE rn = 1;
```

---

## 5. Fix Invalid Numeric Values

This step corrects suspicious values in the `weight_kg` column.

* Negative weights are converted to positive using `ABS()`
* Zero weights are treated as missing and replaced with `NULL`

```sql
SELECT
    shipment_id,
    CASE
        WHEN weight_kg < 0 THEN ABS(weight_kg)
        WHEN weight_kg = 0 THEN NULL
        ELSE weight_kg
    END AS weight_kg
FROM `my-project-485806.sql_practice.dirty_shipments`;
```

---

## 6. Validate Shipment and Delivery Dates

To maintain logical consistency, I checked whether the delivery date occurs after the shipment date.

* Calculates transit time using `DATE_DIFF()`
* Flags invalid deliveries where `delivery_date < ship_date`
* Identifies same-day deliveries separately

```sql
SELECT
    shipment_id,
    ship_date,
    delivery_date,
    DATE_DIFF(
        SAFE.PARSE_DATE('%Y-%m-%d', delivery_date),
        SAFE.PARSE_DATE('%Y-%m-%d', ship_date),
        DAY
    ) AS transit_days,
    CASE
        WHEN SAFE.PARSE_DATE('%Y-%m-%d', delivery_date) < SAFE.PARSE_DATE('%Y-%m-%d', ship_date) THEN 'INVALID'
        WHEN SAFE.PARSE_DATE('%Y-%m-%d', delivery_date) = SAFE.PARSE_DATE('%Y-%m-%d', ship_date) THEN 'SAME DAY DELIVERY'
        ELSE 'VALID'
    END AS data_quality_flag
FROM `my-project-485806.sql_practice.dirty_shipments`;
```

---

## 7. Detect and Cap Outliers in Freight Cost Using IQR

To reduce the impact of extreme freight cost values, I applied the IQR (Interquartile Range) method.

* Calculates Q1 and Q3 using `APPROX_QUANTILES()`
* Defines lower and upper bounds using the IQR formula
* Caps extreme values outside the acceptable range
* Flags records that were identified as outliers

```sql
WITH stats AS (
    SELECT
        APPROX_QUANTILES(freight_cost, 100)[OFFSET(25)] AS q1,
        APPROX_QUANTILES(freight_cost, 100)[OFFSET(75)] AS q3
    FROM `my-project-485806.sql_practice.dirty_shipments`
    WHERE freight_cost > 0
),
bounds AS (
    SELECT
        q1 - 1.5 * (q3 - q1) AS lower_bound,
        q3 + 1.5 * (q3 - q1) AS upper_bound
    FROM stats
)
SELECT
    shipment_id,
    freight_cost AS original_cost,
    CASE
        WHEN freight_cost > (SELECT upper_bound FROM bounds) THEN (SELECT upper_bound FROM bounds)
        WHEN freight_cost < (SELECT lower_bound FROM bounds) THEN (SELECT lower_bound FROM bounds)
        ELSE freight_cost
    END AS cleaned_cost,
    CASE
        WHEN freight_cost > (SELECT upper_bound FROM bounds)
          OR freight_cost < (SELECT lower_bound FROM bounds)
        THEN TRUE
        ELSE FALSE
    END AS was_outlier
FROM `my-project-485806.sql_practice.dirty_shipments`;
```

---

## Key Data Cleaning Tasks Performed

* Standardized text formatting
* Handled missing and inconsistent null values
* Removed duplicate records
* Corrected suspicious numeric entries
* Validated business date logic
* Detected and treated outliers in freight cost

---

## Outcome

After applying these SQL cleaning steps, the dataset became more consistent, reliable, and suitable for further analysis or reporting. This process helped improve overall data quality and ensured the shipment records followed logical and business-valid rules.
