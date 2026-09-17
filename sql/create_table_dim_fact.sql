CREATE DATABASE IF NOT EXISTS rta_datamart
  COMMENT 'Road Traffic Accidents Data Mart - 2020-2024';

USE rta_datamart;
CREATE TABLE IF NOT EXISTS src_collision (
    collision_index STRING,
    collision_year INT,
    date_val STRING,
    local_authority_ons_district STRING,
    first_road_class INT,
    second_road_class INT,
    weather_conditions INT,
    road_surface_conditions INT,
    speed_limit INT,
    road_type INT,
    collision_severity INT,
    number_of_vehicles INT,
    number_of_casualties INT,
    day INT,
    year INT,
    month_name STRING,
    month_num INT,
    severity_label STRING,
    weather_label STRING,
    road_surface_label STRING,
    road_type_label STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');

LOAD DATA INPATH '/data/rta/clean_collision.csv' INTO TABLE src_collision;

CREATE TABLE IF NOT EXISTS src_vehicle (
    collision_index STRING,
    collision_year INT,
    vehicle_type INT,
    vehicle_reference INT,
    vehicle_manoeuvre INT,
    sex_of_driver INT,
    age_of_driver INT,
    age_band_of_driver INT,
    age_of_vehicle INT,
    vehicle_type_label STRING,
    sex_label STRING,
    age_band_label STRING,
    manoeuvre_label STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');

LOAD DATA INPATH '/data/rta/clean_vehicle.csv' INTO TABLE src_vehicle;

CREATE TABLE IF NOT EXISTS dim_time (time_id INT, month INT, year INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_time
SELECT ROW_NUMBER() OVER (ORDER BY year, month_num), month_num, year
FROM (SELECT DISTINCT month_num, year FROM src_collision) t;

CREATE TABLE IF NOT EXISTS dim_location (location_id INT, district STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_location
SELECT ROW_NUMBER() OVER (ORDER BY local_authority_ons_district), local_authority_ons_district
FROM (SELECT DISTINCT local_authority_ons_district FROM src_collision) t;

CREATE TABLE IF NOT EXISTS dim_severity (severity_id INT, severity_level STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_severity VALUES (1,'Fatal'),(2,'Serious'),(3,'Slight');

CREATE TABLE IF NOT EXISTS dim_age (age_id INT, age_band STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_age VALUES
(1,'0 to 5'),(2,'6 to 10'),(3,'11 to 15'),(4,'16 to 20'),
(5,'21 to 25'),(6,'26 to 35'),(7,'36 to 45'),(8,'46 to 55'),
(9,'56 to 65'),(10,'66 to 75'),(11,'Over 75');

CREATE TABLE IF NOT EXISTS dim_weather (weather_id INT, weather_condition STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_weather VALUES
(1,'Fine no high winds'),(2,'Raining no high winds'),(3,'Snowing no high winds'),
(4,'Fine + high winds'),(5,'Raining + high winds'),(6,'Snowing + high winds'),
(7,'Fog or mist'),(8,'Other'),(9,'Unknown');

CREATE TABLE IF NOT EXISTS dim_vehicle (vehicle_id INT, vehicle_type STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_vehicle VALUES
(1,'Pedal cycle'),(2,'Motorcycle 50cc and under'),(3,'Motorcycle 50-125cc'),
(4,'Motorcycle 125cc-500cc'),(5,'Motorcycle over 500cc'),
(8,'Taxi/Private hire car'),(9,'Car'),(10,'Minibus'),(11,'Bus or coach'),
(19,'Van/Goods up to 3.5t'),(20,'Goods 3.5t-7.5t'),(21,'Goods 7.5t and over'),
(90,'Other vehicle'),(99,'Unknown vehicle');

CREATE TABLE IF NOT EXISTS dim_vehicle_age (vehicle_age_id INT, vehicle_age INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_vehicle_age
SELECT ROW_NUMBER() OVER (ORDER BY age_of_vehicle), age_of_vehicle
FROM (SELECT DISTINCT age_of_vehicle FROM src_vehicle WHERE age_of_vehicle IS NOT NULL) t;

CREATE TABLE IF NOT EXISTS dim_road_type (road_type_id INT, road_type STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_road_type VALUES
(1,'Roundabout'),(2,'One way street'),(3,'Dual carriageway'),
(6,'Single carriageway'),(7,'Slip road'),(9,'Unknown');

CREATE TABLE IF NOT EXISTS dim_road_surface (road_surface_id INT, surface_condition STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_road_surface VALUES
(1,'Dry'),(2,'Wet or damp'),(3,'Snow'),(4,'Frost or ice'),
(5,'Flood over 3cm deep'),(6,'Oil or diesel'),(7,'Mud');

CREATE TABLE IF NOT EXISTS dim_speed_limit (speed_limit_id INT, speed_limit_value INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_speed_limit
SELECT ROW_NUMBER() OVER (ORDER BY speed_limit), speed_limit
FROM (SELECT DISTINCT speed_limit FROM src_collision WHERE speed_limit IS NOT NULL) t;

CREATE TABLE IF NOT EXISTS dim_gender (gender_id INT, sex_of_driver STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_gender VALUES (1,'Male'),(2,'Female'),(3,'Not known');

CREATE TABLE IF NOT EXISTS dim_manoeuvre (manoeuvre_id INT, manoeuvre_type STRING)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO dim_manoeuvre VALUES
(1,'Reversing'),(2,'Parked'),(3,'Waiting to go ahead or parked'),
(4,'Slowing or stopping'),(5,'Moving off'),(6,'U-turn'),
(7,'Turning left'),(8,'Waiting to turn left'),(9,'Turning right'),
(10,'Waiting to turn right'),(11,'Changing lane to left'),
(12,'Changing lane to right'),(16,'Going ahead left-hand bend'),
(17,'Going ahead right-hand bend'),(18,'Going ahead other');

CREATE TABLE IF NOT EXISTS fct_accidents_1
(time_id INT, location_id INT, severity_id INT, age_id INT, accident_count INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO fct_accidents_1
SELECT dt.time_id, dl.location_id, ds.severity_id, da.age_id, COUNT(*) AS accident_count
FROM src_collision c
JOIN src_vehicle v ON c.collision_index = v.collision_index
JOIN dim_time dt ON MONTH(c.date_val) = dt.month AND YEAR(c.date_val) = dt.year
JOIN dim_location dl ON c.local_authority_ons_district = dl.district
JOIN dim_severity ds ON c.collision_severity = ds.severity_id
JOIN dim_age da ON v.age_band_of_driver = da.age_id
GROUP BY dt.time_id, dl.location_id, ds.severity_id, da.age_id;

CREATE TABLE IF NOT EXISTS fct_accidents_2
(time_id INT, location_id INT, severity_id INT, weather_id INT, accident_count INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO fct_accidents_2
SELECT dt.time_id, dl.location_id, ds.severity_id, dw.weather_id, COUNT(*) AS accident_count
FROM src_collision c
JOIN dim_time dt ON MONTH(c.date_val) = dt.month AND YEAR(c.date_val) = dt.year
JOIN dim_location dl ON c.local_authority_ons_district = dl.district
JOIN dim_severity ds ON c.collision_severity = ds.severity_id
JOIN dim_weather dw ON c.weather_conditions = dw.weather_id
GROUP BY dt.time_id, dl.location_id, ds.severity_id, dw.weather_id;

CREATE TABLE IF NOT EXISTS fct_accidents_3
(time_id INT, severity_id INT, vehicle_id INT, vehicle_age_id INT, fatal_accident_count INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO fct_accidents_3
SELECT dt.time_id, ds.severity_id, dv.vehicle_id, dva.vehicle_age_id, COUNT(*) AS fatal_accident_count
FROM src_collision c
JOIN src_vehicle v ON c.collision_index = v.collision_index
JOIN dim_time dt ON MONTH(c.date_val) = dt.month AND YEAR(c.date_val) = dt.year
JOIN dim_severity ds ON c.collision_severity = ds.severity_id
JOIN dim_vehicle dv ON v.vehicle_type = dv.vehicle_id
LEFT JOIN dim_vehicle_age dva ON v.age_of_vehicle = dva.vehicle_age
WHERE c.collision_severity = 1
GROUP BY dt.time_id, ds.severity_id, dv.vehicle_id, dva.vehicle_age_id;

CREATE TABLE IF NOT EXISTS fct_accidents_4
(time_id INT, road_type_id INT, road_surface_id INT, speed_limit_id INT, weather_id INT, accident_count INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO fct_accidents_4
SELECT dt.time_id, drt.road_type_id, drs.road_surface_id, dsl.speed_limit_id, dw.weather_id, COUNT(*) AS accident_count
FROM src_collision c
JOIN dim_time dt ON MONTH(c.date_val) = dt.month AND YEAR(c.date_val) = dt.year
JOIN dim_road_type drt ON c.road_type = drt.road_type_id
JOIN dim_road_surface drs ON c.road_surface_conditions = drs.road_surface_id
JOIN dim_speed_limit dsl ON c.speed_limit = dsl.speed_limit_value
JOIN dim_weather dw ON c.weather_conditions = dw.weather_id
WHERE c.weather_conditions = 1
GROUP BY dt.time_id, drt.road_type_id, drs.road_surface_id, dsl.speed_limit_id, dw.weather_id;

CREATE TABLE IF NOT EXISTS fct_accidents_5
(time_id INT, age_id INT, gender_id INT, manoeuvre_id INT, accident_count INT)
STORED AS PARQUET TBLPROPERTIES ('parquet.compression'='SNAPPY');

INSERT INTO fct_accidents_5
SELECT dt.time_id, da.age_id, dg.gender_id, dm.manoeuvre_id, COUNT(*) AS accident_count
FROM src_collision c
JOIN src_vehicle v ON c.collision_index = v.collision_index
JOIN dim_time dt ON MONTH(c.date_val) = dt.month AND YEAR(c.date_val) = dt.year
JOIN dim_age da ON v.age_band_of_driver = da.age_id
JOIN dim_gender dg ON v.sex_of_driver = dg.gender_id
JOIN dim_manoeuvre dm ON v.vehicle_manoeuvre = dm.manoeuvre_id
WHERE v.age_band_of_driver = 4
  AND v.sex_of_driver IN (1, 2)
GROUP BY dt.time_id, da.age_id, dg.gender_id, dm.manoeuvre_id;

SELECT dt.year, dt.month, dl.district, ds.severity_level, da.age_band,
       SUM(f1.accident_count) AS accident_count
FROM fct_accidents_1 f1
JOIN dim_time dt ON f1.time_id = dt.time_id
JOIN dim_location dl ON f1.location_id = dl.location_id
JOIN dim_severity ds ON f1.severity_id = ds.severity_id
JOIN dim_age da ON f1.age_id = da.age_id
GROUP BY dt.year, dt.month, dl.district, ds.severity_level, da.age_band
ORDER BY dt.year, dt.month, accident_count DESC;

SELECT dt.year, dt.month, dl.district, ds.severity_level, dw.weather_condition,
       SUM(f2.accident_count) AS accident_count
FROM fct_accidents_2 f2
JOIN dim_time dt ON f2.time_id = dt.time_id
JOIN dim_location dl ON f2.location_id = dl.location_id
JOIN dim_severity ds ON f2.severity_id = ds.severity_id
JOIN dim_weather dw ON f2.weather_id = dw.weather_id
GROUP BY dt.year, dt.month, dl.district, ds.severity_level, dw.weather_condition
ORDER BY dt.year, dt.month, accident_count DESC;

SELECT dv.vehicle_type, dva.vehicle_age,
       SUM(f3.fatal_accident_count) AS fatal_count
FROM fct_accidents_3 f3
JOIN dim_vehicle dv ON f3.vehicle_id = dv.vehicle_id
JOIN dim_vehicle_age dva ON f3.vehicle_age_id = dva.vehicle_age_id
GROUP BY dv.vehicle_type, dva.vehicle_age
ORDER BY fatal_count DESC;

SELECT drt.road_type, drs.surface_condition, dsl.speed_limit_value,
       dw.weather_condition, SUM(f4.accident_count) AS accident_count
FROM fct_accidents_4 f4
JOIN dim_road_type drt ON f4.road_type_id = drt.road_type_id
JOIN dim_road_surface drs ON f4.road_surface_id = drs.road_surface_id
JOIN dim_speed_limit dsl ON f4.speed_limit_id = dsl.speed_limit_id
JOIN dim_weather dw ON f4.weather_id = dw.weather_id
GROUP BY drt.road_type, drs.surface_condition, dsl.speed_limit_value, dw.weather_condition
ORDER BY accident_count DESC;

SELECT da.age_band, dg.sex_of_driver, dm.manoeuvre_type,
       SUM(f5.accident_count) AS accident_count
FROM fct_accidents_5 f5
JOIN dim_age da ON f5.age_id = da.age_id
JOIN dim_gender dg ON f5.gender_id = dg.gender_id
JOIN dim_manoeuvre dm ON f5.manoeuvre_id = dm.manoeuvre_id
GROUP BY da.age_band, dg.sex_of_driver, dm.manoeuvre_type
ORDER BY accident_count DESC;
