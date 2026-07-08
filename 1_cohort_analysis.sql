WITH table_value AS (
    SELECT customerkey,
        concat,
        sum(total_rev) AS total_reveue
    FROM cohort_analysis
    GROUP BY customerkey,
        concat
),
categories_val as(
    SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (
            ORDER BY total_reveue
        ) AS per_25,
        PERCENTILE_CONT(0.75) WITHIN GROUP (
            ORDER BY total_reveue
        ) AS per_75
    FROM table_value
),
segmentation_val AS(
    SELECT t.*,
        CASE
            WHEN t.total_reveue < c.per_25 THEN '1_low'
            WHEN t.total_reveue < c.per_75 THEN '2_mid'
            ELSE '3_high'
        END AS categories
    FROM table_value t,
        categories_val c
)
SELECT categories,
    sum(total_reveue),
    count(customerkey),
    sum(total_reveue) / count(customerkey) AS avg_
FROM segmentation_val
GROUP BY categories