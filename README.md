# UK Road Traffic Accidents Analysis (2020–2024)

Portfolio repository for an end-to-end road traffic accident analytics and data-mart project using UK STATS19 data for England, covering 2020–2024.

## Project focus

The project demonstrates data cleaning, validation, dimensional modelling, Hive-based analytics, and dashboard-ready outputs for road-safety analysis. It explores patterns in collision severity, location, weather, road conditions, vehicle characteristics, and young-driver behaviour.

## Tech stack

- R for data preparation and validation
- Hadoop / HDFS for distributed storage
- Apache Hive / HiveQL for data modelling and analysis
- Parquet with Snappy compression for analytical storage
- Tableau for visualisation and dashboarding
- DBSchema for dimensional modelling

## Repository structure

```text
.
├── sql/
│   └── create_table_dim_fact.sql
├── r/
│   └── ADM-GPROJECT.Rproj
└── README.md
```

Additional cleaned scripts, validation outputs, dashboard screenshots, and documentation will be added as the portfolio version is refined.

## Data

The analysis uses publicly available UK Government STATS19 road-safety data. Large raw and curated datasets are intentionally excluded from GitHub; the repository contains code and documentation needed to reproduce the analytical workflow.

## Key analytical areas

- Monthly collision patterns by location, severity, and age band
- Weather and severity analysis
- Fatal collisions by vehicle type and vehicle age
- Road type, surface condition, speed limit, and weather interactions
- Young-driver collision patterns by gender and manoeuvre

## Source and attribution

This portfolio repository is based on the road-traffic data-mart group project represented in the original project repository:
https://github.com/dishadhara23/UK-Road-Traffic-Accidents-Data-Mart-2020-2024-

The portfolio version is being reorganised for clearer presentation of the analytical workflow, code, outputs, and individual contribution.
