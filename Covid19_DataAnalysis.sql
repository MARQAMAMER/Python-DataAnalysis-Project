

select * 
from project_portfolio..CovidVaccinations$
order by 3,4


select * 
from project_portfolio..CovidDeaths$
order by 3,4

select * 
from project_portfolio..CovidDeaths$
where continent is not null
order by 3,4

select Location, date, total_cases,new_cases, total_deaths, population
from project_portfolio..CovidDeaths$
where continent is not null
order by 1,2


select Location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
from project_portfolio..CovidDeaths$
where continent is not null
order by 1,2


select Location, date, population, total_cases, total_deaths,  (total_cases/population)*100 as PercentPopulationInfection
from project_portfolio..CovidDeaths$
where location like '%states%'
order by 1,2


select location, population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentPopulationInfection
from project_portfolio..CovidDeaths$
--where location like '%states%'
where continent is not null
Group by location, population
order by PercentPopulationInfection desc

select location, population,date, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentPopulationInfection
from project_portfolio..CovidDeaths$
--where location like '%states%'
Group by location, population,date
order by PercentPopulationInfection desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
from project_portfolio..CovidDeaths$
--where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
from project_portfolio..CovidDeaths$
--where location like '%states%'
where continent is null
and location not in ('World','European Union','International')
Group by location
order by TotalDeathCount desc

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from project_portfolio..CovidDeaths$
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

select date, sum(new_cases)--, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
from project_portfolio..CovidDeaths$
where continent is not null
group by date
order by 1,2

select date, sum(new_cases) as Total_Cases, sum(cast (new_deaths as int)) as Total_Deaths,sum(cast (new_deaths as int))/sum(new_cases)*100 as DeathPercentage--, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
from project_portfolio..CovidDeaths$
where continent is not null
group by date
order by 1,2

select sum(new_cases) as Total_Cases, sum(cast (new_deaths as int)) as Total_Deaths,sum(cast (new_deaths as int))/sum(new_cases)*100 as DeathPercentage--, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
from project_portfolio..CovidDeaths$
where continent is not null
--group by date
order by 1,2


select *
from project_portfolio..CovidDeaths$ dea
join project_portfolio..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
from project_portfolio..CovidDeaths$ dea
join project_portfolio..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from project_portfolio..CovidDeaths$ dea
join project_portfolio..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


with popvsvac (continent,location, date, population, New_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from project_portfolio..CovidDeaths$ dea
join project_portfolio..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
select *,(RollingPeopleVaccinated/Population)*100
from popvsvac

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations  numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from project_portfolio..CovidDeaths$ dea
join project_portfolio..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from project_portfolio..CovidDeaths$ dea
join project_portfolio..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 


