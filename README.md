# Banking Fraud Detection & Transaction Monitoring System

## Project Overview

This project simulates a real-world banking fraud monitoring solution designed to identify customers exhibiting potentially fraudulent behaviour using transaction analytics, customer risk indicators and complaint history.

The solution combines SQL-based data modelling with interactive Power BI dashboards to support fraud monitoring, operational reporting and customer-level investigations.

---

## Business Problem

Financial institutions process thousands of transactions every day, making manual fraud detection inefficient and time-consuming.

This project demonstrates how analytical models can be used to identify customers displaying suspicious transaction behaviour by combining multiple business-defined risk indicators into a unified fraud scoring framework.

---

## Project Objectives

- Detect unusually large customer transactions.
- Identify rapid transaction activity.
- Incorporate existing customer financial distress into fraud monitoring.
- Analyse complaint history as an additional fraud indicator.
- Calculate an overall fraud risk score.
- Categorise customers into fraud risk bands.
- Build interactive dashboards to support fraud monitoring and investigations.

---

## Business Rules

| Rule | Description | Weight |
|------|-------------|--------|
| Rule 1 | Transaction exceeds 5x customer's average transaction amount | 30 |
| Rule 2 | Customer performs 3 or more above-average transactions in a single day | 20 |
| Rule 3 | Customer belongs to High or Critical Financial Distress Risk Band | 25 |
| Rule 4 | Customer has 3 or more complaints | 25 |

Maximum Fraud Score = **100**

---

## Fraud Risk Classification

| Fraud Score | Risk Band |
|-------------|-----------|
| 0-29 | Low |
| 30-49 | Medium |
| 50-74 | High |
| 75-100 | Critical |

---

## SQL Workflow

The fraud monitoring model was developed using multiple Common Table Expressions (CTEs), each responsible for solving one business problem before combining the outputs into a final fraud profile.

### Workflow

```
Customer Transaction Profile
        ↓
Daily Activity Analysis
        ↓
Rapid Activity Detection
        ↓
Financial Distress Integration
        ↓
Complaint Risk Assessment
        ↓
Fraud Score Calculation
        ↓
Fraud Band Classification
        ↓
Fraud Monitoring Profile
```

---

## Power BI Dashboard

The project includes two interactive dashboards.

### Executive Dashboard

Designed for management reporting.

Features include:

- Fraud Band Distribution
- Branch Performance Analysis
- Complaint Risk Distribution
- KPI Cards
- Interactive Slicers

---

### Fraud Investigation Dashboard

Designed for operational fraud investigations.

Features include:

- Customer-level investigation table
- Fraud Score
- Fraud Band
- Large Transaction Indicator
- Rapid Activity Indicator
- Complaint Risk Indicator
- Distress Risk Indicator
- Interactive filtering by branch and risk category

---

## Technologies Used

- MySQL
- SQL (CTEs, CASE Statements, Aggregations)
- Power BI
- Data Modelling
- Business Intelligence

---

## Skills Demonstrated

- Data Analysis
- Fraud Analytics
- Risk Scoring
- SQL Data Modelling
- Dashboard Development
- Operational Reporting
- Business Intelligence
- Data Visualisation

---

## Dashboard Preview

### Executive Dashboard

![Executive Dashboard](executive%20dashboard.png)

### Fraud Investigation Dashboard

![Fraud Investigation Dashboard](Fraud%20Investigation%20Dashboard.png)

---

## Future Enhancements

Potential future improvements include:

- Real-time fraud monitoring
- Machine learning-based fraud prediction
- Automated fraud alert generation
- Customer behavioural trend analysis
- Drill-through investigation reports

---

## Author

**Sai Sachat Dadi**

MSc Business Analytics | SQL | Power BI | Python | Business Intelligence

Portfolio: *https://www.unimad.ai/portfolio/sai-sachat-dadi*

LinkedIn: *https://www.linkedin.com/in/saisachatdadi/*
