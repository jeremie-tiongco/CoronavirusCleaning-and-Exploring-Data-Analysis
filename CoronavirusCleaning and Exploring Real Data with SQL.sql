USE VIRUS_DB;

SELECT * FROM virus_db.corona_data;
-- Data Cleaning
-- Q1. If NULL values are present, update them with zeros for all columns.
SELECT * FROM corona_data
WHERE Province IS NULL oR
`Country/Region` IS NULL OR
Latitude IS NULL OR
Longitude IS NULL OR
`DATE` IS NULL or
Confirmed IS NULL OR
Deaths IS NULL OR 
Recovered IS NULL;

/*UPDATE corona_data
SET Confirmed=0
WHERE Confirmed="";*/

-- Q2. check total number of rows
SELECT COUNT(*) FROM corona_data;

SELECT COUNT(DISTINCT Province) FROM corona_data;

-- Q3. Check what is start_data and end_date
UPDATE corona_data
SET `Date` = STR_TO_DATE(`Date`, '%Y-%m-%d');

ALTER TABLE corona_data
MODIFY COLUMN `Date` DATE ;

SELECT MIN(`Date`) AS start_date, MAX(`Date`) AS end_date FROM corona_data;

-- Q4. Number of month present in dataset
SELECT COUNT(DISTINCT SUBSTR(`Date`,1,7)) AS `MONTH` FROM corona_data;

-- Q5. find monthly average for confirmed, deaths, recovered
SELECT DISTINCT SUBSTR(`Date`,1,7) AS `MONTH`, 
ROUND(AVG(Confirmed),2) AS AvgConfirmed,
AVG(Confirmed) AS AvgConfirmed,
ROUND(AVG(Deaths),2) AS Avg_Deaths, ROUND(AVG(Recovered),2) AS Avg_Recovered
FROM corona_data
 GROUP BY `MONTH`
 ORDER BY `MONTH` DESC;
 
 -- Q6. Find minimum values for confirmed, deaths, recovered per year
 SELECT DISTINCT YEAR(`Date`) AS `YEAR`,
 MIN(Confirmed) AS MinConfirmed,
 MIN(Deaths) AS Min_Deaths, MIN(Recovered) AS Min_Recovered
  FROM corona_data
  WHERE Confirmed !=0 AND Deaths !=0 AND Recovered !=0
  GROUP BY `YEAR`
  ORDER BY `YEAR` DESC;
  
 -- Q6. Find minimum values for confirmed, deaths, recovered per year
 SELECT DISTINCT SUBSTR(`Date`,1,7) AS `MONTH`, 
SUM(Confirmed) AS TotalConfirmed,
SUM(Deaths) AS TotalDeaths, SUM(Recovered) AS TotalRecovered
FROM corona_data
GROUP BY `MONTH`
ORDER BY `MONTH` DESC;
 
 -- Q7. Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR(`Date`) AS `YEAR`,
       MAX(Confirmed) AS MaxConfirmed,
       MAX(Deaths)    AS Max_Deaths, 
       MAX(Recovered) AS Max_Recovered
FROM corona_data
GROUP BY `YEAR`
ORDER BY `YEAR` DESC;
 
 -- Q8. The total number of case of confirmed, deaths, recovered each month
 SELECT SUBSTR(`Date`,1,7) AS `MONTH`, 
       SUM(Confirmed) AS TotalConfirmed,
       SUM(Deaths)    AS TotalDeaths, 
       SUM(Recovered) AS TotalRecovered
FROM corona_data
GROUP BY `MONTH`
ORDER BY `MONTH` DESC;

 -- Q9. Find Country having highest number of the Confirmed case
 -- SOLUTION 1
 SELECT `Country/Region` AS Country, SUM(Confirmed) AS TotalConfirmed 
 FROM corona_data
 GROUP BY Country
 ORDER BY TotalConfirmed DESC
 LIMIT 1;
 
  -- SOLUTION 2
  WITH TotalConfirmedCount AS(
  SELECT `Country/Region` AS Country, 
  SUM(Confirmed) AS TotalConfirmed
  FROM corona_data
  GROUP BY Country
  ), 
TotalConfirmedRank AS (
    SELECT Country, TotalConfirmed,
           RANK() OVER (ORDER BY TotalConfirmed DESC) AS ranking
    FROM TotalConfirmedCount
)
SELECT Country, TotalConfirmed
FROM TotalConfirmedRank
WHERE ranking = 1;
 -- Q10. Find Country having lowest number of the death case
 SELECT `Country/Region` AS Country, 
       SUM(Deaths) AS TotalDeaths
FROM corona_data
GROUP BY Country
ORDER BY TotalDeaths ASC
LIMIT 1;

 -- Q11. Find most frequent value for confirmed, deaths, recovered each month
SELECT SUBSTR(`Date`,1,7) AS `MONTH`, 
       Confirmed,
       COUNT(*) AS Frequency
FROM corona_data
GROUP BY `MONTH`, Confirmed
ORDER BY `MONTH` DESC, Frequency DESC;

