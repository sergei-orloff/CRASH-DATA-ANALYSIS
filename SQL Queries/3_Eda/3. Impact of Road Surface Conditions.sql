-- 3.1 Identify the most dangerous road conditions:

SELECT Road_surface_Condition_Desc, COUNT(*) AS total_crashes
FROM crash_2024oct_clean
GROUP BY Road_surface_Condition_Desc
ORDER BY total_crashes DESC;
