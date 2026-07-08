SELECT
cohort_year,
sum(total_rev) as total_revenue,
count(DISTINCT customerkey) as total_customer,
sum(total_rev)/count(DISTINCT customerkey) as customer_rrevenue
from cohort_analysis 
where orderdate = frist_purchase_date
GROUP BY
cohort_year

