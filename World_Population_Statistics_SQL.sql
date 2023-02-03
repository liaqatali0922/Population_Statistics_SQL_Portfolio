
	--order of decreasing poulation countrywise

	select country, continent,pop
	from portfolio..population order by pop desc;

	--order of decreasing poulation continentwise

	select continent,sum(pop) as total_population from portfolio..population
	group by continent order by sum(pop) desc;

	--order of decreasing poulation density countrywise

	select country, continent,pop,density_pks
	from portfolio..population order by density_pks desc;

	--Maximum population country in each continent using CTE and Join

	 with maximum_pop(max_pop)
	 as (select max(pop) as max_pop from portfolio..population group by continent)

	 select continent,country,pop as total_population from portfolio..population
	 join maximum_pop
	 on pop=max_pop order by pop desc;
 
	  --growth rate from 2010-2022

	  select country, continent, ((pop-ten_pop)/ten_pop)*100 as percent_increase 
	  from portfolio..population order by ((pop-ten_pop)/ten_pop)*100 desc ;

	  --making temp table for storing percent_increase information

	  create table #temptable_percent_inc(
	  country varchar(100),continent varchar(100),percent_increase float);

	  --inserting data into temp table
   
	   insert into #temptable_percent_inc select country, continent,  ((pop-ten_pop)/ten_pop)*100
	   from portfolio..population;
	   select * from #temptable_percent_inc;

	  --Finding the the rank of countries in population growth continentwise as well as globally 
 
	  select country, continent,percent_increase, 
	  dense_rank() over(order by percent_increase desc) as golobal_rank,
	  dense_rank() over(partition by continent order by percent_increase desc) as rank_in_continentt
	  from #temptable_percent_inc;
 
	 --World population percentage 

	  with world_population(total_population)
	  as (select sum(pop) from portfolio..population)

	  select country, continent, (pop/total_population)*100 as world_pop_percent
	  from world_population,portfolio..population order by pop/total_population desc;
 
