-- Monthly_Crash_Count AS
SELECT 
    DATE_FORMAT(REPORT_DATE, '%Y-%m') AS Month,
    COUNT(*) AS Crash_Count
FROM crash_2024oct_clean
GROUP BY Month
ORDER BY Month;
