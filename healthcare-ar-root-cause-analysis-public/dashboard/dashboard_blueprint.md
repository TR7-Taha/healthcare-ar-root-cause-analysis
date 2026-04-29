# Dashboard Blueprint: High Aged AR Root Cause Analysis

## Goal
Show leadership where unresolved healthcare AR dollars are concentrated, what issues are causing the backlog, and which claims should be prioritized first.

## Page title
Root Cause Analysis of High Aged AR in Healthcare Billing

## Filters
- Insurance Name
- Status
- Status Code
- Assigned To
- Client
- State
- Primary/Secondary

## KPI cards
1. Total Outstanding Balance
2. Total Claims
3. Average Balance per Claim
4. Average Aging Days
5. Denied + Error Share
6. Payer Processing / Follow-up Balance Share

## Visual 1: Balance by Status
- chart type: horizontal bar chart
- dimension: Status
- measure: Sum of Balance Amount
- takeaway: where the money is stuck operationally

## Visual 2: Balance by Insurance Name
- chart type: horizontal bar chart
- dimension: Insurance Name
- measure: Sum of Balance Amount
- takeaway: which payers carry the largest dollars at risk

## Visual 3: Pareto of Status Codes
- chart type: combo chart
- bars: Sum of Balance Amount by Status Code
- line: cumulative % of total balance
- takeaway: which few issue types explain most of the backlog

## Visual 4: Balance by Assigned Team
- chart type: bar chart
- dimension: Assigned To
- measure: Sum of Balance Amount
- takeaway: workload concentration and queue bottlenecks

## Visual 5: Action Code by Balance
- chart type: bar chart
- dimension: Action Code
- measure: Sum of Balance Amount
- takeaway: what next actions dominate the work queue

## Visual 6: Highest-Risk Claim Table
Columns:
- VisitID#
- Insurance Name
- Status
- Status Code
- Action Code
- Assigned To
- Balance Amount
- Aging Days
- Priority Score

## Suggested calculated fields
### Denied + Error Share
COUNT(IF [Status] = 'Denied' OR [Status] = 'Error' THEN [VisitID#] END) / COUNT([VisitID#])

### Root Cause Category
CASE [Status Code]
WHEN 'Claim Error' THEN 'Submission / Coding Error'
WHEN 'Incorrect Submission' THEN 'Submission / Coding Error'
WHEN 'Invalid Procedure Code' THEN 'Submission / Coding Error'
WHEN 'Missing Modifiers' THEN 'Submission / Coding Error'
WHEN 'Provider Info Missing' THEN 'Submission / Coding Error'
WHEN 'Dx inconsistent with CPT' THEN 'Submission / Coding Error'
WHEN 'Duplicate Claim' THEN 'Submission / Coding Error'
WHEN 'Claim not on file' THEN 'Payer Processing / Follow-up'
WHEN 'Claim in Process' THEN 'Payer Processing / Follow-up'
WHEN 'Pending Follow-up' THEN 'Payer Processing / Follow-up'
WHEN 'No Response from Payer' THEN 'Payer Processing / Follow-up'
WHEN 'Eligibility Pending' THEN 'Eligibility / Coverage'
WHEN 'Member Not Eligible' THEN 'Eligibility / Coverage'
WHEN 'Coordination of Benefits Issue' THEN 'Eligibility / Coverage'
WHEN 'Medical Necessity' THEN 'Clinical / Authorization'
WHEN 'Offset' THEN 'Payment Posting / Recovery'
WHEN 'Overpayment' THEN 'Payment Posting / Recovery'
WHEN 'Paid to Patient' THEN 'Payment Posting / Recovery'
WHEN 'Payment Applied Elsewhere' THEN 'Payment Posting / Recovery'
ELSE 'Other'
END

### Priority Score
IF [Status] = 'Denied' OR [Status] = 'Error' THEN 25 ELSE 0 END
+
IF [Balance Amount] >= 900 THEN 25
ELSEIF [Balance Amount] >= 700 THEN 15
ELSE 5 END
+
IF [Aging Days] >= 500 THEN 20
ELSEIF [Aging Days] >= 350 THEN 10
ELSE 5 END
+
IF [Status Code] = 'Claim Error'
OR [Status Code] = 'Incorrect Submission'
OR [Status Code] = 'Claim in Process'
OR [Status Code] = 'Pending Follow-up'
OR [Status Code] = 'No Response from Payer'
THEN 20 ELSE 5 END

## Storyline for presentation
1. Show total dollars tied up in aged AR.
2. Show which statuses and status codes explain most of that balance.
3. Show which payers and teams carry the biggest workload risk.
4. End with a ranked list of claims and business actions to work first.
