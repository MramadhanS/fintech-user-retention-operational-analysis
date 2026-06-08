SELECT 
  failure_reason,
  COUNT(transaction_id) AS jumlah_kegagalan,
  ROUND(100 * COUNT(transaction_id) / (SELECT COUNT(*) FROM       `dataanalystproject-497705.fintech_operations.fact_transactions` WHERE status = 'Failed'), 1) AS kontribusi_pct


FROM
  `dataanalystproject-497705.fintech_operations.fact_transactions`

WHERE 
  status = 'Failed'

GROUP BY 
  failure_reason

ORDER BY 
  jumlah_kegagalan DESC;