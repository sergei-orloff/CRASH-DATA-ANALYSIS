-- 4.1 Rank weather conditions by crash frequency:

SELECT Weather_Condition_Desc, COUNT(*) AS total_crashes
FROM crash_2024oct_clean
GROUP BY Weather_Condition_Desc
ORDER BY total_crashes DESC;


-- 4.2 Combine with road surface conditions for deeper insights:

SELECT Weather_Condition_Desc, Road_surface_Condition_Desc, COUNT(*) AS total_crashes
FROM crash_2024oct_clean
GROUP BY Weather_Condition_Desc, Road_surface_Condition_Desc
ORDER BY total_crashes DESC;
