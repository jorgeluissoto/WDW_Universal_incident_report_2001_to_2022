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
		WHEN age <= 12 THEN 'Child'
        WHEN age >= 13 AND age <= 19 THEN 'Teenager'
        WHEN age >= 20 AND age <= 34 THEN 'Young Adult'
        WHEN age >= 35 AND age <= 59 THEN 'Adult'
        ELSE 'Senior'
	END AS age_group,
    COUNT(age) AS count
FROM data
GROUP BY age_group
ORDER BY count;  

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

-- Incidents by YEAR 
SELECT 
    COUNT(*) AS count, YEAR(incident_date) AS Year
FROM
    data
GROUP BY Year
ORDER BY Year;

-- Incidents by MONTH
SELECT 
    COUNT(*) AS count, MONTH(incident_date) AS Month
FROM
    data
GROUP BY Month
ORDER BY Month;

-- Incidents by Day
SELECT 
    COUNT(*) AS count, DAY(incident_date) AS Day
FROM
    data
GROUP BY Day
ORDER BY Day;

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

-- Medical Indicators
SELECT
	Company,
	COUNT(*) AS count,
	SUM(CASE WHEN description LIKE '%passed away%' OR description LIKE '%died%' 
		THEN 1 ELSE 0 END) GuestPassedAway,
    SUM(CASE WHEN description LIKE '%hospital%' THEN 1 ELSE 0 END) Hospital,
    SUM(CASE WHEN description LIKE '%pre-existing%' OR description LIKE '%pre existing%' 
		THEN 1 ELSE 0 END) PreExisting,
	SUM(CASE WHEN description LIKE '%unconscious%' OR description LIKE '%syncope%' OR 
		description LIKE '%passed out%' OR description LIKE '%fainted%' OR 
		description LIKE '%collapsed%' OR description LIKE '%loss of consciousness%' OR
        description LIKE '%unresponsive%' THEN 1 ELSE 0 END) LoseConsciousness,
	SUM(CASE WHEN description LIKE '%chest pain%' THEN 1 ELSE 0 END) ChestPain,
    SUM(CASE WHEN description LIKE '%seizure%' THEN 1 ELSE 0 END) Seizure,
    SUM( CASE WHEN description LIKE '%fell%' OR description LIKE '%fracture%' OR
		description LIKE '%lacerated%' OR description LIKE '%tear%' OR description LIKE '%tripped%' OR
        description LIKE '%hit%' OR description LIKE '%laceration%' OR description LIKE '%fx%' OR
        description LIKE '%broke%' OR  description LIKE '%struck%' OR description LIKE '%injured%' OR
        description LIKE '%hip%' OR description LIKE '%injury%' THEN 1 ELSE 0 END) PhysicalPain,
	SUM( CASE WHEN description LIKE '%sickness%' OR description LIKE '%motion sickness%' OR
		description LIKE '%dizzy%' OR description LIKE '%ill%' OR description LIKE '%not feeling well%' OR
        description LIKE '%dizziness%' OR description LIKE '%vertigo%' THEN 1 ELSE 0 END) MotionSickness
FROM data
GROUP BY Company;

-- Percentage of Medical Indicators
SELECT
	GuestPassedAway/ count AS GuestPassedAway,
    Hospital/ count AS HospitalPercentage,
    PreExisting/ count AS PreExistingPercentage,
    LoseConsciousness/ count AS LossConsciousnessPercentage,
    ChestPain/ count AS ChestPainPercentage,
    Seizure/ count AS SeizurePercentage,
    PhysicalPain/ count AS PhysicalPainPercentage,
    MotionSickness/ count AS MotionSicknessPercentage
FROM(
	SELECT
		COUNT(*) AS count,
		SUM(CASE WHEN description LIKE '%passed away%' OR description LIKE '%died%' 
		THEN 1 ELSE 0 END) GuestPassedAway,
        SUM(CASE WHEN description LIKE '%hospital%' THEN 1 ELSE 0 END) Hospital,
		SUM(CASE WHEN description LIKE '%pre-existing%' OR description LIKE '%pre existing%' 
		THEN 1 ELSE 0 END) PreExisting,
		SUM(CASE WHEN description LIKE '%unconscious%' OR description LIKE '%syncope%' OR 
		description LIKE '%passed out%' OR description LIKE '%fainted%' OR 
		description LIKE '%collapsed%' OR description LIKE '%loss of consciousness%' OR
        description LIKE '%unresponsive%' THEN 1 ELSE 0 END) LoseConsciousness,
		SUM(CASE WHEN description LIKE '%chest pain%' THEN 1 ELSE 0 END) ChestPain,
		SUM(CASE WHEN description LIKE '%seizure%' THEN 1 ELSE 0 END) Seizure,
		SUM( CASE WHEN description LIKE '%fell%' OR description LIKE '%fracture%' OR
		description LIKE '%lacerated%' OR description LIKE '%tear%' OR description LIKE '%tripped%' OR
        description LIKE '%hit%' OR description LIKE '%laceration%' OR description LIKE '%fx%' OR
        description LIKE '%broke%' OR  description LIKE '%struck%' OR description LIKE '%injured%' OR
        description LIKE '%hip%' OR description LIKE '%injury%' THEN 1 ELSE 0 END) PhysicalPain,
		SUM( CASE WHEN description LIKE '%sickness%' OR description LIKE '%motion sickness%' OR
		description LIKE '%dizzy%' OR description LIKE '%ill%' OR description LIKE '%not feeling well%' OR
        description LIKE '%dizziness%' OR description LIKE '%vertigo%' THEN 1 ELSE 0 END) MotionSickness
	FROM data
) AS subquery;

-- Medical Indicators by Age
SELECT
	age_group,
	GuestPassedAway/ count AS GuestPassedAway,
    Hospital/ count AS HospitalPercentage,
    PreExisting/ count AS PreExistingPercentage,
    LoseConsciousness/ count AS LossConsciousnessPercentage,
    ChestPain/ count AS ChestPainPercentage,
    Seizure/ count AS SeizurePercentage,
    PhysicalPain/ count AS PhysicalPainPercentage,
    MotionSickness/ count AS MotionSicknessPercentage
FROM(
	SELECT
		CASE
			WHEN age <= 12 THEN 'Child'
			WHEN age >= 13 AND age <= 19 THEN 'Teenager'
			WHEN age >= 20 AND age <= 34 THEN 'Young Adult'
			WHEN age >= 35 AND age <= 59 THEN 'Adult'
			ELSE 'Senior'
		END AS age_group,
		COUNT(*) AS count,
		SUM(CASE WHEN description LIKE '%passed away%' OR description LIKE '%died%' 
		THEN 1 ELSE 0 END) GuestPassedAway,
        SUM(CASE WHEN description LIKE '%hospital%' THEN 1 ELSE 0 END) Hospital,
		SUM(CASE WHEN description LIKE '%pre-existing%' OR description LIKE '%pre existing%' 
		THEN 1 ELSE 0 END) PreExisting,
		SUM(CASE WHEN description LIKE '%unconscious%' OR description LIKE '%syncope%' OR 
		description LIKE '%passed out%' OR description LIKE '%fainted%' OR 
		description LIKE '%collapsed%' OR description LIKE '%loss of consciousness%' OR
        description LIKE '%unresponsive%' THEN 1 ELSE 0 END) LoseConsciousness,
		SUM(CASE WHEN description LIKE '%chest pain%' THEN 1 ELSE 0 END) ChestPain,
		SUM(CASE WHEN description LIKE '%seizure%' THEN 1 ELSE 0 END) Seizure,
		SUM( CASE WHEN description LIKE '%fell%' OR description LIKE '%fracture%' OR
		description LIKE '%lacerated%' OR description LIKE '%tear%' OR description LIKE '%tripped%' OR
        description LIKE '%hit%' OR description LIKE '%laceration%' OR description LIKE '%fx%' OR
        description LIKE '%broke%' OR  description LIKE '%struck%' OR description LIKE '%injured%' OR
        description LIKE '%hip%' OR description LIKE '%injury%' THEN 1 ELSE 0 END) PhysicalPain,
		SUM( CASE WHEN description LIKE '%sickness%' OR description LIKE '%motion sickness%' OR
		description LIKE '%dizzy%' OR description LIKE '%ill%' OR description LIKE '%not feeling well%' OR
        description LIKE '%dizziness%' OR description LIKE '%vertigo%' THEN 1 ELSE 0 END) MotionSickness
	FROM data
    GROUP BY age_group
) AS subquery;
	