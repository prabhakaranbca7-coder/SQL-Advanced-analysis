WITH rn_number AS (
	SELECT customerkey,
		concat,
		orderdate,
		row_number() over(
			PARTITION BY customerkey
			ORDER BY orderdate desc
		) AS rn,
		frist_purchase_date,
		cohort_year
	FROM cohort_analysis
),
customer_status AS (
	SELECT customerkey,
		concat,
		orderdate AS LAST_purcahse_date,
		cohort_year,
		CASE
			WHEN orderdate < (
				SELECT max(orderdate)
				FROM sales
			) - INTERVAL '6 months' THEN 'chured'
			ELSE 'Active'
		END AS customer_status
	FROM rn_number
	WHERE rn = 1
		AND frist_purchase_date < (
			SELECT max(orderdate)
			FROM sales
		) - INTERVAL '6 months'
)
SELECT cohort_year,
	customer_status,
	count(customerkey),
	sum(count(customerkey)) OVER() AS total_val,
	round(
		count(customerkey) / sum(count(customerkey)) OVER(),
		2
	) AS Pervcentage_val
FROM customer_status
GROUP BY customer_status,
	cohort_year