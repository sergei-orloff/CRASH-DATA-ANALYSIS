-- Detailed Day-of-Week Analysis with Time of Day

SELECT 
    DATE_FORMAT(CAST(Report_Date AS DATE), '%W') AS day_of_week,
    LIGHT_CONDITION_DESC,
    COUNT(*) as incident_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY DATE_FORMAT(CAST(Report_Date AS DATE), '%W')), 2) as day_percentage
FROM crash_2024oct_clean
GROUP BY 
    day_of_week,
    LIGHT_CONDITION_DESC
ORDER BY 
    FIELD(day_of_week, 
          'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    incident_count DESC;
