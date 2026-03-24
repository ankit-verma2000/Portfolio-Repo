SELECT * FROM `my-project-485806.sql_practice.dirty_shipments` LIMIT 1000;


-- Data cleaning: 
-- 1. Remove leading/trailing spaces, standardise text casting
SELECT shipment_id,
INITCAP(TRIM(origin_warehouse)) AS origin_warehouse,
INITCAP(TRIM(destination_city)) AS dstination_city,
UPPER(TRIM(destination_state))  AS dstination_state,
INITCAP(TRIM(carrier))  AS carrier
FROM `my-project-485806.sql_practice.dirty_shipments`;

-- 2. Replace the strig "NULL" and hadle True nulls 
SELECT shipment_id,
CASE
  WHEN damage_reported = 'NULL' THEN NULL
  ELSE INITCAP(TRIM(damage_reported)) 
END AS damage_reported,
COALESCE(INITCAP(TRIM(destination_city)),"Unknown") as destination_city,
coalesce(delivery_date, 'Not Yet Delivered') as delivery_date
FROM `my-project-485806.sql_practice.dirty_shipments`;

-- 3. Remove the exact duplicate rows;
WITH ranked as (
SELECT *, ROW_NUMBER() OVER(PARTITION BY origin_warehouse
,destination_city, carrier, ship_date, cast(weight_kg AS STRING), cast(freight_cost AS STRING) order by shipment_id
) as rn
FROM `my-project-485806.sql_practice.dirty_shipments`)
select * except(rn)
from ranked
where rn = 1;


-- Fix the negative and suspiious numeric values:

SELECT shipment_id,
CASE WHEN weight_kg <0 THEN ABS(weight_kg)
  when weight_kg = 0 then NULL
  else weight_kg
END AS weight_kg
FROM `my-project-485806.sql_practice.dirty_shipments`;

-- Validate Date logic (Delivery after ship date)
SELECT shipment_id, ship_date, delivery_date,
date_diff(safe.parse_date('%Y-%m-%d',delivery_date) ,
safe.parse_date('%Y-%m-%d',ship_date), 
day) as transit_days,
CASE
  WHEN safe.parse_date('%Y-%m-%d',delivery_date) < safe.parse_date('%Y-%m-%d',ship_date) THEN "INVALID"
  WHEN safe.parse_date('%Y-%m-%d',delivery_date) = safe.parse_date('%Y-%m-%d',ship_date) THEN "SAME DAY DELIVERY"
  ELSE 'VALID'
END AS data_quality_flag
FROM `my-project-485806.sql_practice.dirty_shipments`;

-- Detect & cap outliers using percentile (IQR method)

with stats as (
  select 
  approx_quantiles(freight_cost, 100)[offset(25)] as q1,
  approx_quantiles(freight_cost, 100)[offset(75)] as q3
  FROM `my-project-485806.sql_practice.dirty_shipments`
  where freight_cost > 0
),
bounds as (
  select q1 - 1.5 * (q3 - q1) as lower_bound,
  q3 + 1.5 * (q3 - q1) as upper_bound,
  from stats

)
select
shipment_id,freight_cost as original_cost,
case
  when freight_cost > (select upper_bound from bounds)
  then (select upper_bound from bounds)
  when freight_cost < (select lower_bound from bounds)
  then (select lower_bound from bounds)
  else freight_cost
end as cleaned_cost,
case
  when freight_cost > (select upper_bound from bounds)
  OR
  freight_cost < (select lower_bound from bounds)
  then TRUE
  else FALSE
end as was_outlier
FROM `my-project-485806.sql_practice.dirty_shipments`;

