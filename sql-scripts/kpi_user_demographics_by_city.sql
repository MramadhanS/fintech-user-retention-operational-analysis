SELECT 
  u.city,
  COUNT(t.transaction_id) AS total_transactions,
  SUM(t.amount) AS gross_transaction_value,
  ROUND(AVG(u.age), 0) AS rata_rata_usia

FROM 
  `dataanalystproject-497705.fintech_operations.fact_transactions` AS t
INNER JOIN 
  `dataanalystproject-497705.fintech_operations.dim_users` AS u
ON 
  t.user_id = u.user_id

WHERE 
  t.status = 'Success'

GROUP BY 
  u.city

ORDER BY 
  gross_transaction_value DESC;