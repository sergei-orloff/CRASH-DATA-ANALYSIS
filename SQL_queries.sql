
## Data Analysis Project Steps Using MySQL

### 1. Database Setup and Data Import

-- First, let's create a database and import crash data:

```sql
-- Create database
CREATE DATABASE crash_analysis;

-- Use the database
USE crash_analysis;

-- Create a table to store the crash data
CREATE TABLE crash_data (
    REPORT_NUMBER VARCHAR(20),
    REPORT_SEQ_NO INT,
    DOT_NUMBER VARCHAR(20),
    REPORT_DATE DATE,
    REPORT_STATE VARCHAR(2),
    FATALITIES INT,
    INJURIES INT,
    TOW_AWAY VARCHAR(1),
    HAZMAT_RELEASED VARCHAR(1),
    TRAFFICWAY_DESC VARCHAR(100),
    ACCESS_CONTROL_DESC VARCHAR(50),
    ROAD_SURFACE_CONDITION_DESC VARCHAR(50),
    WEATHER_CONDITION_DESC VARCHAR(50),
    LIGHT_CONDITION_DESC VARCHAR(50),
    VEHICLE_ID_NUMBER VARCHAR(20),
    VEHICLE_LICENSE_NUMBER VARCHAR(20),
    VEHICLE_LICENSE_STATE VARCHAR(2),
    SEVERITY_WEIGHT INT,
    TIME_WEIGHT INT,
    CITATION_ISSUED_DESC VARCHAR(10),
    SEQ_NUM INT,
    NOT_PREVENTABLE VARCHAR(1)
);
```
-- ==============================
-- For data import, we will need to clean up the data and use LOAD DATA INFILE or create an INSERT script.

### 2. Data Cleaning and Preparation

-- Once imported, check for data quality issues:

```sql
-- Check for missing values
SELECT 
    SUM(CASE WHEN REPORT_NUMBER IS NULL THEN 1 ELSE 0 END) AS missing_report_numbers,
    SUM(CASE WHEN REPORT_DATE IS NULL THEN 1 ELSE 0 END) AS missing_dates,
    SUM(CASE WHEN TRAFFICWAY_DESC IS NULL THEN 1 ELSE 0 END) AS missing_trafficway,
    SUM(CASE WHEN ROAD_SURFACE_CONDITION_DESC IS NULL THEN 1 ELSE 0 END) AS missing_road_conditions
FROM crash_data;

-- Fix any formatting issues like newlines in text fields
UPDATE crash_data
SET TRAFFICWAY_DESC = REPLACE(TRAFFICWAY_DESC, '\n', ' '),
    WEATHER_CONDITION_DESC = REPLACE(WEATHER_CONDITION_DESC, '\n', ' '),
    LIGHT_CONDITION_DESC = REPLACE(LIGHT_CONDITION_DESC, '\n', ' ');
```

### 3. Create Necessary Views and Indexes

```sql
-- Create indexes for better query performance
CREATE INDEX idx_report_date ON crash_data(REPORT_DATE);
CREATE INDEX idx_road_condition ON crash_data(ROAD_SURFACE_CONDITION_DESC);
CREATE INDEX idx_weather_condition ON crash_data(WEATHER_CONDITION_DESC);

-- Create useful views
CREATE VIEW fatal_crashes AS
SELECT * FROM crash_data WHERE FATALITIES > 0;

CREATE VIEW crash_by_conditions AS
SELECT 
    ROAD_SURFACE_CONDITION_DESC,
    WEATHER_CONDITION_DESC,
    COUNT(*) AS crash_count,
    SUM(FATALITIES) AS total_fatalities,
    SUM(INJURIES) AS total_injuries
FROM crash_data
GROUP BY ROAD_SURFACE_CONDITION_DESC, WEATHER_CONDITION_DESC;
```

### 4. Exploratory Data Analysis Queries

-- Here are some example analyses we can perform:

```sql
-- Monthly crash trends
SELECT 
    YEAR(REPORT_DATE) AS crash_year,
    MONTH(REPORT_DATE) AS crash_month,
    COUNT(*) AS total_crashes,
    SUM(FATALITIES) AS total_fatalities,
    SUM(INJURIES) AS total_injuries
FROM crash_data
GROUP BY crash_year, crash_month
ORDER BY crash_year, crash_month;

-- Road surface condition impact
SELECT 
    ROAD_SURFACE_CONDITION_DESC,
    COUNT(*) AS crash_count,
    SUM(FATALITIES) AS total_fatalities,
    SUM(INJURIES) AS total_injuries,
    ROUND(AVG(SEVERITY_WEIGHT), 2) AS avg_severity
FROM crash_data
GROUP BY ROAD_SURFACE_CONDITION_DESC
ORDER BY crash_count DESC;

-- Relationship between light conditions and crash severity
SELECT 
    LIGHT_CONDITION_DESC,
    COUNT(*) AS crash_count,
    SUM(FATALITIES) AS total_fatalities,
    SUM(INJURIES) AS total_injuries,
    ROUND(SUM(FATALITIES) / COUNT(*) * 100, 2) AS fatality_rate
FROM crash_data
GROUP BY LIGHT_CONDITION_DESC
ORDER BY fatality_rate DESC;

-- Citation analysis
SELECT 
    CITATION_ISSUED_DESC,
    COUNT(*) AS crash_count,
    SUM(FATALITIES) AS total_fatalities,
    ROUND(AVG(SEVERITY_WEIGHT), 2) AS avg_severity
FROM crash_data
GROUP BY CITATION_ISSUED_DESC;
```

### 5. Advanced Analysis

```sql
-- Cross-tabulation of road conditions and light conditions
SELECT 
    ROAD_SURFACE_CONDITION_DESC,
    SUM(CASE WHEN LIGHT_CONDITION_DESC LIKE '%Daylight%' THEN 1 ELSE 0 END) AS daylight_crashes,
    SUM(CASE WHEN LIGHT_CONDITION_DESC LIKE '%Dark%' THEN 1 ELSE 0 END) AS dark_crashes,
    COUNT(*) AS total_crashes
FROM crash_data
GROUP BY ROAD_SURFACE_CONDITION_DESC
ORDER BY total_crashes DESC;

-- Risk factor analysis using a weighted formula
SELECT 
    CONCAT(ROAD_SURFACE_CONDITION_DESC, ' + ', WEATHER_CONDITION_DESC) AS condition_combo,
    COUNT(*) AS crash_count,
    SUM(FATALITIES + INJURIES) AS total_casualties,
    ROUND(SUM(SEVERITY_WEIGHT * TIME_WEIGHT) / COUNT(*), 2) AS risk_score
FROM crash_data
GROUP BY condition_combo
HAVING crash_count > 1
ORDER BY risk_score DESC;
```

### 6. Statistical Analysis

```sql
-- Calculate potential correlation metrics
SELECT 
    'Ice Road Conditions' AS factor,
    (SELECT COUNT(*) FROM crash_data WHERE ROAD_SURFACE_CONDITION_DESC = 'Ice') / COUNT(*) AS prevalence,
    (SELECT SUM(FATALITIES) FROM crash_data WHERE ROAD_SURFACE_CONDITION_DESC = 'Ice') / 
     (SELECT SUM(FATALITIES) FROM crash_data) AS fatality_proportion
FROM crash_data
UNION
SELECT 
    'Dark Conditions' AS factor,
    (SELECT COUNT(*) FROM crash_data WHERE LIGHT_CONDITION_DESC LIKE '%Dark%') / COUNT(*) AS prevalence,
    (SELECT SUM(FATALITIES) FROM crash_data WHERE LIGHT_CONDITION_DESC LIKE '%Dark%') / 
     (SELECT SUM(FATALITIES) FROM crash_data) AS fatality_proportion
FROM crash_data;
```

### 7. Create a Stored Procedure for Routine Analysis

```sql
DELIMITER //
CREATE PROCEDURE analyze_crashes_by_condition(IN condition_type VARCHAR(50))
BEGIN
    IF condition_type = 'ROAD' THEN
        SELECT 
            ROAD_SURFACE_CONDITION_DESC AS condition,
            COUNT(*) AS crash_count,
            SUM(FATALITIES) AS fatalities,
            SUM(INJURIES) AS injuries,
            ROUND(AVG(SEVERITY_WEIGHT), 2) AS avg_severity
        FROM crash_data
        GROUP BY condition
        ORDER BY crash_count DESC;
    ELSEIF condition_type = 'WEATHER' THEN
        SELECT 
            WEATHER_CONDITION_DESC AS condition,
            COUNT(*) AS crash_count,
            SUM(FATALITIES) AS fatalities,
            SUM(INJURIES) AS injuries,
            ROUND(AVG(SEVERITY_WEIGHT), 2) AS avg_severity
        FROM crash_data
        GROUP BY condition
        ORDER BY crash_count DESC;
    ELSEIF condition_type = 'LIGHT' THEN
        SELECT 
            LIGHT_CONDITION_DESC AS condition,
            COUNT(*) AS crash_count,
            SUM(FATALITIES) AS fatalities,
            SUM(INJURIES) AS injuries,
            ROUND(AVG(SEVERITY_WEIGHT), 2) AS avg_severity
        FROM crash_data
        GROUP BY condition
        ORDER BY crash_count DESC;
    END IF;
END//
DELIMITER ;

-- Usage
CALL analyze_crashes_by_condition('ROAD');
```

### 8. Data Visualization Preparation

-- Prepare the data for visualization tools:

```sql
-- Create a summary table for visualization tools
CREATE TABLE crash_summary AS
SELECT 
    YEAR(REPORT_DATE) AS year,
    MONTH(REPORT_DATE) AS month,
    ROAD_SURFACE_CONDITION_DESC,
    WEATHER_CONDITION_DESC,
    LIGHT_CONDITION_DESC,
    COUNT(*) AS crash_count,
    SUM(FATALITIES) AS fatalities,
    SUM(INJURIES) AS injuries,
    ROUND(AVG(SEVERITY_WEIGHT), 2) AS avg_severity
FROM crash_data
GROUP BY year, month, ROAD_SURFACE_CONDITION_DESC, WEATHER_CONDITION_DESC, LIGHT_CONDITION_DESC;
```
-- ===============================================================
### 9. Documentation and Project Presentation

To showcase the project effectively I will:

1. Create a README document with project objectives and findings
2. Document all SQL queries used with explanations
3. Include sample results and insights
4. Add a data dictionary explaining each field

