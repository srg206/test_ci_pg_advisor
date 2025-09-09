-- Revenue per route (departure->arrival) over last 7 days based on ticket_flights
SELECT f.departure_airport,
       f.arrival_airport,
       COUNT(*) AS flights_tickets,
       SUM(tf.amount) AS total_amount
FROM bookings.ticket_flights tf
JOIN bookings.flights f ON f.flight_id = tf.flight_id
WHERE f.scheduled_departure > NOW() - INTERVAL '7 days'
GROUP BY f.departure_airport, f.arrival_airport
ORDER BY total_amount DESC NULLS LAST
LIMIT 20;
