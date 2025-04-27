-- Daily Flight Analysis Project
-- Author: oguzcans
-- Dialect: PostgreSQL

/*
This project analyzes daily flights for an airline company.
We simulate a small dataset and answer business-related questions
to provide insights about operational performance.
*/

-- Create flights table
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_date DATE,
    flight_number VARCHAR(10),
    departure_city VARCHAR(50),
    arrival_city VARCHAR(50),
    scheduled_departure TIME,
    actual_departure TIME,
    scheduled_arrival TIME,
    actual_arrival TIME,
    status VARCHAR(20) -- On Time, Delayed, Cancelled
);

-- Insert sample randomized data
INSERT INTO flights (flight_date, flight_number, departure_city, arrival_city, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, status)
VALUES
('2025-04-01', 'AA101', 'New York', 'Los Angeles', '08:00', '08:15', '11:00', '11:20', 'Delayed'),
('2025-04-01', 'AA102', 'Chicago', 'Miami', '09:00', '09:00', '13:00', '13:00', 'On Time'),
('2025-04-01', 'AA103', 'Houston', 'San Francisco', '07:30', '08:00', '10:30', '11:00', 'Delayed'),
('2025-04-01', 'AA104', 'Atlanta', 'New York', '06:45', '06:50', '09:30', '09:40', 'On Time'),
('2025-04-01', 'AA105', 'Seattle', 'Chicago', '10:00', '10:10', '14:00', '14:20', 'Delayed'),
('2025-04-01', 'AA106', 'Boston', 'Washington', '11:00', NULL, '13:00', NULL, 'Cancelled'),
('2025-04-02', 'AA107', 'Miami', 'Atlanta', '08:00', '08:00', '10:00', '10:00', 'On Time'),
('2025-04-02', 'AA108', 'Los Angeles', 'New York', '09:30', '09:50', '17:30', '17:50', 'Delayed'),
('2025-04-02', 'AA109', 'San Francisco', 'Houston', '07:00', '07:00', '10:00', '10:00', 'On Time'),
('2025-04-02', 'AA110', 'Chicago', 'Seattle', '13:00', '13:30', '17:00', '17:30', 'Delayed'),
('2025-04-02', 'AA111', 'New York', 'Boston', '12:00', '12:05', '13:00', '13:10', 'On Time'),
('2025-04-02', 'AA112', 'Atlanta', 'Miami', '15:00', '15:00', '17:30', '17:30', 'On Time');

-- 📊 Analysis Queries

-- 1. Total number of flights per day
SELECT
    flight_date,
    COUNT(*) AS total_flights
FROM flights
GROUP BY flight_date
ORDER BY flight_date;

-- 2. Average departure delay (in minutes)
SELECT
    AVG(EXTRACT(EPOCH FROM (actual_departure - scheduled_departure)) / 60) AS avg_departure_delay_minutes
FROM flights
WHERE status != 'Cancelled';

-- 3. Top 3 busiest routes
SELECT
    departure_city || ' ➔ ' || arrival_city AS route,
    COUNT(*) AS total_flights
FROM flights
GROUP BY route
ORDER BY total_flights DESC
LIMIT 3;

-- 4. On-time performance (%)
SELECT
    ROUND(100.0 * SUM(CASE WHEN status = 'On Time' THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_percentage
FROM flights
WHERE status != 'Cancelled';

-- 5. Cities with most delayed arrivals
SELECT
    arrival_city,
    COUNT(*) AS delay_count
FROM flights
WHERE status = 'Delayed'
GROUP BY arrival_city
ORDER BY delay_count DESC;
