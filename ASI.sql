create table asi(
nic_classification integer,
year text,
state text,
sector text,
indicator text,
nic_code text,
nic_description text,
nic_type text,
value bigint,
unit text
);

-- checking the records from the dataset

select * from asi
limit 10;

select distinct nic_classification from asi;

select distinct state from asi;

select count(*) as total_rows from asi
where state = 'Daman & Diu';

SELECT DISTINCT year from asi ORDER BY year;

-- checing the nic types
SELECT nic_type,
COUNT(*)AS records
FROM asi
GROUP BY nic_type
ORDER BY nic_type;

-- checking the 'ALL' records
SELECT
COUNT(*) AS all_records
FROM asi
WHERE nic_code = '99999';

-- Comparing 2-digit, 3-digit and "All" factory totals

SELECT
    a.year,
    a.state,
    SUM(CASE WHEN a.nic_type = '2-digit' THEN a.value ELSE 0 END) AS factories_2_digit,
    SUM(CASE WHEN a.nic_type = '3-digit' THEN a.value ELSE 0 END) AS factories_3_digit,
    MAX(CASE WHEN a.nic_code = '99999' THEN a.value END) AS factories_all
FROM asi a
GROUP BY
    a.year,
    a.state
ORDER BY
    a.year,
    a.state;

-- total number of factories

select sum(value) as no_of_factoris from asi;  -- incluing the aggregate

select sum(value) as no_of_factories from asi where nic_code <> '99999'; -- without aggregate



/*  DATA COVERAGE :
1992-93 to 2023-24
States/UTs: As provided by MoSPI
Sector: Combined
Indicator: Number of Factories

NIC structure:
The dataset contains both 2-digit and 3-digit NIC classification levels.
2-digit represents a broader industry category, while 3-digit provides
a more detailed breakdown.

Therefore, 2-digit and 3-digit records should NOT be combined in the
same aggregation, as they represent different levels of the NIC hierarchy.

The dataset also contains:
- NIC code 99999 = "All" → aggregate/total value
- NIC code 99998 = "Other" → a separate category provided by the source

For total factory-count analysis, the 99999 ("All") record is used
instead of summing individual NIC categories, to avoid double-counting.

For industry-level analysis, a single NIC level (2-digit or 3-digit)
should be selected depending on the question.

Note:
1993-94 is not present because the source does not provide data for
that year. Missing state/year combinations should not automatically
be treated as zero.*/




/* FACTORY OVERVIEW
focus - total number of factories an overall trends.
counting rule: use NIC code = 99999("ALL") as this is the official aggregate factory count. 
using only ONE NIC level to avoid duplication.*/



--Q1 what is the total number of factories in each year?

select year,
SUM(value) as total_factories
from asi
where nic_code = '99999' and nic_type = '2-digit'
group by year
order by year;

-- Insight:
-- The total number of factories increased from 119,494 in 1992-93
-- to 257,391 in 2023-24, showing a substantial increase over the period.

--Q2 which year had the highest total number of factories?

select year,
sum(value) as total_factories
from asi
where nic_code = '99999' and nic_type = '2-digit'
group by year
order by total_factories desc limit 1;

-- Insight:
-- 2023-24 recorded the highest total number of factories, with 257,391 factories.

--Q3 which year had the lowest total number of factories?

select year,
sum(value) as total_factories
from asi
where nic_code = '99999' and nic_type = '2-digit'
group by year
order by total_factories  limit 1;

-- Insight:
-- 1992-93 recorded the lowest total number of factories,with 119,494 factories.


/* STATE WISE FACTORY DISTRIBUTION 
focus: comparing factory counts across states/UTs.
counting rule: use NIC code = 99999("ALL") to obtain total no of factories in each state.
do not sum individual NIC categories.*/

-- Q4 how many factories does each state/UT have in 2023-24?

select state,
sum(value) as total_factories
from asi
where nic_code = '99999' and nic_type = '2-digit' and year = '2023-24'
group by state
order by total_factories DESC;

-- Insight:
-- Factory presence varies considerably across states/UTs in 2023-24.
-- Tamil Nadu has the highest number of factories, while Lakshadweep
-- has the lowest among the states/UTs with available data.

-- Q5 which are the top 10 states/UTs by the number of factories in 2023-24?

select state,
sum(value) as total_factories
from asi
where nic_code = '99999' and nic_type = '2-digit' and year = '2023-24'
group by state
order by total_factories DESC limit 10;

-- Insight:
-- Tamil Nadu leads the top 10 states/UTs with 40,121 factories,
-- followed by Gujarat with 33,311 and Maharashtra with 26,539.
-- The top 10 states show a strong concentration of factories
-- in a few major industrial states.

-- Q6 which states/UTs have the lowest number of factories in 2023-24?


select state,
sum(value) as total_factories
from asi
where nic_code = '99999' and nic_type = '2-digit' and year = '2023-24'
group by state
order by total_factories limit 10;

-- Insight:
-- Lakshadweep has the lowest reported factory count with 4 factories,
-- followed by Andaman & Nicobar Islands with 13 and Ladakh with 29.
-- These figures reflect the states/UTs with the lowest reported
-- factory presence in 2023-24.


/* INDUSTRY ANALYSIS
focus: understanding which industries have the largest factory presence.
counting rule: use NIC-2-digit records for broad industry comparison. 
exclude NIC code 99999("ALL") because it is aggregate. do not combine 2-digit and 3-digit records. */

--Q7 which 10 industries have the highest number of factories in 2023-24?

select nic_code,
nic_description,
sum(value) as total_factories
from asi
where year = '2023-24' and nic_type = '2-digit' and nic_code<> '99999'
group by nic_code, nic_description
order by total_factories desc
limit 10;

-- Insight:
-- Manufacture of Food Products had the highest number of factories
-- in 2023-24 with 41,572 factories, followed by Other Non-metallic
-- Mineral Products with 29,840 and Textiles with 18,052.

--Q8 how are factories distributed across different industries in 2023-24?

select nic_code,
nic_description,
sum(value) as total_factories,
round(sum(value)*100 /
      sum(sum(value))OVER(),2) as factory_share_percent
from asi
where year = '2023-24' and nic_type = '2-digit' and nic_code <> '99999'
group by nic_code,
nic_description
order by total_factories desc;


-- Insight:
-- Factory distribution is concentrated across several major industries.
-- Food Products has the largest share at approximately 16.15%,
-- followed by Other Non-metallic Mineral Products at 11.59%
-- and Textiles at 7.01%.

--Q9 which industries has the highest number of factories in each state in 2023-24?

WITH industry_rank AS (
SELECT
state,
nic_code,
nic_description,
SUM(value) AS total_factories,
RANK() OVER (
PARTITION BY state
ORDER BY SUM(value) DESC) AS industry_rank
FROM asi
WHERE year = '2023-24'AND nic_type = '2-digit'AND nic_code <> '99999'
GROUP BY
state, nic_code, nic_description
)

SELECT
state,
nic_code,
nic_description,
total_factories
FROM industry_rank
WHERE industry_rank = 1
ORDER BY total_factories DESC;

-- Insight:
-- The leading industry varies across states/UTs. manufacture of textiles is leading industry in tamil nadu
-- Manufacture of Food Products is the leading industry in many states,
-- while Other Non-metallic Mineral Products is also a major leading
-- industry across several states/UTs.

/* GROWTH ANALYSIS
focus: measuring changes in factory numbers over-time.*/

--Q10 which states experienced the largest increase in total factories from 2008-09 to 2023-24?

SELECT
    state,

    SUM(CASE
        WHEN year = '2008-09' THEN value
        ELSE 0
    END) AS factories_2008_09,

    SUM(CASE
        WHEN year = '2023-24' THEN value
        ELSE 0
    END) AS factories_2023_24,

    SUM(CASE
        WHEN year = '2023-24' THEN value
        ELSE 0
    END)
    -
    SUM(CASE
        WHEN year = '2008-09' THEN value
        ELSE 0
    END) AS increase_in_factories

FROM asi
WHERE nic_code = '99999'
  AND nic_type = '2-digit'
  AND year IN ('2008-09', '2023-24')

GROUP BY state

ORDER BY increase_in_factories DESC;

-- Insight:
-- Gujarat experienced the largest increase in total factories,
-- rising by 18,448 between 2008-09 and 2023-24.
-- Tamil Nadu and Uttar Pradesh recorded the next largest increases,
-- with 13,999 and 11,206 additional factories respectively.

--Q11 which states experienced a decline in total factories between 2008-09 and 2023-24?


SELECT
    state,

    SUM(CASE
        WHEN year = '2008-09' THEN value
    END) AS factories_2008_09,

    SUM(CASE
        WHEN year = '2023-24' THEN value
    END) AS factories_2023_24,

    SUM(CASE
        WHEN year = '2023-24' THEN value
    END)
    -
    SUM(CASE
        WHEN year = '2008-09' THEN value
    END) AS change_in_factories

FROM asi

WHERE nic_code = '99999'
  AND nic_type = '2-digit'
  AND year IN ('2008-09', '2023-24')

GROUP BY state

HAVING COUNT(DISTINCT year) = 2
   AND
   SUM(CASE
       WHEN year = '2023-24' THEN value
   END)
   -
   SUM(CASE
       WHEN year = '2008-09' THEN value
   END) < 0

ORDER BY change_in_factories ASC;

-- Insight:
-- Only three states/UTs show a decline in total factory count
-- between 2008-09 and 2023-24: Andhra Pradesh (-892),
-- Delhi (-253), and Chandigarh (-54).
-- Only states/UTs with data available in both years are compared.