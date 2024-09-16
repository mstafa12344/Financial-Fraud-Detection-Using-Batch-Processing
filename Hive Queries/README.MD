# Hive Queries Documentation for Fraud Detection Analysis

This documentation covers the Hive table structure, partitioning, bucketing, and the optimization strategies chosen for a fraud detection analysis. The goal is to ensure efficient querying, storage, and access for data analysis and reporting. Additionally, this guide provides explanations and examples of SQL queries used to gather insights from the data.

## Table of Contents
1. [Creating the Main Table: `fraud_detection`](#1-creating-the-main-table-fraud_detection)
2. [Storing Fraudulent Transactions](#2-storing-fraudulent-transactions)
3. [High-Value Fraudulent Transactions](#3-high-value-fraudulent-transactions)
4. [Most Common Fraudulent Transaction Types](#4-most-common-fraudulent-transaction-types)
5. [Optimization Techniques](#5-optimization-techniques)
6. [Additional Queries for Analysis and Visualization](#additional-queries-for-analysis-and-visualization)
7. [Taking Advantage of Partitioned `fraud_detection` Table](#taking-advantage-of-partitioned-fraud_detection-table)

## 1. Creating the Main Table: `fraud_detection`

The main table stores all transaction records. It's an **external table** because the data resides in HDFS and we don’t want Hive to manage the data lifecycle.

```sql
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
```

This external table points to the processed data stored in HDFS and allows efficient querying without moving the data.

---

## 2. Storing Fraudulent Transactions

This table stores all transactions flagged as fraudulent (`isFraud = TRUE`). It can be used for detailed analysis and reporting of fraudulent activities.

```sql
CREATE TABLE fraudulent_transactions AS
SELECT *
FROM fraud_detection
WHERE isFraud = TRUE;
```

- **Use case:** Can be queried by BI tools for fraud analysis reports or dashboards focused on fraudulent behavior.

---

## 3. High-Value Fraudulent Transactions

To highlight significant cases, this table stores the **top 100 fraudulent transactions** by amount. This table can be used for dashboards or reports to showcase the largest frauds.

```sql
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
```

- **Use case:** Important for risk management teams and executives to monitor the largest fraud cases.

---

## 4. Most Common Fraudulent Transaction Types

This table provides the most frequent types of fraudulent transactions. It can be used to understand trends and inform risk management strategies.

```sql
CREATE TABLE common_fraud_types AS
SELECT type,
       COUNT(*) AS fraud_count
FROM fraud_detection
WHERE isFraud = TRUE
GROUP BY type
ORDER BY fraud_count DESC;
```

- **Use case:** Helps identify which transaction types (e.g., `TRANSFER`, `PAYMENT`) are more prone to fraud.

---

## 5. Optimization Techniques

### Partitioning by Transaction Type

Partitioning the `fraud_detection` table by `type` allows for faster querying when looking at specific types of transactions. Partitioning ensures that only relevant partitions (or subsets) of data are scanned during query execution, improving performance.

```sql
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
```

**Loading data into partitions:**

```sql
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

INSERT INTO fraud_detection_partitioned PARTITION (type)
SELECT transaction_id, step, amount, nameOrig, oldbalanceOrig, newbalanceOrig, nameDest, oldbalanceDest, newbalanceDest, isFraud, type
FROM fraud_detection;
```

- **Why Partitioning by `type`:** Many queries are likely to involve filtering by transaction types (`TRANSFER`, `PAYMENT`, etc.). By partitioning, the system scans only the relevant partitions, avoiding a full table scan.

---

## Additional Queries for Analysis and Visualization

### a. Total Transactions

To count the total number of transactions:

```sql
SELECT COUNT(*) AS total_transactions FROM fraud_detection;
```

### b. Total Fraudulent Transactions

To count all fraudulent transactions:

```sql
SELECT COUNT(*) AS total_fraud_transactions FROM fraud_detection WHERE isFraud = TRUE;

-- Or we can use the fraudulent_transactions table
SELECT COUNT(*) FROM fraudulent_transactions;
```

### c. Fraud Percentage

To calculate the percentage of fraudulent transactions:

```sql
SELECT 
    (COUNT(CASE WHEN isFraud = TRUE THEN 1 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM 
    fraud_detection;
```

### d. Transaction Type Proportion (Pie Chart)

To get the proportion of each transaction type:

```sql
SELECT type,
       COUNT(*) AS transaction_count
FROM fraud_detection
GROUP BY type;
```

### e. Line Chart for Fraudulent Transactions Over Time

To plot fraudulent transactions over time (using the `step` field as a proxy for time):

```sql
SELECT step, COUNT(*) AS fraudulent_count
FROM fraud_detection
WHERE isFraud = TRUE
GROUP BY step
ORDER BY step;
```

### f. Stacked Bar Chart for Fraudulent vs Non-Fraudulent Transactions by Type

To compare fraudulent vs non-fraudulent transactions for each type:

```sql
SELECT type,
       SUM(CASE WHEN isFraud = TRUE THEN 1 ELSE 0 END) AS fraudulent_count,
       SUM(CASE WHEN isFraud = FALSE THEN 1 ELSE 0 END) AS non_fraudulent_count
FROM fraud_detection
GROUP BY type;
```

---

## Taking Advantage of Partitioned `fraud_detection` Table

Partitioning and bucketing are essential optimization techniques in Hive that improve query performance by reducing the amount of data that needs to be scanned. In the case of our **fraud_detection** dataset, we use partitioning by `type` (transaction type) and bucketing by `nameOrig` (origin account) to enhance query efficiency. Below are examples of how these optimizations can be leveraged.

### a. Total Transactions (Using Partitioned Table)

Querying the total number of transactions from the **partitioned table** (`fraud_detection_partitioned`) allows Hive to take advantage of partition elimination for future queries that filter by `type`.

```sql
SELECT COUNT(*) AS total_transactions
FROM fraud_detection_partitioned;
```

**Benefit:** Partitioning by `type` allows Hive to scan fewer partitions, which reduces query execution time, especially when filtering by specific transaction types.

### b. Total Fraudulent Transactions (Using Partitioned Table)

To count the total number of fraudulent transactions, the query can be run on the partitioned table. This enables Hive to scan relevant partitions when analyzing fraudulent transactions.

```sql
SELECT COUNT(*) AS total_fraud_transactions
FROM fraud_detection_partitioned
WHERE isFraud = TRUE;
```

**Benefit:** Partitioning improves the performance of filtering queries, such as identifying fraudulent transactions, by limiting the data scanned to only relevant partitions.

### c. Fraud Percentage (Using Partitioned Table)

To calculate the percentage of fraudulent transactions, we can use the partitioned table to efficiently gather total transactions and fraudulent transactions through subqueries.

```sql
WITH total_transactions AS (
    SELECT COUNT(*) AS total_count FROM fraud_detection_partitioned
),
total_fraud_transactions AS (
    SELECT COUNT(*) AS fraud_count FROM fraud_detection_partitioned WHERE isFraud = TRUE
)
SELECT (fraud_count * 100.0 / total_count) AS fraud_percentage
FROM total_transactions, total_fraud_transactions;
```

**Benefit:** The partitioning allows us to retrieve subsets of data faster, making the aggregation for the fraud percentage more efficient.

### d. Transaction Type Proportion (Using Partitioned Table)

This query calculates the proportion of each transaction type, taking full advantage of the partitioned table by avoiding scanning unnecessary partitions.

```sql
SELECT type, COUNT(*) AS transaction_count
FROM fraud_detection_partitioned
GROUP BY type;
```

**Benefit:** The `GROUP BY` operation is optimized since the data is already partitioned by `type`, allowing Hive to scan fewer partitions and thus improve query execution time.

### f. Stacked Bar Chart for Fraudulent vs Non-Fraudulent Transactions by Type (Using Partitioned Table)

To visualize fraudulent vs non-fraudulent transactions by `type`, the partitioned table helps Hive efficiently group and aggregate data.

```sql
SELECT type,
       SUM(CASE WHEN isFraud = TRUE THEN 1 ELSE 0 END) AS fraudulent_count,
       SUM(CASE WHEN isFraud = FALSE THEN 1 ELSE 0 END) AS non_fraudulent_count
FROM fraud_detection_partitioned
GROUP BY type;
```

**Benefit:** Since the table is partitioned by `type`, the `GROUP BY` operation can leverage partition pruning, making aggregation queries faster.

---

## File Structure for Queries

To organize the queries, we can create a file structure that categorizes them into different sections. Below is an example of how to structure the file:

refere to 
### `hive_queries.sql`
to see the full sql queries

This structure ensures that all queries are organized and easily accessible for future reference and execution.
