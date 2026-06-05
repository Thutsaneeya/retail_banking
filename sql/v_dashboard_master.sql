-- Create VIEW `v_dashboard_master` for Power BI
CREATE OR REPLACE VIEW `retail-banking-497710.retail_banking_ready.v_dashboard_master` AS
SELECT
  transaction_id,
  customer_id,
  -- Convert datetime to date format
  CAST(created_time AS DATE) AS activity_date,
  -- Calculate net amount (Credit as positive, Debit as negative)
  CASE 
    WHEN transaction_type = 'Credit' THEN amount 
    ELSE -amount 
  END AS net_amount,
  amount AS absolute_amount,
  transaction_type,
  transaction_channel,
  state,
  city,
  -- Segment customers into generational age groups
  CASE 
    WHEN age < 25 THEN 'Gen Z'
    WHEN age BETWEEN 25 AND 40 THEN 'Millennial'
    WHEN age BETWEEN 41 AND 60 THEN 'Gen X'
    ELSE 'Senior'
  END AS age_group,
  -- Categorize customers into wealth tiers 
  CASE 
    WHEN balance > 100000 THEN 'High Net Worth'
    WHEN balance BETWEEN 50000 AND 100000 THEN 'Affluent'
    ELSE 'Retail'
  END AS wealth_tier,
  account_type,
  account_status
FROM
  `retail-banking-497710.retail_banking_ready.banking_activity`;

