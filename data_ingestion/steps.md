# Data Ingestion

## Overview
This document provides a comprehensive guide for downloading, setting up, and loading the financial fraud detection dataset into the database, and then ingesting it into Hadoop using Sqoop for the Financial Fraud Detection project.

## Steps

1. **Install Kaggle CLI**

    ```bash
    pip install kaggle
    ```

2. **Download the Dataset**

    Use Kaggle CLI to download the dataset:

    ```bash
    kaggle datasets download -d sriharshaeedala/financial-fraud-detection-dataset
    ```

    This command will download a ZIP file containing the dataset.

3. **Extract the ZIP File**

    After downloading, extract the ZIP file:

    ```bash
    unzip financial-fraud-detection-dataset.zip
    ```

4. **Create the Database**

    Create a new database in MySQL:

    ```bash
    create database final_project;
    ```

5. **Create the `transactions` Table**

    Create the `transactions` table in the `final_project` database:

    ```sql
    CREATE TABLE transactions (
        transaction_id SERIAL PRIMARY KEY,
        step INT,
        type VARCHAR(50),
        amount DECIMAL(18, 2),
        nameOrig VARCHAR(255),
        oldbalanceOrig DECIMAL(18, 2),
        newbalanceOrig DECIMAL(18, 2),
        nameDest VARCHAR(255),
        oldbalanceDest DECIMAL(18, 2),
        newbalanceDest DECIMAL(18, 2),
        isFraud BOOLEAN
    );
    ```

6. **Load Data into the Database**

    Load the data from the CSV file into the `transactions` table:

    ```bash
    LOAD DATA INFILE '/home/student/final_project_data/Synthetic_Financial_datasets_log.csv'
    INTO TABLE transactions
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (step, type, amount, nameOrig, oldbalanceOrig, newbalanceOrig, nameDest, oldbalanceDest, newbalanceDest, isFraud);
    ```

7. **Ingest Data into Hadoop using Sqoop**

    Use Sqoop to import the data from MySQL into Hadoop HDFS:

    ```bash
    sqoop import --connect jdbc:mysql://localhost/final_project --username root --table transactions --m 1 --target-dir /user/hadoop/transactions_data
    ```

## Technologies Used
- **Kaggle CLI** for downloading the dataset.
- **MySQL** for database creation and data loading.
- **Sqoop** for importing data from MySQL to Hadoop HDFS.

## Points of Contact
- Mustafa Ali: mustafa@example.com

