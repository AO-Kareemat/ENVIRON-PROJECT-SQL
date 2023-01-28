-- Create a view as temporary table 

CREATE VIEW forestation
AS
(SELECT forest_area.country_code, 
       forest_area.year, 
       forest_area.forest_area_sqkm, 
       land_area.country_name,
       land_area.total_area_sq_mi,
       regions.region,
       regions.income_group,
       land_area.total_area_sq_mi*2.59 total_area_sqkm,
 forest_area.forest_area_sqkm/(land_area.total_area_sq_mi)*100
FROM forest_area 
JOIN land_area 
ON land_area.country_code = forest_area.country_code 
AND land_area.year = forest_area.year
JOIN regions 
ON forest_area.country_code = regions.country_code);

-- total forest area (in sq km) of the ‘world’ in 1990? 
SELECT forest_area_sqkm, Year
FROM forestation
WHERE country_name = 'World' 
AND year = 1990;

-- the total forest area (in sq km) of the ‘world’ in 2016? 
SELECT forest_area_sqkm, Year
FROM forestation
WHERE country_name = 'World' 
AND year = 2016;

-- change (in sq km) in the forest area of the ‘world’ from 1990 to 2016?

SELECT (SELECT forest_area_sqkm
FROM forestation
WHERE country_name = 'World' 
AND year = 1990)
-
(SELECT forest_area_sqkm
FROM forestation
WHERE country_name = 'World' 
AND year = 2016) 
AS Change_in_forest_area ;

-- the percent change in forest area of the world between 1990 and 2016?
--  not sure of answer

WITH forest_area_2016
AS 
(SELECT forest_area_sqkm AS fa_2016, 
 YEAR
FROM forestation
WHERE country_name = 'World' 
AND year = 2016),

forest_area_1990
AS
(SELECT forest_area_sqkm AS fa_1990, 
 YEAR
FROM forestation
WHERE country_name = 'World' 
AND year = 1990),

change
AS
(SELECT fa_2016, fa_1990, fa_2016 - fa_1990 change_in_fa, 
(fa_2016 - fa_1990)/fa_1990 * 100 AS percentage_change
FROM forest_area_2016, forest_area_1990)
        
SELECT fa_2016, fa_1990, change_in_fa,
ROUND (percentage_change :: NUMERIC, 2) percentage_change
FROM change
