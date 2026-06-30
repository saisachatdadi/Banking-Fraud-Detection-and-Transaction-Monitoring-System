# Project: Banking Fraud Detection & Transaction Monitoring System
# Objective: Identify potentially fraudulent customers using transaction behavior, 
# customer risk profiles, and complaint history.

# Rules Of Identification:
# Rule 1: Flag customers with transactions exceeding 5x their average transaction amount
# Rule 2: Flag customers with 3 or more above-average transactions on a single day
# Rule 3: Flag customers classified as High or Critical in the customer distress model
# Rule 4: Flag customers with 3 or more complaints

# ctp stands for customer transaction profile
WITH ctp AS (SELECT customers.customer_id AS customer_id, 
CONCAT(customers.first_name, ' ', customers.last_name) AS customer_full_name,
branches.branch_name AS branch_name,
    COUNT(transactions.transaction_id) AS total_transactions,
    SUM(transactions.amount) AS total_transaction_amount,
    AVG(transactions.amount) AS avg_transaction_amount,
    MAX(transactions.amount) AS max_transaction_amount,
	CASE
		WHEN MAX(transactions.amount) > (AVG(transactions.amount) * 5) THEN 1
		ELSE 0
    END AS large_transaction_anomaly_flag
FROM customers
INNER JOIN account ON account.customer_id = customers.customer_id
INNER JOIN branches ON branches.branch_id = account.branch_id
INNER JOIN transactions ON transactions.account_id = account.account_id
GROUP BY customers.customer_id, customer_full_name, branches.branch_name
# CTE 1: Create customer transaction profile and identify large transaction anomalies
)
,
daily_activity_table AS (SELECT ctp.customer_id, transactions.transaction_date,
    COUNT(transactions.transaction_id) AS daily_above_avg_transactions
FROM ctp
INNER JOIN account ON account.customer_id = ctp.customer_id
INNER JOIN transactions ON transactions.account_id = account.account_id
WHERE transactions.amount > ctp.avg_transaction_amount
GROUP BY ctp.customer_id, transactions.transaction_date
# CTE 2: Count above-average transactions performed by customers on each day
)
,
rapid_activity_table AS (SELECT ctp.customer_id, ctp.customer_full_name, ctp.branch_name, ctp.total_transactions,
    ctp.total_transaction_amount, ctp.avg_transaction_amount, ctp.max_transaction_amount, ctp.large_transaction_anomaly_flag,
    MAX(daily_activity_table.daily_above_avg_transactions) AS rapid_activity_count,
    CASE
        WHEN MAX(daily_activity_table.daily_above_avg_transactions) >= 3
        THEN 1
        ELSE 0
    END AS rapid_activity_flag
FROM ctp
INNER JOIN daily_activity_table ON daily_activity_table.customer_id = ctp.customer_id
GROUP BY ctp.customer_id, ctp.customer_full_name, ctp.branch_name, ctp.total_transactions, ctp.total_transaction_amount,
    ctp.avg_transaction_amount, ctp.max_transaction_amount, ctp.large_transaction_anomaly_flag
    # CTE 3: Identify customers with concentrated transaction activity patterns
)
,
distress_risk_table AS (SELECT rapid_activity_table.customer_id, rapid_activity_table.customer_full_name,
    rapid_activity_table.branch_name, rapid_activity_table.total_transactions,
    rapid_activity_table.total_transaction_amount, rapid_activity_table.avg_transaction_amount,
    rapid_activity_table.max_transaction_amount, rapid_activity_table.large_transaction_anomaly_flag, 
    rapid_activity_table.rapid_activity_count, rapid_activity_table.rapid_activity_flag, customer_distress_profile.risk_score,
    customer_distress_profile.risk_band,
    CASE
        WHEN customer_distress_profile.risk_band IN ('High','Critical')
        THEN 1
        ELSE 0
    END AS distress_risk_flag
FROM rapid_activity_table
LEFT JOIN customer_distress_profile ON customer_distress_profile.customer_id = rapid_activity_table.customer_id
# CTE 4: Incorporate existing customer distress risk from the previous risk model
)
,
complaint_risk_table AS (SELECT distress_risk_table.customer_id, distress_risk_table.customer_full_name, distress_risk_table.branch_name,
    distress_risk_table.total_transactions, distress_risk_table.total_transaction_amount, distress_risk_table.avg_transaction_amount,
    distress_risk_table.max_transaction_amount, distress_risk_table.large_transaction_anomaly_flag,
    distress_risk_table.rapid_activity_count, distress_risk_table.rapid_activity_flag,
    distress_risk_table.risk_score, distress_risk_table.risk_band,
    distress_risk_table.distress_risk_flag,
    COUNT(complaints.complaint_id) AS total_complaints,
    CASE
        WHEN COUNT(complaints.complaint_id) >= 3
        THEN 1
        ELSE 0
    END AS complaint_risk_flag
FROM distress_risk_table
LEFT JOIN complaints ON complaints.customer_id = distress_risk_table.customer_id
GROUP BY distress_risk_table.customer_id, distress_risk_table.customer_full_name,
    distress_risk_table.branch_name, distress_risk_table.total_transactions,
    distress_risk_table.total_transaction_amount, distress_risk_table.avg_transaction_amount,
    distress_risk_table.max_transaction_amount, distress_risk_table.large_transaction_anomaly_flag,
    distress_risk_table.rapid_activity_count, distress_risk_table.rapid_activity_flag,
    distress_risk_table.risk_score, distress_risk_table.risk_band,
    distress_risk_table.distress_risk_flag
    # CTE 5: Calculate complaint volumes and identify complaint-related risk
)
,
fraud_score_table AS (SELECT complaint_risk_table.*,
    ((large_transaction_anomaly_flag * 30) + (rapid_activity_flag * 20) + (distress_risk_flag * 25) + (complaint_risk_flag * 25)) AS fraud_score
FROM complaint_risk_table
# CTE 6: Combine all fraud indicators into a unified fraud score
)
,
fraud_band_table AS (SELECT fraud_score_table.*,
    CASE
        WHEN fraud_score >= 75 THEN 'Critical'
        WHEN fraud_score >= 50 THEN 'High'
        WHEN fraud_score >= 30 THEN 'Medium'
        ELSE 'Low'
    END AS fraud_band
FROM fraud_score_table
# CTE 7: Categorize customers into fraud risk bands based on fraud score
)
SELECT *
FROM fraud_band_table;
# Final Output: Generate customer-level fraud monitoring profile for investigation and reporting
