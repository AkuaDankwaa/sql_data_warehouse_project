# sql_data_warehouse_project
Portfolio project demonstrating modern data engineering: Medallion architecture, and ETL.

# 🗄️ Data Warehouse & Analytics Project  

![SQL](https://img.shields.io/badge/SQL-Server-blue)  
![ETL](https://img.shields.io/badge/ETL-Pipeline-green)  
![Data-Modeling](https://img.shields.io/badge/Data-Modeling-Star--Schema-orange)  
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)  

This is my implementation of a **Data Warehouse & Analytics solution**, built by following and recreating a GitHub project as a hands-on learning exercise.  

It demonstrates how to design a modern data warehouse, build ETL pipelines, create analytical data models, and generate insights — all following **data engineering best practices**.  

---

## 📖 Project Overview  

- **Data Architecture**: Implemented the Medallion Architecture (**Bronze**, **Silver**, **Gold** layers).  
- **ETL Pipelines**: Extracted, transformed, and loaded CSV datasets (ERP + CRM) into SQL Server.  
- **Data Modeling**: Designed **fact and dimension tables** in a star schema format.  
- **Analytics & Reporting**: Wrote SQL queries and created dashboards for insights.  

---

## 🚀 How to Run  

1. **Clone this repo**  
  ``bash
   git clone https://github.com/<AkuaDankwaa>/sql_data-warehouse-project.git
   cd data-warehouse-project


2. Set up SQL Server

  - Create a new database SalesDW

  - Run the scripts in /scripts/bronze to load raw data

  - Apply transformations from /scripts/silver

  - Build fact & dimension tables from /scripts/gold

3. Check Documentation

- Open /docs/ for naming convention, data catalog, data flow and data models diagrams.

4. Run Analytics Queries

- Example queries are provided in /scripts/gold/ for reporting.

📂 Repository Structure
data-warehouse-project/
│
├── datasets/            # ERP & CRM sample data (CSV format)
├── docs/                # Documentation & diagrams
├── scripts/             # SQL ETL scripts (bronze, silver, gold layers)
├── tests/               # Data validation scripts
└── README.md            # Project overview

📊 Screenshots & Diagrams

<img width="2365" height="1483" alt="data_model drawio" src="https://github.com/user-attachments/assets/093aae55-e50d-47ca-9199-0517b6f6c27d" />

📝 What I Learned

Building a layered data architecture for structured pipelines.

- The importance of data cleaning and validation.

- Designing star schema data models for efficient analytics.

- Documenting with data catalogs, ERDs, and naming conventions.

🔮 Next Steps

- Automate ETL with Python or Airflow

- Deploy on AWS/Azure cloud

- Add interactive Power BI / Tableau dashboards

🙌 Acknowledgements

This project was inspired by a GitHub data engineering project that I followed and rebuilt for learning purposes.
