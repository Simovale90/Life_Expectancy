/* Topics covered: GROUP BY, ORDER BY, HAVING, CASE-WHEN

First let's load csv file "life-expectancy.csv" into BigQuery as a table named LifeExpectancy and take a look at our dataset. */

SELECT
  column_name,
  data_type
FROM
  `sql-my-data.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name = 'LifeExpectancy'

/* Now let's try to answer the following questions.
1) What is the average life expectancy at birth in Europe (hint: the numeric variable related to the MetricObserved dimension is called Numeric)? */

SELECT ROUND(AVG(Numeric),2) AVG_ab_Europe FROM `sql-my-data.LifeExpectancy` 
WHERE RegionDisplay = 'Europe'and MetricObserved = 'Life expectancy at birth (years)'

/* Which region has the lowest life expectancy at birth? */

SELECT RegionDisplay Region, ROUND(AVG(Numeric),2) AVG_life_exp_at_birth 
FROM `sql-my-data.LifeExpectancy`
WHERE MetricObserved = 'Life expectancy at birth (years)'
GROUP BY Region
ORDER BY AVG_life_exp_at_birth LIMIT 1

/* 2) Which region has the highest life expectancy at birth? */

SELECT RegionDisplay Region, ROUND(AVG(Numeric),2) AVG_life_exp_at_birth 
FROM `sql-my-data.LifeExpectancy`
WHERE MetricObserved = 'Life expectancy at birth (years)'
GROUP BY Region
ORDER BY AVG_life_exp_at_birth DESC LIMIT 1

/* 3) Which country has the highest life expectancy after 60? */

SELECT CountryDisplay Country, ROUND(AVG(Numeric),2) AVG_life_exp_at_60
FROM `sql-my-data.LifeExpectancy`
WHERE MetricObserved = 'Life expectancy at age 60 (years)'
GROUP BY Country
ORDER BY AVG_life_exp_at_60 DESC LIMIT 1

/* 4) Using a GROUP BY and a CASE-WHEN, create a pivot table that shows the average life expectancy for all three types of MetricObserved (in three separate columns) by each region (each in a separate row). */

SELECT RegionDisplay Region, 
ROUND(AVG(CASE WHEN MetricObserved = 'Life expectancy at birth (years)' THEN Numeric END),2) LEAB,
ROUND(AVG(CASE WHEN MetricObserved = 'Healthy life expectancy (HALE) at birth (years)' THEN Numeric END),2) HALE,
ROUND(AVG(CASE WHEN MetricObserved = 'Life expectancy at age 60 (years)' THEN Numeric END),2) LE60,
FROM `sql-my-data.LifeExpectancy`
GROUP BY Region
ORDER BY Region 

/* 5) Check out which are the top 10 countries that consume more alcohol (by adding the average consumption of beer, wine and spirits respectively). */

SELECT CountryDisplay AS Country,ROUND(AVG(Numeric),2) AS Life_Exp_at_birth,
AVG(beer_servings) AS Beer,
AVG(wine_servings) AS Wine,
AVG(spirit_servings) AS Spirit,
(AVG(beer_servings) + AVG(wine_servings) + AVG(spirit_servings)) AS Tot_alcohol_consumption
FROM `sql-my-data.LifeExpectancy`
WHERE MetricObserved = 'Life expectancy at birth (years)'
GROUP BY Country
ORDER BY Tot_alcohol_consumption DESC LIMIT 10

/* 6) In general, women live longer than men, so let's create a new variable to test the difference between women's and men's life expectancy at birth. Which country has the highest gap (in terms of
years)? There are countries where men do they live longer than women? 

(To immediately see if there are countries where the gap is in favor of men, just remove DESC from ORDER BY, in order to display the lowest values) */

SELECT CountryDisplay AS Country,ROUND(AVG(Numeric),2) AS Life_Exp_at_birth,
ROUND(AVG(CASE WHEN SexDisplay = 'Female' THEN Numeric END) - ROUND(AVG(CASE WHEN SexDisplay = 'Male' THEN Numeric END)),2) AVG_LE_gender_gap,
FROM `sql-my-data.LifeExpectancy`
WHERE MetricObserved = 'Life expectancy at birth (years)'
GROUP BY Country
ORDER BY AVG_LE_gender_gap DESC LIMIT 1

/* 7) What are the 10 countries where life expectancy at birth is highest for both sexes? */

SELECT CountryDisplay AS Country, ROUND(AVG(Numeric),2) AS Age FROM `sql-my-data.LifeExpectancy`
WHERE MetricObserved = 'Life expectancy at birth (years)' AND SexDisplay = 'Both sexes'
GROUP BY Country
ORDER BY Age DESC LIMIT 10

/* 8) What is life expectancy at age 60 by region and gender? */ 

SELECT RegionDisplay AS Region, SexDisplay AS Sex, ROUND(AVG(Numeric),2) AS Life_Exp_at_60 FROM `sql-my-data.LifeExpectancy`
WHERE MetricObserved = 'Life expectancy at age 60 (years)' AND (SexDisplay = 'Female' OR SexDisplay = 'Male')
GROUP BY Region,Sex 
ORDER BY Region




