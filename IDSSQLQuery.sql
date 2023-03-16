SELECT DISTINCT Indicator_Name, Indicator_Code
FROM Data
ORDER BY Indicator_Name


-- UNPIVOT years and CREATE a VIEW
CREATE VIEW IDSData AS
SELECT
	Country_Name,
	Country_Code,
	Indicator_Name,
	Indicator_Code,
	Debt_amount,
	Year
FROM Data
UNPIVOT (
	Debt_amount FOR Year IN 
		([1974], [1975], [1976], [1977], [1978], [1979], [1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989], [1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999], [2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], [2010], [2011], [2012], [2013], [2014], [2015], [2016] 
)
) AS Unpvt

-- show top 15 lines of IDSData
SELECT TOP 15 *
FROM IDSData

-- What is the total amount of money that countries owe to the World Bank by years, yoy growth rates?
-- Indicator - External debt stocks, total (DOD, current US$), Indicator Code DT.DOD.DECT.CD
SELECT	
	Year,
	ROUND(SUM(debt_amount)/1000000000, 2) AS total_debt_in_billions,
	ROUND(ROUND(SUM(debt_amount)/1000000000, 2) * 100/ LAG(SUM(debt_amount)/1000000000) OVER( ORDER BY Year ASC) - 100, 2) AS yoy_debt_growth,
	CASE
		WHEN ROUND(SUM(debt_amount)/1000000000, 2) * 100/ LAG(SUM(debt_amount)/1000000000) OVER( ORDER BY Year ASC) - 100 <= 0 THEN 'No growth'
		WHEN ROUND(SUM(debt_amount)/1000000000, 2) * 100/ LAG(SUM(debt_amount)/1000000000) OVER( ORDER BY Year ASC) - 100 <= 5 THEN 'Low'
		WHEN ROUND(SUM(debt_amount)/1000000000, 2) * 100/ LAG(SUM(debt_amount)/1000000000) OVER( ORDER BY Year ASC) - 100 <= 10 THEN 'Medium'
		WHEN ROUND(SUM(debt_amount)/1000000000, 2) * 100/ LAG(SUM(debt_amount)/1000000000) OVER( ORDER BY Year ASC) - 100 > 10 THEN 'High'
		END AS Growth_level
FROM IDSData D
JOIN IDSCountry C ON C.Country_Code = D.Country_Code
WHERE Indicator_Code= 'DT.DOD.DECT.CD'  AND C.Region IS NOT NULL
GROUP BY Year
ORDER BY Year

-- 2. Which country has the highest debt, and how much is that, ratio of total?
SELECT
	TOP 10 ROUND(D.Debt_amount/1000000000, 2) AS Debt_2016_in_billions,
	D.Country_Name,
	CAST(D.Debt_amount *100 / (SUM(D.debt_amount) OVER()) AS DECIMAL(4,2)) AS ratio_of_total
FROM IDSData D
JOIN IDSCountry C ON C.Country_Code = D.Country_Code
WHERE Indicator_Code= 'DT.DOD.DECT.CD' AND YEAR = 2016 AND C.Region IS NOT NULL
ORDER BY Debt_amount DESC

--3. What is the mean debt owed by countries for different debt indicators?
-- Indicator series Topic - Economic Policy & Debt: External debt: Debt outstanding

SELECT
	D.Indicator_Name,
	ROUND(AVG(D.Debt_amount)/1000000000,2) AS Average_debt_in_billions
FROM IDSData D
JOIN Series S ON D.Indicator_Code = S.[Series Code]
JOIN IDSCountry C ON C.Country_Code = D.Country_Code
WHERE S.Topic = 'Economic Policy & Debt: External debt: Debt outstanding' AND C.Region IS NOT NULL
GROUP BY D.Indicator_Name
ORDER BY Average_debt_in_billions DESC

-- 4. Which region has the highest debt, and how much is that?
WITH Region_debt AS(
SELECT
	C.Region,
	ROUND(SUM(D.Debt_amount/1000000000), 2) AS total_debt
FROM IDSData D
JOIN IDSCountry C ON C.Country_Code = D.Country_Code
WHERE Indicator_Code= 'DT.DOD.DECT.CD' AND YEAR = 2016 AND C.Region IS NOT NULL
GROUP BY C.Region
)
SELECT 
	*, 
	CAST(total_debt * 100 / (sum(total_debt) OVER()) AS DECIMAL (4,2)) AS ratio_of_total
FROM Region_debt

-- 5. Total debt by income group
WITH Inc_group_debt AS(
SELECT
	C.Income_Group,
	COUNT(DISTINCT C.Country_Code) AS country_numbers,
	ROUND(SUM(D.Debt_amount/1000000000), 2) AS Total_debt
FROM IDSData D
JOIN IDSCountry C ON C.Country_Code = D.Country_Code
WHERE Indicator_Code= 'DT.DOD.DECT.CD' AND YEAR = 2016 AND C.Region IS NOT NULL
GROUP BY C.Income_Group
)
SELECT 
	Income_Group,
	Total_debt,
	CAST(Total_debt * 100 / (sum(Total_debt) OVER()) AS DECIMAL (4,2)) AS ratio_of_total,
	Country_numbers,
	ROUND(Total_debt / country_numbers, 2) AS ave_debt_per_country
FROM Inc_Group_debt
ORDER BY total_debt DESC


