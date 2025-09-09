-- Approximate seat load factor per aircraft_code for flights departing in next 24h
WITH future_flights AS (
    SELECT flight_id, aircraft_code
    FROM bookings.flights
    WHERE scheduled_departure BETWEEN NOW() AND NOW() + INTERVAL '24 hour'
), seats_total AS (
    SELECT aircraft_code, COUNT(*) AS seats
    FROM bookings.seats
    GROUP BY aircraft_code
), occupied AS (
    SELECT bp.flight_id, COUNT(*) AS taken
    FROM bookings.boarding_passes bp
    JOIN future_flights ff ON ff.flight_id = bp.flight_id
    GROUP BY bp.flight_id
)
SELECT ff.aircraft_code,
       AVG(COALESCE(occupied.taken::numeric / NULLIF(seats_total.seats,0),0)) AS avg_load_factor
FROM future_flights ff
LEFT JOIN occupied ON occupied.flight_id = ff.flight_id
LEFT JOIN seats_total ON seats_total.aircraft_code = ff.aircraft_code
GROUP BY ff.aircraft_code
ORDER BY avg_load_factor DESC;
