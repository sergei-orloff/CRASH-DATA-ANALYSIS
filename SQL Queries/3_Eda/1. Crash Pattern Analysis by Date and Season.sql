-- Find the busiest months for incidents:

SELECT 
    MONTH(CAST(Report_Date AS DATE)) AS crash_month,
    DATE_FORMAT(CAST(Report_Date AS DATE), '%M') AS month_name,
    COUNT(*) AS total_crashes
FROM crash_2024oct_clean
GROUP BY 
    MONTH(CAST(Report_Date AS DATE)),
    DATE_FORMAT(CAST(Report_Date AS DATE), '%M')
ORDER BY 
    total_crashes DESC,
    crash_month;
