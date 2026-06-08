WITH user_activity AS (
  SELECT DISTINCT
    u.user_id,
    DATE_TRUNC(u.signup_date, MONTH) AS cohort_month,
    DATE_DIFF(DATE_TRUNC(t.transaction_date, MONTH), DATE_TRUNC(u.signup_date, MONTH), MONTH) AS month_number
  FROM 
    `dataanalystproject-497705.fintech_operations.dim_users` AS u
  INNER JOIN 
    `dataanalystproject-497705.fintech_operations.fact_transactions` AS t
  ON 
    u.user_id = t.user_id
  
  -- SARINGAN BARU: Hanya loloskan user yang PUNYA transaksi di bulan registrasinya (Bulan 0)
  WHERE u.user_id IN (
    SELECT DISTINCT fact_t.user_id 
    FROM `dataanalystproject-497705.fintech_operations.fact_transactions` AS fact_t
    INNER JOIN `dataanalystproject-497705.fintech_operations.dim_users` AS dim_u
    ON fact_t.user_id = dim_u.user_id
    WHERE DATE_TRUNC(fact_t.transaction_date, MONTH) = DATE_TRUNC(dim_u.signup_date, MONTH)
  )
)

SELECT
  cohort_month,
  COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END) AS total_users,
  ROUND(100 * COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END) / COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 1) AS bulan_0_pct,
  ROUND(100 * COUNT(DISTINCT CASE WHEN month_number = 1 THEN user_id END) / COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 1) AS bulan_1_pct,
  ROUND(100 * COUNT(DISTINCT CASE WHEN month_number = 2 THEN user_id END) / COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 1) AS bulan_2_pct,
  ROUND(100 * COUNT(DISTINCT CASE WHEN month_number = 3 THEN user_id END) / COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 1) AS bulan_3_pct,
  ROUND(100 * COUNT(DISTINCT CASE WHEN month_number = 4 THEN user_id END) / COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 1) AS bulan_4_pct
FROM 
  user_activity
GROUP BY 
  cohort_month
ORDER BY 
  cohort_month;