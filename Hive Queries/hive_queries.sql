-- Creating the Main Table: fraud_detection
CREATE EXTERNAL TABLE IF NOT EXISTS fraud_detection (
    transaction_id INT,
    step INT,
    type STRING,
    amount DOUBLE,
    nameOrig STRING,
    oldbalanceOrig DOUBLE,
    newbalanceOrig DOUBLE,
    nameDest STRING,
    oldbalanceDest DOUBLE,
    newbalanceDest DOUBLE,
    isFraud BOOLEAN
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/student/processed_fraud_data/';

-- Storing Fraudulent Transactions
CREATE TABLE fraudulent_transactions AS
SELECT *
FROM fraud_detection
WHERE isFraud = TRUE;

-- High-Value Fraudulent Transactions
CREATE TABLE high_value_fraudulent_transactions AS
SELECT transaction_id,
       amount,
       nameOrig,
       nameDest,
       step
FROM fraud_detection
WHERE isFraud = TRUE
ORDER BY amount DESC
LIMIT 100;

-- Most Common Fraudulent Transaction Types
CREATE TABLE common_fraud_types AS
SELECT type,
       COUNT(*) AS fraud_count
FROM fraud_detection
WHERE isFraud = TRUE
GROUP BY type
ORDER BY fraud_count DESC;

-- Partitioning by Transaction Type
CREATE EXTERNAL TABLE IF NOT EXISTS fraud_detection_partitioned (
    transaction_id INT,
    step INT,
    amount DOUBLE,
    nameOrig STRING,
    oldbalanceOrig DOUBLE,
    newbalanceOrig DOUBLE,
    nameDest STRING,
    oldbalanceDest DOUBLE,
    newbalanceDest DOUBLE,
    isFraud BOOLEAN
)
PARTITIONED BY (type STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/student/processed_fraud_data/';

-- Loading data into partitions
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

INSERT INTO fraud_detection_partitioned PARTITION (type)
SELECT transaction_id, step, amount, nameOrig, oldbalanceOrig, newbalanceOrig, nameDest, oldbalanceDest, newbalanceDest, isFraud, type
FROM fraud_detection;

-- Additional Queries for Analysis and Visualization

-- Total Transactions
SELECT COUNT(*) AS total_transactions FROM fraud_detection;

-- Total Fraudulent Transactions
SELECT COUNT(*) AS total_fraud_transactions FROM fraud_detection WHERE isFraud = TRUE;
SELECT COUNT(*) FROM fraudulent_transactions;

-- Fraud Percentage
SELECT 
    (COUNT(CASE WHEN isFraud = TRUE THEN 1 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM 
    fraud_detection;

-- Transaction Type Proportion (Pie Chart)
SELECT type,
       COUNT(*) AS transaction_count
FROM fraud_detection
GROUP BY type;

-- Line Chart for Fraudulent Transactions Over Time
SELECT step, COUNT(*) AS fraudulent_count
FROM fraud_detection
WHERE isFraud = TRUE
GROUP BY step
ORDER BY step;

-- Stacked Bar Chart for Fraudulent vs Non-Fraudulent Transactions by Type
SELECT type,
       SUM(CASE WHEN isFraud = TRUE THEN 1 ELSE 0 END) AS fraudulent_count,
       SUM(CASE WHEN isFraud = FALSE THEN 1 ELSE 0 END) AS non_fraudulent_count
FROM fraud_detection
GROUP BY type;

-- Taking Advantage of Partitioned fraud_detection Table

-- Total Transactions (Using Partitioned Table)
SELECT COUNT(*) AS total_transactions
FROM fraud_detection_partitioned;

-- Total Fraudulent Transactions (Using Partitioned Table)
SELECT COUNT(*) AS total_fraud_transactions
FROM fraud_detection_partitioned
WHERE isFraud = TRUE;

-- Fraud Percentage (Using Partitioned Table)
WITH total_transactions AS (
    SELECT COUNT(*) AS total_count FROM fraud_detection_partitioned
),
total_fraud_transactions AS (
    SELECT COUNT(*) AS fraud_count FROM fraud_detection_partitioned WHERE isFraud = TRUE
)
SELECT (fraud_count * 100.0 / total_count) AS fraud_percentage
FROM total_transactions, total_fraud_transactions;

-- Transaction Type Proportion (Using Partitioned Table)
SELECT type, COUNT(*) AS transaction_count
FROM fraud_detection_partitioned
GROUP BY type;

-- Stacked Bar Chart for Fraudulent vs Non-Fraudulent Transactions by Type (Using Partitioned Table)
SELECT type,
       SUM(CASE WHEN isFraud = TRUE THEN 1 ELSE 0 END) AS fraudulent_count,
       SUM(CASE WHEN isFraud = FALSE THEN 1 ELSE 0 END) AS non_fraudulent_count
FROM fraud_detection_partitioned
GROUP BY type;