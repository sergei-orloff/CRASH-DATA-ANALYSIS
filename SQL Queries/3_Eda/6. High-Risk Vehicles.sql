-- Find vehicles involved in multiple accidents:

SELECT Vehicle_License_number, COUNT(*) AS crash_count
FROM crash_2024oct_clean
GROUP BY Vehicle_License_number
HAVING crash_count > 1
ORDER BY crash_count DESC;
