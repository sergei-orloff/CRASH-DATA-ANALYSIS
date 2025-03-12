-- 3.1 Check the correct REPORT_STATE format.
SELECT DISTINCT REPORT_NUMBER, REPORT_STATE
    FROM crash_2024oct_short
    WHERE REPORT_STATE NOT IN ('AK', 'AL');

-- Validate Date Formats
SELECT REPORT_DATE FROM crash_2024oct_short 
WHERE STR_TO_DATE(REPORT_DATE, '%d-%b-%y') IS NULL;
-- ................................................
-- SELECT REPORT_DATE FROM crash_2024oct_short LIMIT 10;

-- ................................................
-- Convert Report Date to Proper Format
-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

UPDATE crash_2024oct_short
SET REPORT_DATE = STR_TO_DATE(REPORT_DATE, '%d-%b-%y');

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

SELECT REPORT_DATE FROM crash_2024oct_short LIMIT 10;

-- .................................................
-- Query to check for the format with exactly two letters followed by ten digits
-- SELECT REPORT_NUMBER
-- FROM crash_2024oct_short
-- WHERE REGEXP_LIKE(REPORT_NUMBER, '^[A-Za-z]{2}[0-9]{10}$');

-- -- Query to check for the records NOT following the required format
-- SELECT REPORT_NUMBER
-- FROM crash_2024oct_short
-- WHERE NOT REGEXP_LIKE(REPORT_NUMBER, '^[A-Za-z]{2}[0-9]{10}$');




    
    