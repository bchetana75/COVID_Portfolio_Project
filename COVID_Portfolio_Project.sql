--SELECT ALL FROM CovidDeaths Table
SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

--SELECT ALL FROM CovidVaccinations
SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4


--COVIDDEATHS TABLE

--Filtering Necessary columns 
SELECT continent,location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY  2,3



--Calculate DeathPercentage in INDIA
--(Total Deaths/Total Cases)*100
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%India%' 
AND continent IS NOT NULL
ORDER BY  2,3


--Calculate PercentPopulationInfected in INDIA
--What percentage of population has been infected by COVID
SELECT location,date,total_cases,population,(total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%India%' 
AND continent IS NOT NULL
ORDER BY  2,


--Countries with Highest Infection Rate( compared to their Population)
SELECT location,MAX(total_cases) AS HighestCaseCount,population,MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC


--Countries with Highest Death Count
--CAST to chag=nge the datatype
SELECT location,MAX(CAST(total_deaths as INT)) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount DESC


-- GLOBAL NUMBERS
SELECT date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


-- GLOBAL NUMBERS OVERALL IRRESPECTIVE OF DATE & LOCATION
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2



--COVIDVACCINATIONS TABLE

SELECT*
FROM PortfolioProject..CovidVaccinations


--Join Deaths and Vaccination Table on Location and dates(CovidDeaths & CovidVaccinations)
SELECT *
FROM PortfolioProject..CovidDeaths as d
JOIN PortfolioProject..CovidVaccinations as v
     ON d.location = v.location
	 AND d.date =v.date


--Total population vs Vaccination
SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations, SUM(CAST(v.new_vaccinations as int)) OVER (PARTITION BY d.location ORDER BY d.location,d.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths as d
JOIN PortfolioProject..CovidVaccinations as v
     ON d.location = v.location
	 AND d.date =v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3


--CTE
WITH PopVsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations, SUM(CAST(v.new_vaccinations as int)) OVER (PARTITION BY d.location ORDER BY d.location,d.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths as d
JOIN PortfolioProject..CovidVaccinations as v
     ON d.location = v.location
	 AND d.date =v.date
WHERE d.continent IS NOT NULL
)


SELECT *, (RollingPeopleVaccinated/population)*100 as PercentRollingVaccination
FROM PopVsVac



