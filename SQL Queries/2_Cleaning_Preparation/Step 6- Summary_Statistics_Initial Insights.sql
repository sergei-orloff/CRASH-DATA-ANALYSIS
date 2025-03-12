-- 1. This provides an overview of the dataset.

SELECT 
    COUNT(*) AS total_crashes,
    COUNT(DISTINCT REPORT_NUMBER) AS total_accidents, -- There may be more than one vehicle involved.
    COUNT(DISTINCT REPORT_STATE) AS unique_states,
    COUNT(DISTINCT VEHICLE_LICENSE_NUMBER) AS unique_vehicles
FROM crash_2024oct_short;

-- ========================
/*
2. Show both  states’ counts in a single row for easy comparison
The result will show two columns:
- alaska_accidents: Count of unique accidents in Alaska
- alabama_accidents: Count of unique accidents in Alabama
*/
SELECT 
    SUM(CASE WHEN REPORT_STATE = 'AK' THEN 1 ELSE 0 END) AS alaska_accidents,
    SUM(CASE WHEN REPORT_STATE = 'AL' THEN 1 ELSE 0 END) AS alabama_accidents
FROM (
    SELECT DISTINCT REPORT_NUMBER, REPORT_STATE
    FROM crash_2024oct_short
    WHERE REPORT_STATE IN ('AK', 'AL')
) subquery;
