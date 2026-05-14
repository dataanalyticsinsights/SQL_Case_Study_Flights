# Flight & Airline SQL Case Study

## Project Overview

This SQL case study analyzes flight operations, passengers, airlines, airports, ticket sales, and revenue using relational database concepts. The project focuses on solving real-world airline business problems through SQL queries and advanced analytical techniques.

---

# Problem Statement

Airlines and airports generate large amounts of operational and customer data. The goal of this project was to analyze airline performance, passenger behavior, airport activity, ticket revenue, and flight usage patterns using SQL.

---

# Objective

The objective of this project was to:

* Analyze airport traffic and airline performance
* Track passenger flight behavior
* Measure airline revenue and ticket sales
* Identify top-performing airlines and airports
* Practice SQL joins, aggregations, ranking, CTEs, and window functions
* Strengthen analytical thinking using relational databases

---

# Database Tables

## Airports

Contains airport details:

* AirportID
* Name
* Location
* Country

## Airlines

Contains airline information:

* AirlineID
* Name
* Country

## Flights

Contains flight details:

* FlightID
* Origin
* Destination
* DepartureTime
* ArrivalTime
* AirlineID

## Passengers

Contains passenger details:

* PassengerID
* Name
* DOB
* FrequentFlyerStatus

## Tickets

Contains ticket booking information:

* TicketID
* PassengerID
* FlightID
* Price

---

# SQL Concepts Used

* SELECT statements
* JOINs
* GROUP BY
* ORDER BY
* Aggregate functions:

  * COUNT()
  * SUM()
  * AVG()
  * MAX()
  * MIN()
* CASE statements
* CTEs (Common Table Expressions)
* Window Functions:

  * RANK()
  * PARTITION BY
* Date & Time Functions:

  * TIMESTAMPDIFF()
* Aliases
* Multi-table relational analysis

---

# Analysis Performed

## Q1: Find the busiest airport by number of departing flights

* Connected Flights and Airports tables
* Counted departures using COUNT(*)
* Ranked busiest airport using ORDER BY DESC

## Q2: Total number of tickets sold per airline

* Connected Tickets → Flights → Airlines
* Counted tickets sold for each airline

## Q3: List all flights operated by IndiGo with origin and destination airport names

* Used multiple JOINs
* Joined Airports table twice for origin and destination

## Q4: For each airport, show the top airline by number of departing flights

* Created CTEs
* Used RANK() with PARTITION BY
* Identified highest-performing airline at each airport

## Q5: Categorize flights based on travel duration

* Calculated travel hours using TIMESTAMPDIFF()
* Classified flights as:

  * Short
  * Medium
  * Long
* Used CASE statements for categorization

## Q6: Show each passenger’s first and last flight dates and total flights

* Used MIN() and MAX() for earliest/latest flights
* COUNT(*) for total flights per passenger

## Q7: Find highest ticket price sold for each route

* Grouped flights by origin and destination
* Used MAX() to identify highest ticket price

## Q8: Find highest spending passenger in each Frequent Flyer group

* Calculated passenger spending using SUM()
* Ranked passengers inside each status group

## Q9: Find total revenue and ticket sales per airline and rank airlines by revenue

* Used SUM(Price) for revenue
* COUNT(*) for ticket sales
* Applied RANK() for revenue ranking

## Q10: Identify each passenger’s most frequently used airline

* Counted airline usage per passenger
* Used RANK() with PARTITION BY
* Included tied rankings

---

# Key Learnings

Through this project, I learned:

* How relational databases connect through keys
* How to think through SQL problems step-by-step
* How to use JOINs effectively across multiple tables
* How to aggregate and summarize business data
* How to use CTEs for multi-step analysis
* How window functions like RANK() and PARTITION BY work
* How to solve real-world airline and passenger analytics problems using SQL

---

# Tools Used

* MySQL Workbench
* SQL
* Relational Database Concepts

---

# Conclusion

This project helped strengthen my SQL analytical skills by solving practical airline business problems. I improved my understanding of joins, aggregations, ranking functions, and structured problem-solving using SQL.
