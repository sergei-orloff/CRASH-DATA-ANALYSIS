-- Weekday vs Weekend Crashes with Road Conditions

SELECT 
    CASE 
        WHEN WEEKDAY(CAST(Report_Date AS DATE)) IN (5,6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    ROAD_SURFACE_CONDITION_DESC,
    COUNT(*) as crash_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY CASE 
        WHEN WEEKDAY(CAST(Report_Date AS DATE)) IN (5,6) THEN 'Weekend'
        ELSE 'Weekday'
    END), 2) as percentage
FROM crash_2024oct_clean
GROUP BY 
    day_type,
    ROAD_SURFACE_CONDITION_DESC
ORDER BY 
    day_type,
    crash_count DESC;
