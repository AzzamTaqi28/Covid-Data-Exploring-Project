Select * from CovidVaccination
where continent <> ''
order by 3,4

--select * from CovidVaccination
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent <> ''
order by 1,2

-- Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases) * 100 as DeathPercentage
from CovidDeaths
where location like '%Indonesia%'
and continent <> ''
order by 1,2

-- Total cases vs Population

Select Location, date, total_cases, population,(total_deaths/population) * 100 as DeathPercentage
from CovidDeaths
where location like '%Indonesia%'
and continent <> ''
order by 1,2

-- Highest Infection Country

Select Location, population, max(total_cases) As HighestInfectionCount, max(total_cases/population) * 100 as
PercentagePopulationInfection
from CovidDeaths
where continent <> ''
Group By Location, Population
Order By PercentagePopulationInfection Desc

-- continent with highest deathcount per opulation

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent <> ''
GROUP BY continent
order by TotalDeathCount desc

-- Global 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast (new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent <> ''
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

DROP Table #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location, dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent <> ''
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location, dea.Location, cast(dea.Date as datetime)) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/new_vaccinationspopulation)*100
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ''



