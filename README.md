# Annual-Survey-of-Industries-Ministry-of-Statistics-and-Program-Implementation-
Annual Survey of Industries(ASI) data analysis using Python, e-Sankhyiki API, SQL and Power BI .
Annual Survey of Industries (ASI) — Data Analysis & Dashboard

📌 Project Overview

This project analyzes data from the Annual Survey of Industries (ASI) conducted by the Ministry of Statistics and Programme Implementation (MoSPI), Government of India.

The objective of the project was to collect, process, analyze, and visualize industrial data for selected Indian states over multiple years.

The complete workflow was automated using Python and the e-Sankhyiki library, followed by SQL-based data analysis and an interactive Power BI dashboard.

---

🔄 Project Workflow

MoSPI / e-Sankhyiki API
          ↓
     Python + API
          ↓
      Data Extraction
          ↓
     Pandas DataFrame
          ↓
      Data Cleaning
          ↓
    Export / Load Data
          ↓
        SQL
          ↓
   Data Analysis & KPIs
          ↓
    Power BI Dashboard

---

🛠️ Technologies Used

- Python — Data extraction and preprocessing
- e-Sankhyiki — Accessing official MoSPI statistical data through API
- Pandas — Data manipulation and DataFrame creation
- SQL / PostgreSQL — Data storage, querying, and analysis
- Power BI — Interactive dashboard and data visualization
- Git & GitHub — Version control and project documentation

---

📊 Data Source

The data used in this project comes from the Annual Survey of Industries (ASI) dataset provided by MoSPI.

The project uses the e-Sankhyiki Python library to access the available ASI data directly through the MoSPI API instead of manually downloading and entering the data.

The main indicator analyzed in the project is:

«Number of Factories»

The analysis focuses on selected states and yearly ASI data.

---

🐍 1. Data Extraction Using Python

The first stage of the project was to automate data collection.

Instead of manually collecting data from the website, the e-Sankhyiki Python library was used to access the MoSPI API.

Python was used to:

- Connect to the ASI dataset through e-Sankhyiki
- Retrieve metadata and available years
- Identify relevant state codes
- Identify the required indicator
- Fetch the required industrial data
- Store the retrieved information in Python structures

Example workflow:

import esankhyiki
import pandas as pd

The extracted API response was then converted into a structured Pandas DataFrame for further processing.

---

🧹 2. Data Processing & Transformation

After retrieving the data, Python and Pandas were used to transform the API response into a clean tabular structure.

The processing stage included:

- Structuring API responses
- Selecting required columns
- Mapping state codes to state names
- Organizing data by year and state
- Handling missing values
- Preparing the dataset for SQL analysis

The final output was stored in a structured format such as CSV/Excel for the next stage of the project.

---

🗄️ 3. SQL Analysis

The processed dataset was then loaded into a SQL database.

SQL was used to perform analytical queries and prepare the data required for the dashboard.

Examples of analysis included:

- Total number of factories
- State-wise industrial comparison
- Year-wise trends
- Industry-level analysis
- Identifying highest and lowest values
- Calculating KPIs and aggregated metrics

SQL helped convert the raw dataset into meaningful business insights.

---

📈 4. Power BI Dashboard

The final stage of the project was creating an interactive dashboard using Power BI.

The dashboard was designed to make the ASI data easier to understand through interactive visualizations.

Dashboard Features

- 📊 Total Industries / Factories KPI
- 📈 Year-wise trends
- 🗺️ State-wise comparison
- 🏭 Industry-level analysis
- 🔎 Interactive filters and slicers
- 📌 Key insights and summary metrics

Users can interact with the dashboard by selecting different states, years, and industries to explore the data.

---

💡 Key Insights

The dashboard provides insights into:

- How the number of factories has changed over time
- Differences in industrial activity between states
- Distribution of industries across selected states
- Year-wise changes in industrial activity
- Major contributors to the overall number of factories

---

📁 Project Structure

Annual-Survey-of-Industries/
│
├── python/
│   ├── data_extraction.py
│   ├── data_processing.py
│   └── requirements.txt
│
├── data/
│   └── ASI_data.csv
│
├── sql/
│   └── analysis_queries.sql
│
├── dashboard/
│   └── ASI_Dashboard.pbix
│
├── screenshots/
│   └── dashboard.png
│
└── README.md

---

🚀 End-to-End Pipeline

Step 1 — Extract

Official ASI data was accessed through the MoSPI API using e-Sankhyiki.

Step 2 — Transform

Python and Pandas were used to clean, structure, and transform the API response into a usable DataFrame.

Step 3 — Store

The processed dataset was exported and loaded into a SQL database.

Step 4 — Analyze

SQL queries were used to calculate metrics, aggregations, and derive insights from the dataset.

Step 5 — Visualize

The analyzed data was connected to Power BI to create an interactive dashboard.

---

🎯 Project Objective

The main objective of this project was to build an end-to-end data analytics pipeline using official government data.

The project demonstrates how raw statistical data can be transformed into meaningful insights through:

API → Python → Pandas → SQL → Power BI

This project also demonstrates practical experience in:

- API-based data extraction
- Python data processing
- Data cleaning
- SQL querying
- Data analysis
- Data visualization
- Dashboard development
- End-to-end data analytics workflow

---

👨‍💻 Author

Siddharth Chaudhary

This project was developed as part of a data analytics/internship project focused on working with official Indian government statistical data.

---

📌 Disclaimer

The data used in this project is sourced from official MoSPI statistical data. The project is intended for educational, analytical, and visualization purposes.
