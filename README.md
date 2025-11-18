# Yelp Review Sentiment Analysis with AWS S3, Snowflake, and Python

> **Disclaimer:**  
> This project is *based on* the YouTube tutorial by **Ankit Bansal**:  
> https://www.youtube.com/watch?v=oXLxbk5USFg  
>
> Original GitHub Repository of the creator:  
> https://github.com/ankitbansal6/end_to_end_data_analytics_project  
>
> This repository contains **my own implementation** of the workflow demonstrated in the tutorial.  
> No original source code from the creator’s repository has been copied or redistributed.

---

## 📌 Overview

This project demonstrates an end-to-end data engineering and analytics workflow using:

- **Yelp Open Dataset**
- **AWS S3** for cloud storage
- **Snowflake** for data warehousing
- **Python** for preprocessing and sentiment analysis
- **SQL** for querying, transforming, and analyzing data

The goal is to process Yelp review and business data, load it into Snowflake, add sentiment scoring via a UDF, and perform several analytical tasks.

---

## 📂 Project Workflow

### **1. Download & Extract the Yelp Dataset**
- Downloaded the Yelp dataset `.tar` file.
- Extracted the contents to access:
  - `yelp_academic_dataset_review.json`
  - `yelp_academic_dataset_business.json`
  - (Other dataset files were not used.)

---

### **2. Data Preprocessing in Python (Jupyter Notebook)**
- The `yelp_academic_dataset_review.json` file is extremely large.
- To optimize upload and downstream processing:
  - The dataset was **split into 10 smaller JSON files** using `split_files.py`.
- Each resulting file was uploaded to **AWS S3**.

---

### **3. Loading Data into Snowflake from AWS S3**
Using Snowflake features such as `FILE FORMAT` and `COPY INTO`:
- Loaded all review and business JSON files from S3 into Snowflake tables.
- Converted and flattened nested JSON fields into structured table columns.

---

### **4. Adding Sentiment Analysis**
Using a Snowflake UDF provided in **UDF and tables.sql** in the creator's repo:
- Added a new column: `sentiment`
- Each review text was classified as:
  - `positive`
  - `neutral`
  - `negative`

---

## 📊 Data Analysis Tasks

After loading the data and computing sentiment, various SQL analyses were performed, including:

1. **Find the number of businesses in each category.**
2. **Find the top 10 users who have reviewed the most businesses in the "Restaurants" category.**
3. **Identify the most popular categories of businesses** (based on number of reviews).
4. **Retrieve the top 3 most recent reviews for each business.**
5. **Find the month with the highest number of reviews.**
6. **Calculate the percentage of 5-star reviews for each business.**
7. **Find the top 5 most reviewed businesses in each city.**
8. **Find the average rating of businesses that have at least 100 reviews.**
9. **List the top 10 users who have written the most reviews**, along with the businesses they reviewed.
10. **Find the top 10 businesses with the highest number of positive-sentiment reviews.**

---

## 🙌 Acknowledgment

This project is **based on and inspired by** the tutorial by **Ankit Bansal**:

- YouTube Video: https://www.youtube.com/watch?v=oXLxbk5USFg  
- Original GitHub Repository: https://github.com/ankitbansal6/end_to_end_data_analytics_project  

This repository contains **my own implementation** of the tutorial’s workflow  
and **does not include or redistribute** any of the original source code.

---
