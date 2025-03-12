-- Monthly Trend Analysis for Seasonal Planning

SELECT 
    DATE_FORMAT(CAST(Report_Date AS DATE), '%M') AS month,
    CASE 
        WHEN WEEKDAY(CAST(Report_Date AS DATE)) IN (5,6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) as crash_count,
    WEATHER_CONDITION_DESC,
    ROAD_SURFACE_CONDITION_DESC,
    LIGHT_CONDITION_DESC
FROM crash_2024oct_clean
GROUP BY 
    month,
    day_type,
    WEATHER_CONDITION_DESC,
    ROAD_SURFACE_CONDITION_DESC,
    LIGHT_CONDITION_DESC
ORDER BY 
    month,
    day_type,
    crash_count DESC;
