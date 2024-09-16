# Financial Fraud Detection Using Batch Processing

## Project Overview
This project aims to detect fraudulent transactions in a financial dataset by building a batch processing system. The system uses various technologies for data ingestion, storage, processing, querying, and machine learning to identify patterns of fraud and generate alerts for suspicious activities. Additionally, the system supports building a historical data pipeline for reporting and visualization purposes.

## Key Features
- **Ingest data**: Ingest financial transactions data from a relational database into Hadoop HDFS using Sqoop.
- **Process and transform data**: Perform data processing and transformation tasks using Apache Spark.
- **Query data**: Use Hive to query processed data and store the results for analysis.
- **Detect fraud**: Apply machine learning algorithms, such as Decision Trees or Support Vector Machines (SVM), to detect fraudulent activities.
- **Visualize results**: Create visualizations and generate reports using BI tools to gain insights from the detection process.

## Technologies Used
- **Sqoop**: For data ingestion from relational databases into Hadoop.
- **Hadoop**: For distributed storage of large datasets.
- **Apache Spark**: For high-performance data processing and transformation.
- **Hive**: For querying processed data stored in Hadoop.
- **BI Tool**: For visualizing results and generating reports (e.g., Tableau, Power BI).
- **Machine Learning**: Algorithms like Decision Trees or Support Vector Machines (SVM) to detect fraudulent transactions.

## Project Workflow

1. **Data Ingestion**:
   - Financial transactions data is extracted from a relational database (such as MySQL) and ingested into Hadoop HDFS using Sqoop.
   
2. **Data Processing and Transformation**:
   - Apache Spark is used to process and transform the ingested data for analysis and ML modeling.
   
3. **Data Querying**:
   - Using Hive, processed data is queried to extract relevant insights and fraud patterns.
   
4. **Fraud Detection Using ML**:
   - Machine learning algorithms, such as Decision Trees or SVM, are applied to detect fraud patterns from the processed data. The model is trained to identify patterns of fraudulent behavior.
   
5. **Visualization and Reporting**:
   - Results from the ML models and data queries are visualized using a BI Tool to generate dashboards and reports. These visualizations offer insights into the detection results, suspicious activities, and overall transaction patterns.

## System Architecture

- **Data Source**: Relational database (e.g., MySQL) containing financial transaction data.
- **Data Ingestion**: Sqoop imports data into HDFS.
- **Data Processing**: Apache Spark processes and transforms the data.
- **Data Storage**: Hadoop HDFS stores the processed data.
- **Querying**: Hive queries the processed data for ML and reporting.
- **ML Modeling**: Decision Tree or SVM models are used for fraud detection.
- **Visualization**: BI Tool is used for visualizations and generating reports.

## Installation Instructions

1. Install **Hadoop**, **Spark**, **Hive**, and **Sqoop** on your system.
2. Set up your relational database (e.g., MySQL) and ensure the necessary permissions for Sqoop to access the data.
3. Set up the environment for running machine learning models (Python, Scikit-learn, or similar).
4. Use Power BI to visualize the results.

