# GoodCab Analysis

## Company Overview
GoodCabs, an imaginary company established two years ago, has quickly become a leading cab service provider in India's tier-II cities. 
Unlike traditional competitors, GoodCabs is driven by a mission to empower local drivers, helping them build sustainable livelihoods within their communities while providing passengers with exceptional service. 
Operating across 10 tier-II cities, GoodCabs combines a community-focused approach with a commitment to delivering a seamless travel experience. 
It aims to solidify its position as a trusted mobility partner in underserved markets.

## Project Objective
This project aims to achieve two objectives:

1. The objective of this to showcases a complete cloud-based data pipeline and business intelligence solution for **GoodCabs**, a growing ride-hailing service, using **Azure Data Factory**, **Azure SQL Database** and **Power BI**.
2. To conduct a comprehensive analysis of **Goodcabs' performance** across key metrics—such as **trip volume**, **passenger satisfaction**, **retention rates**, **trip distribution** and the **balance between new and repeat passengers**. 

By evaluating these metrics the project aims to:
- Identify **critical growth opportunities**
- Address **operational inefficiencies**
- Provide **actionable insights** to help Goodcabs achieve its **market penetration goals** and meet its **2024 business targets**

## Tools Used
- Azure
- Azure SQL Database
- Azure Storage
- Azure Database
- Power BI
- <a href="https://app.powerbi.com/view?r=eyJrIjoiZTA1NTI5MDAtNzFhOS00OWY5LTg5NDgtZmMzYmJhMTUxYTBlIiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9">View Dashboard</a>

## **Situation**
GoodCabs, a mobility startup, wanted to gain a deeper understanding of its operational performance to support growth in tier-2 cities and reach 2024 market targets. They had large datasets stored in the cloud with limited visibility into KPIs.

## **Task**
Design and implement a scalable **Azure-based data pipeline** to process trip data, analyze key performance indicators (KPIs), and present executive-level insights via Power BI dashboards for the Chief of Operations.

## **Action**
- Built an **ETL pipeline** using **Azure Data Factory** to transfer structured trip data from **Azure Blob Storage** to **Azure SQL Database**.
- Created linked services, datasets, and pipelines to ensure secure, efficient data flow.
- Wrote SQL queries to answer **ad-hoc business questions**.
- Designed an **interactive Power BI dashboard** showcasing KPIs such as trip volume, passenger retention, regional distribution, and satisfaction analysis.

## Revenue Dashboard
![image alt](https://github.com/bhaskarkumar222/Good_Cab_Analysis/blob/964268730485ad6a5201e8f0e263e854db2d0332/Revenue%20Dashboard.png)

## City Dashboard
![image_alt](https://github.com/bhaskarkumar222/Good_Cab_Analysis/blob/964268730485ad6a5201e8f0e263e854db2d0332/City%20Dashboard.png)

## Passenger Dashboard
![image_alt](https://github.com/bhaskarkumar222/Good_Cab_Analysis/blob/964268730485ad6a5201e8f0e263e854db2d0332/Passenger%20Dashboard.png)

## Key Insides
- **Jaipur:** Contributes the highest to Trips (18%) and Revenue (₹37.2M, 34%) but relies heavily on New Passengers (80%).
- **Lucknow:** Ranks second in Trips (15%) but has low Revenue due to poor Ratings and lower Average Fare Per Trip.
- **Mysore:** Small contributor (4% of Trips) but exceeds Trip Targets by 20%, demonstrating high efficiency and satisfaction (Ratings above 8.0).
- **Surat:** Leads in Repeat Passenger Rate (42%) but struggles with Low Ratings due to lower fares.
- **Seasonal Trends:** Trips peaked in February and March, declining steadily afterwards, but Repeat Passenger loyalty increased during off-peak months.

