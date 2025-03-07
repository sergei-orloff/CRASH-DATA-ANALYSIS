-- 2.1 Check for NULL or Empty Values
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN REPORT_NUMBER IS NULL OR REPORT_NUMBER = '' THEN 1 ELSE 0 END) AS missing_report_number,
    SUM(CASE WHEN ROAD_SURFACE_CONDITION_DESC IS NULL OR ROAD_SURFACE_CONDITION_DESC = '' THEN 1 ELSE 0 END) AS missing_surface_condtn,
    SUM(CASE WHEN REPORT_DATE IS NULL OR REPORT_DATE = '' THEN 1 ELSE 0 END) AS missing_report_date,
    SUM(CASE WHEN REPORT_STATE IS NULL OR REPORT_STATE = '' THEN 1 ELSE 0 END) AS missing_report_state,
    SUM(CASE WHEN WEATHER_CONDITION_DESC IS NULL OR WEATHER_CONDITION_DESC = '' THEN 1 ELSE 0 END) AS missing_weather,
	SUM(CASE WHEN LIGHT_CONDITION_DESC IS NULL OR LIGHT_CONDITION_DESC = '' THEN 1 ELSE 0 END) AS missing_light_condtns,
    SUM(CASE WHEN VEHICLE_LICENSE_NUMBER IS NULL THEN 1 ELSE 0 END) AS missing_license_number
FROM crash_2024oct_short;

-- 2.2 replace empty license numbers with "N/A"

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

UPDATE `CRUSH PROJECT`.crash_2024oct_short
SET VEHICLE_LICENSE_NUMBER = 'N/A'
WHERE VEHICLE_LICENSE_NUMBER = '';

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM `CRUSH PROJECT`.crash_2024oct_short
WHERE VEHICLE_LICENSE_NUMBER = 'N/A';


-- ............................................
-- 2.3 Removing Completely Empty or Invalid Records
/*
Use this only after verifying the impact of deleting those rows.
*/

-- -- Disable safe update mode
-- SET SQL_SAFE_UPDATES = 0;

-- DELETE FROM crash_2024oct_short
-- WHERE REPORT_NUMBER IS NULL OR REPORT_DATE IS NULL;

-- -- Re-enable safe update mode
-- SET SQL_SAFE_UPDATES = 1;
