# End-to-End HR Analytics Pipeline & Executive Dashboard

## 📌 Project Overview
This portfolio project demonstrates a complete, enterprise-grade data lifecycle pipeline. Using a raw HR dataset of 100 employees, I designed and implemented an end-to-end architecture that spans **Data Ingestion**, **Exploratory Data Analysis (SQL)**, **Programmatic Data Engineering (Python/Pandas)**, and **Executive Business Intelligence (Power BI)**. 

The objective of this project was to mock a real-world corporate workflow: taking messy, unstructured raw data, storing it securely in a relational database, processing data integrity anomalies programmatically, engineering deep behavioral features, and serving interactive data models to C-suite stakeholders.

---

## 🛠️ Tech Stack & Architecture Workflow

### 1. Database Architecture & Data Ingestion
* **Tools:** Python (`SQLAlchemy`, `mysql-connector`), MySQL Workbench
* **Execution:** Instead of relying on rigid UI import wizards which fail due to local file system permissions, I engineered a robust Python script to establish a local database engine connection. The script automatically standardized raw column headers into uniform database syntax (`snake_case`) and forced-ingested the raw data records directly into a local MySQL instance.

### 2. Exploratory Data Analysis (EDA) via Advanced SQL
* **Tools:** MySQL Workbench
* **Execution:** Authored a comprehensive repository of **20 analytical business queries** progressing from basic corporate indicators to complex analytical calculations. Key implementations included:
  * Dynamic string-to-date parsing (`STR_TO_DATE`) to unlock chronological metrics.
  * Conditional logic (`CASE WHEN`) to segment multi-generational workforces.
  * **Window Functions** (`DENSE_RANK() OVER (PARTITION BY...)`) to rank employee compensation scales natively inside individual organizational divisions.
  * Advanced window aggregate running totals to model corporate payroll growth scaling over historical hiring timelines.

### 3. Programmatic Data Engineering & Feature Engineering
* **Tools:** PyCharm, Python (`Pandas`)
* **Execution:** Leveraged SQL to audit data anomalies, discovering hidden duplicate email entities. I then built an automated data cleaning script in Pandas to isolate and resolve these data integrity breaches programmatically by appending unique employee identifiers to the duplicate strings.
* **Feature Engineering:** Transformed baseline metrics into advanced business pillars by creating 4 key data model dimensions:
  * `full_name`: String concatenation for cleaner visualization mapping.
  * `age_group`: Categorical age bucketing (`Under 30`, `30-45`, `Over 45`).
  * `salary_tier`: Strict conditional tiering classifying organizational ranks (from Executive to Associate).
  * `years_of_tenure`: Calculated dynamic tenure footprints using 2026 as the active base tracking year.

### 4. Business Intelligence Dashboard (Power BI)
* **Tools:** Power BI Desktop
* **Execution:** Ingested the production-clean dataset to build an interactive executive dashboard. Fixed default numerical aggregation behaviors to map exact organizational realities.
* **Dashboard Visual Features:** * Fixed high-level executive KPI indicators showing true corporate metrics.
  * Implemented cross-filtering slicers allowing HR directors to dynamically pivot data across specific genders and operational departments.
  * Strict formatting over raw numbers to convert them into standard business currency expressions (`$6.69M`, `$66.90K`).

---

## 📊 Key Executive Insights Uncovered
* **Workforce Scale:** Total active corporate headcount sits at **100 employees**.
* **Financial Commitments:** Total company-wide annual payroll commitments equal **$6.69M**.
* **Compensation Averages:** The baseline average salary across the company tracks at **$66.90K**.
* **Retention Footprint:** The organization boasts high stability and loyalty, maintaining an average workforce tenure of **6.22 years**.

---

## 📂 Repository Directory Structure
* 📁 Data: conatins raw as well as cleaned data csv files
* 📁 Scripts: contains mysql queries and python file 
* 📁 Report: contains power BI report and its pdf file
