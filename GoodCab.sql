SELECT * FROM city_target_passenger_rating
SELECT * FROM dim_city
SELECT * FROM fact_passenger_summary
SELECT * from fact_trips
SELECT * FROM dim_repeat_trip_distribution
SELECT * FROM dim_date
SELECT * FROM monthly_target_new_passengers
SELECT * FROM monthly_target_trips


-- Business Request - 1: City-Level Fare and Trip Summary Report

/* Generate a report that displays the total trips, average fare per km, average fare per trip, and
 the percentage contribution of each city's trips to the overall trips. This report will help in
 assessing trip volume, pricing efficiency, and each city's contribution to the overall trip count.

Fields:
· city_name
· total_trips
· avg_fare_per_km
· avg_fare_per_trip
· %_contribution_to_total_trips */

SELECT 
    c.city_name,
    COUNT(trip_id) AS total_trips,
    SUM(t.fare_amount)/SUM(t.[distance_travelled(km)]) AS avg_fare_per_km,
    SUM(t.fare_amount)/ COUNT(trip_id) AS avg_fare_per_trip
FROM 
    dim_city c JOIN fact_trips t
ON  c.city_id = t.city_id 
GROUP BY c.city_name;


-- Business Request - 2: Monthly City-Level Trips Target Performance Report

/* Generate a report that evaluates the target performance for trips at the monthly and city
level. For each city and month, compare the actual total trips with the target trips and
categorise the performance as follows:

. If actual trips are greater than target trips, mark it as "Above Target".
. If actual trips are less than or equal to target trips, mark it as "Below Target".

Additionally, calculate the % difference between actual and target trips to quantify the
performance gap.

Fields:
· City_name
· month_name
  actual_trips
· target_trips
· performance_status
· %_difference
*/


SELECT * FROM dim_date;
SELECT * FROM monthly_target_trips;


with actual_price AS (
SELECT 
    ft.city_id AS city_id,
    start_of_month,
    month_name,
    COUNT(trip_id) AS actual_trips
FROM 
    fact_trips ft JOIN dim_date d 
ON  
    ft.[date] = d.[date]
GROUP BY ft.city_id, month_name,start_of_month
)
Select 
    month_name, 
    c.city_name, 
    actual_trips,
    total_target_trips as target_trip,
    CASE
        WHEN actual_trips > total_target_trips THEN 'Above Target'
        ELSE 'Below' END AS performance_status,
    ( actual_trips - total_target_trips)*100 / actual_trips AS Pct_difference
FROM 
    actual_price ap JOIN dim_city c
ON 
    ap.city_id = c.city_id
JOIN monthly_target_trips mt 
ON 
    mt.city_id = c.city_id and mt.[month] = ap.start_of_month;


