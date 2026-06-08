SELECT 
  m.category,
  COUNT(t.transaction_id) AS total_transactions,
  SUM(t.amount) AS gross_transaction_value, 
  SUM(t.promo_amount) AS total_promo_burn,
  
  ROUND(100 * SUM(t.promo_amount) / SUM(t.amount), 1) AS promo_burn_rate_pct

FROM 
  `dataanalystproject-497705.fintech_operations.fact_transactions` AS t
INNER JOIN 
  `dataanalystproject-497705.fintech_operations.dim_merchants` AS m
ON 
  t.merchant_id = m.merchant_id


WHERE 
  t.status = 'Success'

GROUP BY 
  m.category

ORDER BY 
  gross_transaction_value DESC;