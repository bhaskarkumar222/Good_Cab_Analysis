CREATE TABLE [dbo].[fact_trips] (
    [trip_id]                NVARCHAR (MAX) NULL,
    [date]                   NVARCHAR (MAX) NULL,
    [city_id]                NVARCHAR (MAX) NULL,
    [passenger_type]         NVARCHAR (MAX) NULL,
    [distance_travelled(km)] NVARCHAR (MAX) NULL,
    [fare_amount]            NVARCHAR (MAX) NULL,
    [passenger_rating]       NVARCHAR (MAX) NULL,
    [driver_rating]          NVARCHAR (MAX) NULL
);


GO

