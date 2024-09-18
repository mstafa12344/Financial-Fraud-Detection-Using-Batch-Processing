# Fraud Detection Data Processing

## Introduction
This notebook provides a comprehensive analysis of the fraud detection dataset, from initial data loading and processing. The insights derived from this analysis can help in building robust fraud detection systems.

## Dataset
The dataset used in this analysis is sourced from Kaggle and can be accessed [here](https://www.kaggle.com](https://www.kaggle.com/datasets/sriharshaeedala/financial-fraud-detection-dataset/data)).
If you will be working with the notebook locally, Please ensure you have downloaded the dataset and placed it in the appropriate directory before running the notebook.

## Notebook Overview
### Sections:
* Environment Setup: In this step, essential libraries are imported, and a Spark session is initiated with optimized memory and partition settings. This setup ensures efficient data handling and processing for the entire workflow.
* Loading the Data: Data can be loaded either from HDFS (for large-scale distributed storage) or from local files (for smaller datasets). The choice depends on the dataset size and the environment.
* Exploratory Data Analysis: The dataset is inspected to understand its structure, content, and basic statistics. This step involves displaying data samples, reviewing schema, and calculating summary statistics to get an overall feel of the data.
* Data Processing & Transformation: Columns are renamed for clarity, missing values are handled, and necessary transformations like feature vector assembly and cleaning are performed to prepare the dataset for further analysis.
* Data Visualization: Visual representations of data, such as bar plots, histograms, and scatter plots, are used to analyze trends, relationships, and anomalies, especially in fraud-related transactions.
* Correlation Analysis: A correlation matrix is generated to examine relationships between numerical features. Visualizing this matrix helps identify which variables are strongly related to fraud detection.
* Save the DataFrame: After processing, the DataFrame can be saved either back to HDFS for distributed storage or locally for smaller-scale work. The format used is typically CSV for easy access and further analysis.
  
## Environment Options
1. Locally on Jupyter Notebook or JupyterLab:

   * Install Jupyter Notebook or JupyterLab.
   * Ensure all required libraries are installed.
   * Place the dataset in the same directory as the notebook.

2. Google Colab:

   * Upload the notebook and dataset to Google Colab.
   * Install the required libraries in the Colab environment using pip commands in code cells.
  
3. HDFS (Hadoop Distributed File System):

   * Ensure PySpark is configured and HDFS is accessible.
   * Load the dataset from HDFS into a PySpark DataFrame.

## Usage
1. Clone this repository.
2. Ensure you have the required libraries installed.
3. Download the dataset from Kaggle and place it in the directory containing this notebook (or upload to Colab/HDFS as applicable).
4. Open the notebook using Jupyter Notebook, JupyterLab, or Google Colab.
5. Run the cells sequentially to perform the analysis.
