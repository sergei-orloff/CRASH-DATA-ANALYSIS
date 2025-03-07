-- 1.1 Check the Structure of the Table

DESCRIBE crash_2024oct_short;

-- 1.2 Preview the First Few Rows
SELECT * FROM crash_2024oct_short LIMIT 10;

-- 1.3 Count the Total Number of Rows
SELECT COUNT(*) AS total_records FROM crash_2024oct_short;

-- 1.4 Check for Duplicates
SELECT REPORT_NUMBER, COUNT(*)
FROM crash_2024oct_short
GROUP BY REPORT_NUMBER, REPORT_SEQ_NO
HAVING COUNT(*) > 1;
