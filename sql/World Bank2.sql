use [World Bank]
select top 1 * from world_bank_raw

-------- add year 
alter table world_bank_raw
add year int;

update world_bank_raw
set year = Year(cast(date as Date));

-------- GDB growth 
SELECT 
    a.country,
    a.year,
    a.GDP_current_US,
    ((a.GDP_current_US - b.GDP_current_US) / b.GDP_current_US) * 100 AS gdp_growth
INTO gdp_growth_table2
FROM world_bank_raw a
JOIN world_bank_raw b
  ON a.country = b.country AND a.year = b.year + 1


------ top 10 gdb 
select top 10 country,
year,
GDP_current_US
from world_bank_raw
order by GDP_current_US desc;

------- bottom 10 gdb 
select top 10 country,
year,
GDP_current_US
from world_bank_raw
where year = 2020 
order by GDP_current_US asc;

-------- top 10 growth 
select top 10 country,
year,
gdp_growth
from gdp_growth_table
order by gdp_growth desc;

--------- top 10 inflation
select top 10 country,
year,
inflation_annual
from world_bank_raw
order by inflation_annual desc;

------------ top 10 debt
select top 10 
country,
year,
central_goverment_debt
from world_bank_raw
order by central_goverment_debt desc;

--------- rule of law vs growth 
select g.country,g.year, w.rule_of_law_estimate,g.gdp_growth
from gdp_growth_table2 g
join world_bank_raw w on g.country=w.country and g.year=w.year


---------- corruption vs growth 
select g.country,g.year,w.control_of_corruption_estimate,g.gdp_growth
from gdp_growth_table2 g
join world_bank_raw w on g.country=w.country and g.year=w.year


----------- tax vs growth 
select g.country,g.year,w.tax_revenue,g.gdp_growth
from gdp_growth_table g
join world_bank_raw w 
on g.country=w.country and g.year=w.year

--------- military vs growth 
select 
g.country, g.year , w.military_expenditure,g.gdp_growth
from gdp_growth_table g 
join world_bank_raw w 
on g.country=w.country and g.year=w.year

----------- human_capital_vs_gdp
select 
g.country, g.year , w.human_capital_index,g.gdp_growth
from gdp_growth_table g 
join world_bank_raw w 
on g.country=w.country and g.year=w.year
----------- health_vs_life_expectancy

select 
g.country, g.year , w.government_health_expenditure,g.gdp_growth,w.life_expectancy_at_birth
from gdp_growth_table g 
join world_bank_raw w 
on g.country=w.country and g.year=w.year

----------- missing data
select 
count(*) as total_rows,
sum(case when GDP_current_US is null then 1 else 0 end) as gdb_missing,
sum(case when inflation_annual is null then 1 else 0 end) as inflation_missing,
sum(case when central_goverment_debt is null then 1 else 0 end) as debt_missing,
sum(case when tax_revenue is null then 1 else 0 end) as tax_missing,
sum(case when military_expenditure is null then 1 else 0 end) as military_missing,
sum(case when rule_of_law_estimate is null then 1 else 0 end) as rule_of_rule_missing,
sum(case when control_of_corruption_estimate is null then 1 else 0 end) as corruption_missing
from world_bank_raw;
