SELECT * FROM Airports;
SELECT * FROM Airlines;
SELECT * FROM Flights;
SELECT * FROM Passengers;
SELECT * FROM Tickets;

#Q1: Find the busiest airport by the number of flights take off

# Step 1. Shows airport names.
SELECT a.Name
FROM Flights f
JOIN Airports a
ON f.Origin = a.AirportID;

# Then count
SELECT a.Name,
       COUNT(*)
FROM Flights f
JOIN Airports a
ON f.Origin = a.AirportID
GROUP BY a.Name;

# Result
SELECT 
    a.Name AS AirportName,
    a.Location,
    a.Country,
    COUNT(*) AS FlightsTakingOff
FROM Flights f
JOIN Airports a
    ON f.Origin = a.AirportID
GROUP BY 
    a.Name,
    a.Location,
    a.Country
ORDER BY FlightsTakingOff DESC
LIMIT 1;

# Q2: Total number of tickets sold per airline

SELECT 
    a.Name AS AirlineName,
    COUNT(*) AS TotalTicketsSold
FROM Tickets t
JOIN Flights f
    ON t.FlightID = f.FlightID
JOIN Airlines a
    ON f.AirlineID = a.AirlineID
GROUP BY a.Name
ORDER BY TotalTicketsSold DESC;

# Q3 List all flights operated by 'IndiGo' with airport names (origin and destination)
SELECT 
    f.FlightID,
    al.Name AS AirlineName,
    ao.Name AS OriginAirport,
    ad.Name AS DestinationAirport,
    f.DepartureTime,
    f.ArrivalTime
FROM Flights f
JOIN Airlines al
    ON f.AirlineID = al.AirlineID
JOIN Airports ao
    ON f.Origin = ao.AirportID
JOIN Airports ad
    ON f.Destination = ad.AirportID
WHERE al.Name = 'IndiGo';

# Q4: For each airport, show the top airline by number of flights departing from there
WITH AirlineFlights AS (
    SELECT 
        ap.Name AS AirportName,
        al.Name AS AirlineName,
        COUNT(*) AS TotalDepartures
    FROM Flights f
    JOIN Airports ap
        ON f.Origin = ap.AirportID
    JOIN Airlines al
        ON f.AirlineID = al.AirlineID
    GROUP BY 
        ap.Name,
        al.Name
),

RankedAirlines AS (
    SELECT 
        AirportName,
        AirlineName,
        TotalDepartures,
        RANK() OVER (
            PARTITION BY AirportName
            ORDER BY TotalDepartures DESC
        ) AS rk
    FROM AirlineFlights
)

SELECT 
    AirportName,
    AirlineName,
    TotalDepartures
FROM RankedAirlines
WHERE rk = 1
ORDER BY AirportName;

#Q5: For each flight, show time taken in hours and categorize it as Short (<2h), Medium (2-5), or Long (>5)
SELECT
    FlightID,
    DepartureTime,
    ArrivalTime,

    ROUND(
        TIMESTAMPDIFF(MINUTE, DepartureTime, ArrivalTime) / 60,
        2
    ) AS HoursTaken,

    CASE
        WHEN TIMESTAMPDIFF(MINUTE, DepartureTime, ArrivalTime) / 60 < 2 THEN 'Short'
        WHEN TIMESTAMPDIFF(MINUTE, DepartureTime, ArrivalTime) / 60 BETWEEN 2 AND 5 THEN 'Medium'
        ELSE 'Long'
    END AS FlightCategory

FROM Flights;

# Q6: Show each passenger's firts and last flights dates and number of flights
SELECT
    p.Name AS PassengerName,

    MIN(f.DepartureTime) AS FirstFlightDate,

    MAX(f.DepartureTime) AS LastFlightDate,

    COUNT(*) AS NumberOfFlights

FROM Passengers p

JOIN Tickets t
    ON p.PassengerID = t.PassengerID

JOIN Flights f
    ON t.FlightID = f.FlightID

GROUP BY p.Name

ORDER BY NumberOfFlights DESC;

# Q7: Find flights with the highest price ticket sold for each route (origin? destination)
SELECT
    ao.Name AS OriginAirport,
    ad.Name AS DestinationAirport,

    MAX(t.Price) AS HighestTicketPrice

FROM Tickets t

JOIN Flights f
    ON t.FlightID = f.FlightID

JOIN Airports ao
    ON f.Origin = ao.AirportID

JOIN Airports ad
    ON f.Destination = ad.AirportID

GROUP BY
    ao.Name,
    ad.Name

ORDER BY HighestTicketPrice DESC;

# Q8: Find the highest spending passenger in each Frequent Flyer Status Group
WITH PassengerSpending AS (
    SELECT
        p.PassengerID,
        p.Name AS PassengerName,
        p.FrequentFlyerStatus,
        SUM(t.Price) AS TotalSpending
    FROM Passengers p
    JOIN Tickets t
        ON p.PassengerID = t.PassengerID
    GROUP BY
        p.PassengerID,
        p.Name,
        p.FrequentFlyerStatus
),

RankedPassengers AS (
    SELECT
        PassengerName,
        FrequentFlyerStatus,
        TotalSpending,
        RANK() OVER (
            PARTITION BY FrequentFlyerStatus
            ORDER BY TotalSpending DESC
        ) AS rk
    FROM PassengerSpending
)

SELECT
    FrequentFlyerStatus,
    PassengerName,
    TotalSpending
FROM RankedPassengers
WHERE rk = 1
ORDER BY TotalSpending DESC;

# Q9:Find the total revenue and number of tickets sold for each airline, and rank the airlines based on total revenue.

SELECT
    a.Name AS AirlineName,
    COUNT(*) AS TicketsSold,
    SUM(t.Price) AS TotalRevenue,
    RANK() OVER (
        ORDER BY SUM(t.Price) DESC
    ) AS RevenueRank
FROM Tickets t
JOIN Flights f
    ON t.FlightID = f.FlightID
JOIN Airlines a
    ON f.AirlineID = a.AirlineID
GROUP BY a.Name
ORDER BY TotalRevenue DESC;


 #Q10: For each passenger, identify their most frequently used airline. If a passenger has multiple airlines with the same highest usage, show all such airlines. 
 WITH PassengerAirlineUsage AS (
    SELECT
        p.PassengerID,
        p.Name AS PassengerName,
        a.Name AS AirlineName,
        COUNT(*) AS TimesUsed
    FROM Passengers p
    JOIN Tickets t
        ON p.PassengerID = t.PassengerID
    JOIN Flights f
        ON t.FlightID = f.FlightID
    JOIN Airlines a
        ON f.AirlineID = a.AirlineID
    GROUP BY
        p.PassengerID,
        p.Name,
        a.Name
),

RankedUsage AS (
    SELECT
        PassengerName,
        AirlineName,
        TimesUsed,
        RANK() OVER (
            PARTITION BY PassengerID
            ORDER BY TimesUsed DESC
        ) AS rk
    FROM PassengerAirlineUsage
)

SELECT
    PassengerName,
    AirlineName,
    TimesUsed
FROM RankedUsage
WHERE rk = 1
ORDER BY PassengerName;