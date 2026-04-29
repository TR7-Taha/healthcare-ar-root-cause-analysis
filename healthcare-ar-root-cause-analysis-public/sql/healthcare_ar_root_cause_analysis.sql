-- Root Cause Analysis of High Aged AR in Healthcare Billing
-- Assumes a table named healthcare_ar_claims already exists.
-- Adjust data types and table creation syntax for your SQL dialect.

-- 1) Basic profiling
SELECT COUNT(*) AS total_claims,
       SUM([Billed Amount]) AS total_billed_amount,
       SUM([Balance Amount]) AS total_outstanding_balance,
       AVG([Balance Amount]) AS avg_balance_amount,
       AVG([Aging Days]) AS avg_aging_days
FROM healthcare_ar_claims;

-- 2) Status-level exposure
SELECT [Status],
       COUNT(*) AS claim_count,
       SUM([Balance Amount]) AS total_balance,
       AVG([Balance Amount]) AS avg_balance
FROM healthcare_ar_claims
GROUP BY [Status]
ORDER BY total_balance DESC;

-- 3) Status code exposure
SELECT [Status Code],
       COUNT(*) AS claim_count,
       SUM([Balance Amount]) AS total_balance,
       AVG([Balance Amount]) AS avg_balance
FROM healthcare_ar_claims
GROUP BY [Status Code]
ORDER BY total_balance DESC;

-- 4) Payer exposure
SELECT [Insurance Name],
       COUNT(*) AS claim_count,
       SUM([Balance Amount]) AS total_balance,
       AVG([Balance Amount]) AS avg_balance
FROM healthcare_ar_claims
GROUP BY [Insurance Name]
ORDER BY total_balance DESC;

-- 5) Team exposure
SELECT [Assigned To],
       COUNT(*) AS claim_count,
       SUM([Balance Amount]) AS total_balance,
       AVG([Balance Amount]) AS avg_balance
FROM healthcare_ar_claims
GROUP BY [Assigned To]
ORDER BY total_balance DESC;

-- 6) Action code analysis
SELECT [Action Code],
       COUNT(*) AS claim_count,
       SUM([Balance Amount]) AS total_balance,
       AVG([Balance Amount]) AS avg_balance
FROM healthcare_ar_claims
GROUP BY [Action Code]
ORDER BY total_balance DESC;

-- 7) Root cause categories based on status code
SELECT
    CASE
        WHEN [Status Code] IN ('Claim Error','Incorrect Submission','Invalid Procedure Code',
                               'Missing Modifiers','Provider Info Missing','Dx inconsistent with CPT',
                               'Duplicate Claim')
             THEN 'Submission / Coding Error'
        WHEN [Status Code] IN ('Claim not on file','Claim in Process','Pending Follow-up',
                               'No Response from Payer')
             THEN 'Payer Processing / Follow-up'
        WHEN [Status Code] IN ('Eligibility Pending','Member Not Eligible','Coordination of Benefits Issue')
             THEN 'Eligibility / Coverage'
        WHEN [Status Code] IN ('Medical Necessity')
             THEN 'Clinical / Authorization'
        WHEN [Status Code] IN ('Offset','Overpayment','Paid to Patient','Payment Applied Elsewhere')
             THEN 'Payment Posting / Recovery'
        ELSE 'Other'
    END AS root_cause_category,
    COUNT(*) AS claim_count,
    SUM([Balance Amount]) AS total_balance,
    AVG([Balance Amount]) AS avg_balance
FROM healthcare_ar_claims
GROUP BY
    CASE
        WHEN [Status Code] IN ('Claim Error','Incorrect Submission','Invalid Procedure Code',
                               'Missing Modifiers','Provider Info Missing','Dx inconsistent with CPT',
                               'Duplicate Claim')
             THEN 'Submission / Coding Error'
        WHEN [Status Code] IN ('Claim not on file','Claim in Process','Pending Follow-up',
                               'No Response from Payer')
             THEN 'Payer Processing / Follow-up'
        WHEN [Status Code] IN ('Eligibility Pending','Member Not Eligible','Coordination of Benefits Issue')
             THEN 'Eligibility / Coverage'
        WHEN [Status Code] IN ('Medical Necessity')
             THEN 'Clinical / Authorization'
        WHEN [Status Code] IN ('Offset','Overpayment','Paid to Patient','Payment Applied Elsewhere')
             THEN 'Payment Posting / Recovery'
        ELSE 'Other'
    END
ORDER BY total_balance DESC;

-- 8) Denied + error share
SELECT
    SUM(CASE WHEN [Status] IN ('Denied','Error') THEN 1 ELSE 0 END) AS denied_error_claims,
    COUNT(*) AS total_claims,
    1.0 * SUM(CASE WHEN [Status] IN ('Denied','Error') THEN 1 ELSE 0 END) / COUNT(*) AS denied_error_share
FROM healthcare_ar_claims;

-- 9) Payer processing delay share
SELECT
    SUM(CASE WHEN [Status Code] IN ('Claim not on file','Claim in Process','Pending Follow-up','No Response from Payer')
             THEN [Balance Amount] ELSE 0 END) AS payer_delay_balance,
    SUM([Balance Amount]) AS total_balance,
    1.0 * SUM(CASE WHEN [Status Code] IN ('Claim not on file','Claim in Process','Pending Follow-up','No Response from Payer')
                   THEN [Balance Amount] ELSE 0 END) / SUM([Balance Amount]) AS payer_delay_balance_share
FROM healthcare_ar_claims;

-- 10) Highest-risk claims
SELECT TOP 10
       [VisitID#],
       [Insurance Name],
       [Status],
       [Status Code],
       [Action Code],
       [Assigned To],
       [Worked By],
       [Balance Amount],
       [Aging Days]
FROM healthcare_ar_claims
ORDER BY [Balance Amount] DESC, [Aging Days] DESC;

-- 11) Optional prioritization score
SELECT
    [VisitID#],
    [Insurance Name],
    [Status],
    [Status Code],
    [Balance Amount],
    [Aging Days],
    CASE WHEN [Status] IN ('Denied','Error') THEN 25 ELSE 0 END
    + CASE WHEN [Balance Amount] >= 900 THEN 25
           WHEN [Balance Amount] >= 700 THEN 15
           ELSE 5 END
    + CASE WHEN [Aging Days] >= 500 THEN 20
           WHEN [Aging Days] >= 350 THEN 10
           ELSE 5 END
    + CASE WHEN [Status Code] IN ('Claim Error','Incorrect Submission','Claim in Process','Pending Follow-up','No Response from Payer')
           THEN 20 ELSE 5 END AS priority_score
FROM healthcare_ar_claims
ORDER BY priority_score DESC, [Balance Amount] DESC;
