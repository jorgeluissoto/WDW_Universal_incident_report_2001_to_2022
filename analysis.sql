USE themeparks;

SELECT 
    *
FROM
    data;

-- Top five rides with the most incidents
SELECT 
    COUNT(Company) AS Company, Ride_name
FROM
    data
GROUP BY Ride_name
ORDER BY Company DESC
LIMIT 5;

-- Average age of people
SELECT 
    ROUND(AVG(age), 0)
FROM
    data;

-- Range of age group
-- Find the youngest and oldest first
SELECT 
    MIN(age) AS youngest, MAX(age) AS oldest
FROM
    data;

-- Create CASE statment to create groups
SELECT
	CASE
		WHEN age >= 1 AND age <= 10 THEN '1 - 10'
        WHEN age >= 11 AND age <= 20 THEN '11 - 20'
        WHEN age >= 21 AND age <= 30 THEN '21 - 30'
        WHEN age >= 31 AND age <= 40 THEN '31 - 40'
        WHEN age >= 41 AND age <= 50 THEN '41 - 50'
        WHEN age >= 51 AND age <= 60 THEN '51 - 60'
        WHEN age >= 61 AND age <= 70 THEN '61 - 70'
        WHEN age >= 71 AND age <= 80 THEN '71 - 80'
        ELSE '80+'
	END AS age_group,
    COUNT(age) AS count
FROM data
GROUP BY age_group
ORDER BY age_group;

-- Male v Female Incidents
SELECT 
    gender, COUNT(company) AS count
FROM
    data
GROUP BY gender;

-- Which year had the most incidents and the trend of incidents
SET sql_safe_updates = 0;

UPDATE data 
SET 
    incident_date = DATE_FORMAT(STR_TO_DATE(incident_date, '%m/%d/%Y'),
            '%Y-%m-%d');

SELECT 
    COUNT(*) AS count, YEAR(incident_date) AS Year
FROM
    data
GROUP BY Year
ORDER BY Year;

-- Theme park with the most incidents
SELECT 
    COUNT(*) AS count, Theme_Park
FROM
    data
GROUP BY Theme_Park
ORDER BY count DESC;

-- Ride at Animal Kingdom with the most incidents
SELECT 
    COUNT(*) AS count, Ride_name
FROM
    data
WHERE
    Theme_Park = 'Animal Kingdom'
GROUP BY Ride_name
ORDER BY count DESC;