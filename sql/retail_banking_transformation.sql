-- Create the destination dataset if it doesn't exist
CREATE SCHEMA IF NOT EXISTS `retail-banking-497710.retail_banking_ready`
  OPTIONS (location = 'asia-southeast1');

-- Create table for clean dataset
CREATE OR REPLACE TABLE `retail-banking-497710.retail_banking_ready.banking_activity` 
AS
SELECT
  c.customer_id,
  DATE_DIFF(CURRENT_DATE(), c.birth_date, YEAR) AS age,
  COALESCE(c.city,'Unknown') AS city,
  COALESCE(c.state,'Unknown') AS state,
  b.account_id,
  b.account_type,
  b.creation_date,
  b.account_status,
  b.balance,
  -- Fix: Null values 
  COALESCE(b.loan_amount, 0) AS loan_amount,
  COALESCE(b.term_months, 0) AS term_months,
  COALESCE(b.interest_rate, 0) AS interest_rate,
  t.transaction_id,
  t.created_time,
  t.transaction_type,
  t.transaction_code,
  t.amount,
  tc.label AS transaction_label,
  tc.channel AS transaction_channel
  FROM `retail-banking-497710.retail_banking_raw.customer_profiles` AS c
  LEFT JOIN `retail-banking-497710.retail_banking_raw.bank_accounts` AS b 
    ON c.customer_id = b.customer_id
  LEFT JOIN `retail-banking-497710.retail_banking_raw.account_transactions` AS t 
    ON b.account_id = t.account_id
  LEFT JOIN `retail-banking-497710.retail_banking_raw.transaction_code` AS tc 
    ON t.transaction_code = tc.transaction_code;











