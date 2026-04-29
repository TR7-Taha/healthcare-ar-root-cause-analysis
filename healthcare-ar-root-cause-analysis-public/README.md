# Root Cause Analysis of High Aged AR in Healthcare Billing

## Overview
This repository contains a portfolio case study built from a public Kaggle healthcare accounts receivable dataset. The project answers a practical business question:

**What are the main drivers of unresolved aged AR claims, and how should a billing company prioritize action to improve collections?**

The analysis was completed in **SQL Server** and structured as a business analyst case study focused on root cause analysis, KPI reporting, and operational recommendations.

## Business Problem
A healthcare billing company is carrying a large volume of unresolved aged claims in accounts receivable. Leadership needs to know:
- which issues are driving the backlog
- which payers represent the highest financial exposure
- where the team should focus first to recover revenue faster

## Objective
Identify the primary root causes of unresolved aged AR claims and translate those findings into actionable business recommendations.

## Dataset
- Source: Public Kaggle healthcare AR dataset
- Size: 200 claims, 21 columns
- Type: Aged AR / unresolved claims workflow snapshot
- Raw data is not duplicated here; see `data/dataset_source.txt` for the source link.

Key fields used:
- `Billed_Amount`
- `Balance_Amount`
- `Aging_Days`
- `Insurance_Name`
- `Status`
- `Status_Code`
- `Action_Code`
- `Assigned_To`
- `Worked_By`

## Tools Used
- **SQL Server** for analysis
- **Tableau / Power BI** for dashboarding
- **Excel** for validation and review
- **GitHub** for project documentation and presentation

## Key Findings
- Total outstanding balance: **$136,623.41**
- Average unresolved balance per claim: **$683.12**
- Average aging: **422 days**
- **Payer Processing / Follow-up** accounted for **44.39%** of outstanding balance
- **Submission / Coding Error** accounted for **40.96%** of outstanding balance
- Together, these two categories explained roughly **85%** of unresolved AR
- A small group of insurers accounted for the largest balance exposure: **Medicare, Cigna, Aetna, and Community Health Care**

## Business Recommendations
1. Prioritize high-balance denied and error claims first.
2. Build payer-specific escalation playbooks for the highest-risk insurers.
3. Strengthen front-end billing quality controls to reduce preventable submission and coding defects.
4. Separate payer follow-up work from correction/rework work.
5. Use a risk-based prioritization model based on balance, aging, and status severity.

## Repository Structure
```text
healthcare-ar-root-cause-analysis-public/
├── README.md
├── .gitignore
├── sql/
│   └── healthcare_ar_root_cause_analysis.sql
├── docs/
│   └── Healthcare_AR_Case_Study_Report.pdf
├── dashboard/
│   └── dashboard_blueprint.md
├── data/
│   ├── dataset_source.txt
│   └── data_notes.md
└── results/
    ├── 01_basic_profiling.csv
    ├── 02_status_exposure.csv
    ├── 03_status_code_exposure.csv
    ├── 04_payer_exposure.csv
    ├── 05_team_exposure.csv
    ├── 06_action_code_analysis.csv
    ├── 07_root_cause_categories.csv
    ├── 08_denied_error_share.csv
    ├── 09_payer_delay_share.csv
    ├── 10_highest_risk_claims.csv
    └── 11_priority_scores.csv
```

## Files to Review First
1. `README.md`
2. `docs/Healthcare_AR_Case_Study_Report.pdf`
3. `sql/healthcare_ar_root_cause_analysis.sql`
4. `results/07_root_cause_categories.csv`
5. `dashboard/dashboard_blueprint.md`

## Full Report
[`docs/Healthcare_AR_Case_Study_Report.pdf`](docs/Healthcare_AR_Case_Study_Report.pdf)

## Notes
- This is a **portfolio case study** built from a public dataset.
- Recommendations are presented as a simulated business analysis deliverable.
- The repository excludes the raw Kaggle CSV and personal interview-prep materials to keep the public version focused and professional.

## Author
**Taha Radou**  
Business Analytics / MIS graduate with interests in business analysis, root cause analysis, KPI reporting, and process improvement.
