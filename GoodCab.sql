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



-- Business Request - 3: City-Level Repeat Passenger Trip Frequency Report
/*
Generate a report that shows the percentage distribution of repeat passengers by the
number of trips they have taken in each city. Calculate the percentage of repeat passengers
who took 2 trips, 3 trips, and so on, up to 10 trips.

Each column should represent a trip count category, displaying the percentage of repeat
passengers who fall into that category out of the total repeat passengers for that city.

This report will help identify cities with high repeat trip frequency, which can indicate strong
customer loyalty or frequent usage patterns.

. Fields: city_name, 2-Trips, 3-Trips, 4-Trips, 5-Trips, 6-Trips, 7-Trips, 8-Trips, 9-Trips,
10-Trips
*/

WITH repeating_passenger AS(
SELECT 
    city_id,
    SUM(cast(repeat_passenger_count AS int)) AS repeat_passenger
FROM 
    dim_repeat_trip_distribution 
GROUP BY city_id
),
    city_trip_frequency AS(
SELECT 
    c.city_name,
    trip_count,
    (SUM(cast(repeat_passenger_count AS int))*100/ repeat_passenger) AS repeat_passenger_pct
FROM 
    repeating_passenger rp join dim_repeat_trip_distribution rtd
ON 
    rp.city_id = rtd.city_id 
JOIN dim_city c
ON 
    rtd.city_id = c.city_id
GROUP BY 
    c.city_name,
    trip_count,
    repeat_passenger
    )
SELECT 
    city_name, 
    max(case when trip_count = '2-Trips' then repeat_passenger_pct else 0 end) as Trips_2,
    max(case when trip_count = '3-Trips' then repeat_passenger_pct else 0 end) as Trips_3,
    max(case when trip_count = '4-Trips' then repeat_passenger_pct else 0 end) as Trips_4,
    max(case when trip_count = '5-Trips' then repeat_passenger_pct else 0 end) as Trips_5,
    max(case when trip_count = '6-Trips' then repeat_passenger_pct else 0 end) as Trips_6,
    max(case when trip_count = '7-Trips' then repeat_passenger_pct else 0 end) as Trips_7,
    max(case when trip_count = '8-Trips' then repeat_passenger_pct else 0 end) as Trips_8,
    max(case when trip_count = '9-Trips' then repeat_passenger_pct else 0 end) as Trips_9,
    max(case when trip_count = '10-Trips' then repeat_passenger_pct else 0 end) as Trips_10 
FROM 
    city_trip_frequency
    GROUP BY city_name;


-- Business Request - 4: Identify Cities with Highest and Lowest Total New Passengers
/*
Generate a report that calculates the total new passengers for each city and ranks them
based on this value. Identify the top 3 cities with the highest number of new passengers as
well as the bottom 3 cities with the lowest number of new passengers, categorising them as
"Top 3" or "Bottom 3" accordingly.

Fields

· city_name
· total_new_passengers
. city_category ("Top 3" or "Bottom 3")
*/

WITH rank AS (
SELECT
    city_name, 
    SUM(new_passengers) AS new_passengers ,
    ROW_number() OVER( ORDER BY SUM(new_passengers) DESC) AS high_rank,
    ROW_number() OVER( ORDER BY SUM(new_passengers) ASC) AS low_rank
FROM 
    fact_passenger_summary ps JOIN dim_city c
ON 
    ps.city_id = c.city_id
GROUP BY 
    city_name
)
SELECT 
    city_name,
    new_passengers,
    CASE WHEN high_rank <=3 THEN 'TOP_3'
         WHEN low_rank <=3 THEN 'BOTTOM_3'
    END AS  city_category
FROM 
    rank
WHERE 
    high_rank <= 3 OR low_rank <= 3
ORDER BY new_passengers DESC

-- Business Request - 5: Identify Month with Highest Revenue for Each City
/*
Generate a report that identifies the month with the highest revenue for each city. For each
city, display the month_name, the revenue amount for that month, and the percentage
contribution of that month's revenue to the city's total revenue.

Fields

· city_name
. highest_revenue_month
· revenue
· percentage_contribution (%)
*/
WITH monthly_revenue AS(
    SELECT
        FORMAT(CAST(tf.[date] AS date), 'MMM') AS month_name,
        city_name,
        SUM(fare_amount) AS Monthly_revenue 
    FROM 
        fact_trips tf JOIN dim_city c
    ON 
        tf.city_id = c.city_id
    GROUP BY 
        city_name,  FORMAT(CAST(tf.[date] AS date), 'MMM')
),
    revenue_by_city AS (
        SELECT 
            city_name, 
            SUM(Monthly_revenue) AS Total_revenue 
        FROM 
            monthly_revenue
        GROUP BY
            city_name
        ),
            pct_contribution AS (
        SELECT 
            rc.city_name, 
            month_name,
            rc.Total_revenue,
            ROUND(CAST((monthly_revenue * 100.0) / total_revenue AS float), 2) AS percentage_contribution,
            DENSE_RANK() OVER(partition BY rc.city_name ORDER BY Monthly_revenue DESC) AS rnk_num  
        FROM 
            revenue_by_city rc JOIN monthly_revenue mr 
        ON 
            rc.city_name = mr.city_name
    )
SELECT  
    city_name,
    month_name,
    Total_revenue,
    percentage_contribution
FROM pct_contribution
WHERE rnk_num = 1;


-- Business Request - 6: Repeat Passenger Rate Analysis
/*
Generate a report that calculates two metrics:

1. Monthly Repeat Passenger Rate: Calculate the repeat passenger rate for each city
and month by comparing the number of repeat passengers to the total passengers.
2. City-wide Repeat Passenger Rate: Calculate the overall repeat passenger rate for
each city, considering all passengers across months.

These metrics will provide insights into monthly repeat trends as well as the overall repeat
behaviour for each city.

Fields:
city_name
· month
· total_passengers
· repeat_passengers
. monthly_repeat_passenger_rate (%): Repeat passenger rate at the city and
month level
· city_repeat_passenger_rate (%): Overall repeat passenger rate for each city,
aggregated across months
*/
With monthly_repeat_rate AS (
SELECT 
    city_id,
    MONTH([month]) AS month_num,
    FORMAT(CAST([month] AS date), 'MMM') AS month_name,
    SUM(repeat_passengers) AS repeat_passenger,
    SUM(total_passengers) AS  total_passengers,
    SUM(repeat_passengers)*100/ SUM(total_passengers) AS repeat_rate
FROM 
    fact_passenger_summary
GROUP BY 
    city_id,
    MONTH([month]),
    FORMAT(CAST([month] AS date), 'MMM')
), 
    overall_repert_rate AS (
SELECT 
    city_id,
    SUM(repeat_passengers)*100/ SUM(total_passengers) AS overall_repert_rate
FROM fact_passenger_summary
GROUP BY city_id
    )
SELECT
    c.city_name,
    mrr.month_name,
    mrr.repeat_passenger,
    mrr.total_passengers,
    mrr.repeat_rate,
    orr.overall_repert_rate
FROM overall_repert_rate orr JOIN monthly_repeat_rate mrr 
ON orr.city_id = mrr.city_id
JOIN dim_city c 
ON c.city_id = mrr.city_id
ORDER BY c.city_name;