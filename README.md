# 🚦 UK Road Traffic Accidents Analysis & Data Mart | 2020–2024

![R](https://img.shields.io/badge/R-Data%20Cleaning-276DC3?logo=r&logoColor=white)
![Apache Hive](https://img.shields.io/badge/Apache%20Hive-Data%20Mart-FDEE21?logo=apachehive&logoColor=black)
![Hadoop](https://img.shields.io/badge/Hadoop-HDFS-66CCFF?logo=apachehadoop&logoColor=black)
![Tableau](https://img.shields.io/badge/Tableau-Visualisation-E97627?logo=tableau&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-HiveQL-4479A1)
![Status](https://img.shields.io/badge/Status-Completed-success)

> **End-to-end analysis of England road traffic accident data from 2020–2024, covering data cleaning, validation, distributed storage, dimensional modelling, Hive analytics and Tableau visualisation.**

---

## 📌 Project Overview

This project analyses UK Government **STATS19 road-safety data for England between 2020 and 2024** to identify patterns associated with road collisions and their severity.

The project was completed as a **team project within the MSc Big Data Analytics programme at Sheffield Hallam University**, covering the complete analytical lifecycle from raw-data preparation through distributed storage, data-mart development, analysis and visualisation.

The solution combines **R, Hadoop/HDFS, Apache Hive, HiveQL, dimensional modelling and Tableau** to transform large road-safety datasets into structured analytical outputs and decision-support visualisations.

### Key Objectives

- Clean and validate large road-traffic datasets.
- Build a scalable analytical data mart.
- Analyse collision patterns across time, location and road conditions.
- Investigate relationships between severity, weather, vehicle characteristics and driver demographics.
- Create Tableau visualisations to communicate findings clearly to stakeholders.

---

## 👥 Team Project Contribution

The project was developed collaboratively, with team members contributing across the main stages of the analytical pipeline.

My involvement included:

- **Data Cleaning & Validation:** Cleaned, transformed and validated STATS19 road-traffic datasets using R, including missing-value handling, duplicate checks, date processing and consistency validation.
- **Data Storage & Data Mart Development:** Contributed to storing curated datasets in HDFS and developing the Hive analytical layer, including fact tables, dimension tables, joins and analytical queries.
- **Data Visualisation:** Contributed to Tableau dashboard development, transforming processed road-safety data into clear visual insights for analysis and presentation.

### End-to-End Workflow

```text
Raw STATS19 Data
        ↓
Data Cleaning & Validation
        ↓
Curated Datasets
        ↓
Hadoop / HDFS Storage
        ↓
Apache Hive Data Mart
        ↓
Analytical Queries
        ↓
Tableau Dashboards
        ↓
Road-Safety Insights
```

---

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| **R** | Data cleaning, transformation and validation |
| **dplyr / tidyverse** | Data manipulation and preprocessing |
| **Hadoop HDFS** | Distributed storage of curated datasets |
| **Apache Hive** | Data warehousing and large-scale analytical querying |
| **HiveQL / SQL** | Fact/dimension creation, joins and analytical queries |
| **Apache Parquet** | Columnar analytical storage |
| **Snappy Compression** | Efficient compressed storage |
| **DBSchema** | Dimensional data-model design |
| **Tableau** | Dashboard development and data visualisation |
| **Git / GitHub** | Version control and project documentation |

---

## 📊 Dataset

The project uses publicly available **UK Government STATS19 road-safety open data**.

### Collision Dataset

- **Coverage:** England
- **Period:** 2020–2024
- **Records:** 503,475
- **Original columns:** 44

Key variables include:

`collision_index`, `date`, `collision_severity`, `weather_conditions`, `road_surface_conditions`, `road_type`, `speed_limit`, `number_of_vehicles`, `number_of_casualties` and location attributes.

### Vehicle Dataset

- **Coverage:** England
- **Period:** 2020–2024
- **Records:** 920,692

Key variables include:

`collision_index`, `vehicle_type`, `vehicle_manoeuvre`, `sex_of_driver`, `age_band_of_driver` and `age_of_vehicle`.

### Dataset Relationship

The datasets are linked using:

```text
collision_index
```

This enables collision-level information to be analysed alongside vehicle and driver characteristics.

> Large raw datasets are excluded from this repository because of their size.

---

## 🏗️ Data Architecture

```text
          UK STATS19 Data
                 │
                 ▼
          ┌─────────────┐
          │      R      │
          │ Cleaning &  │
          │ Validation  │
          └──────┬──────┘
                 │
                 ▼
          Curated CSV Data
                 │
                 ▼
          ┌─────────────┐
          │ Hadoop HDFS │
          │ Distributed │
          │   Storage   │
          └──────┬──────┘
                 │
                 ▼
          ┌─────────────┐
          │ Apache Hive │
          │  Data Mart  │
          └──────┬──────┘
                 │
        ┌────────┴─────────┐
        ▼                  ▼
   Fact Tables       Dimension Tables
        │                  │
        └────────┬─────────┘
                 ▼
        Analytical Queries
                 │
                 ▼
          ┌─────────────┐
          │   Tableau   │
          │ Dashboards  │
          └─────────────┘
```

---

## 🧹 Data Cleaning & Quality Assurance

Data preparation was performed before loading the datasets into the analytical environment.

Key activities included:

- Selecting analysis-relevant fields.
- Checking and removing duplicate records.
- Handling missing and unknown values.
- Converting and validating date fields.
- Deriving month and year variables.
- Checking column data types.
- Mapping coded values to meaningful labels.
- Validating year values for 2020–2024.
- Checking month ranges.
- Validating relationships between collision and vehicle records.
- Comparing row counts before and after processing.

These checks helped maintain **data accuracy, consistency and integrity** throughout the pipeline.

---

## 🗄️ Hive Data Mart

The analytical layer was developed in **Apache Hive** using dimension and fact tables designed to support multiple analytical questions.

### Dimension Tables

```text
dim_time
dim_location
dim_severity
dim_age
dim_weather
dim_vehicle
dim_vehicle_age
dim_road_type
dim_road_surface
dim_speed_limit
dim_gender
dim_manoeuvre
```

### Fact Tables

```text
fct_accidents_1
fct_accidents_2
fct_accidents_3
fct_accidents_4
fct_accidents_5
```

The analytical tables use **Parquet storage with Snappy compression**:

```sql
STORED AS PARQUET
TBLPROPERTIES ('parquet.compression'='SNAPPY');
```

This provides efficient columnar storage for large analytical workloads.

---

## 🔍 Analytical Questions

### 1️⃣ Location, Severity & Age
How do collision volumes vary month by month across different locations, severity levels and driver age groups?

### 2️⃣ Weather & Severity
How do different weather conditions relate to collision frequency and severity?

### 3️⃣ Vehicle Type & Fatal Collisions
Which vehicle types and vehicle-age groups appear most frequently within fatal-collision records?

### 4️⃣ Road Environment
How do road type, road-surface condition and speed limits relate to collision volumes?

### 5️⃣ Young Drivers
What collision patterns can be identified among drivers aged **16–20** based on gender and vehicle manoeuvre?

---

## 📈 Selected Findings

### Weather Conditions
A large number of recorded collisions occurred during **fine weather with no high winds**. This does not necessarily indicate that fine weather causes more collisions, as traffic exposure and journey volumes may also influence collision frequency.

### Road Environment
High collision volumes were observed on **single carriageways**, particularly within common urban speed-limit environments.

### Vehicle Type
Cars accounted for a substantial proportion of fatal-collision records, while motorcycles and goods vehicles also appeared prominently in the analysis.

### Young Drivers
Analysis of drivers aged **16–20** enabled comparison across gender and vehicle manoeuvres, helping identify behavioural patterns within younger-driver collision records.

---

## 📊 Tableau Visualisation

Tableau was used to transform analytical results into interactive and understandable visual outputs.

The dashboards supported:

- Monthly trend analysis
- Collision severity comparison
- Location analysis
- Weather-condition analysis
- Vehicle-type analysis
- Road-condition analysis
- Driver demographic analysis

The visualisation stage focused on making complex road-safety data accessible to both technical and non-technical audiences.

---

## 📁 Repository Structure

```text
UK-Road-Accidents-Analysis-2020-24/
│
├── README.md
├── sql/
│   └── create_table_dim_fact.sql
├── r/
│   └── ADM-GPROJECT.Rproj
└── .gitignore
```

Additional project artefacts and visual outputs can be added as the portfolio repository is expanded.

---

## ▶️ Running the Project

### 1. Obtain the Data
Download the required STATS19 road-safety datasets from the UK Government open-data source.

### 2. Clean and Validate
Process the raw datasets in R:

```text
Raw CSV
   ↓
Column Selection
   ↓
Missing-Value Handling
   ↓
Date Processing
   ↓
Code-to-Label Transformation
   ↓
Validation Checks
   ↓
Curated Dataset
```

### 3. Load into HDFS

```bash
hdfs dfs -put clean_collision.csv /data/rta/
hdfs dfs -put clean_vehicle.csv /data/rta/
```

### 4. Build the Hive Data Mart
Execute:

```text
sql/create_table_dim_fact.sql
```

This creates the source tables, dimensions, fact tables and analytical queries.

### 5. Visualise
Connect Tableau to the processed analytical outputs and build dashboards for the required road-safety questions.

---

## ✅ Skills Demonstrated

- Data Analysis
- Data Cleaning
- Data Validation
- Data Quality Assurance
- SQL / HiveQL
- Dimensional Modelling
- Data Warehousing
- Big Data Processing
- Hadoop / HDFS
- Apache Hive
- ETL Workflows
- Data Reconciliation
- Tableau
- Dashboard Development
- Data Visualisation
- Analytical Problem Solving
- Stakeholder Communication
- Team Collaboration

---

## 🎯 Project Relevance

This project demonstrates practical experience relevant to **Data Analyst, Transport Data Analyst, Business Intelligence and Big Data Analytics roles**.

It shows the ability to:

- Work with large operational datasets.
- Clean and validate data.
- Build analytical data structures.
- Perform SQL-based analysis.
- Apply data-quality checks.
- Develop dashboards and visualisations.
- Identify meaningful trends.
- Communicate technical findings clearly.
- Work collaboratively across an end-to-end data project.

---

## 🎓 Project Context

**MSc Big Data Analytics — Sheffield Hallam University**  
**Team Project | England Road Traffic Data | 2020–2024**

Portfolio maintained by **Govardhan Reddy Machannagari**.

⭐ **An end-to-end team data project demonstrating the journey from raw road-safety data to structured analysis and visual insight.**
