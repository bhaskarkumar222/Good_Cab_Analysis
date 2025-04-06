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