-- 5. Light Conditions & Nighttime Crash Risks

-- 5.1 Rank crashes by light condition:

SELECT Light_Condition_Desc, COUNT(*) AS total_crashes
FROM crash_2024oct_clean
GROUP BY Light_Condition_Desc
ORDER BY total_crashes DESC;

-- 5.2 Compare day vs. night crash rates:

 SELECT 
    CASE 
        WHEN Light_Condition_Desc LIKE 'Dark%' THEN 'Night'
        ELSE 'Day'
    END AS time_of_day, 
    COUNT(*) AS total_crashes
FROM crash_2024oct_clean
GROUP BY time_of_day;
