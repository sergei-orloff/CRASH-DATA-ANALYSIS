SELECT LIGHT_CONDITION_DESC, COUNT(*) AS total_light_crashes
FROM crash_2024oct_clean
GROUP BY LIGHT_CONDITION_DESC
ORDER BY total_light_crashes DESC;
