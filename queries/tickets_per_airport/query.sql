-- Top departure airports by tickets in last 30 days
SELECT f.departure_airport, COUNT(tf.ticket_no) AS tickets
FROM bookings.ticket_flights tf
JOIN bookings.flights f ON f.flight_id = tf.flight_id
WHERE f.scheduled_departure > NOW() - INTERVAL '30 days'
GROUP BY f.departure_airport
ORDER BY tickets DESC
LIMIT 10;
