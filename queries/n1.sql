SELECT
    f.departure_airport,
    f.arrival_airport,
    (
        SELECT COUNT(*) 
        FROM bookings.ticket_flights tf
        WHERE tf.flight_id = f.flight_id
    ) AS flights_tickets,
    (
        SELECT COALESCE(SUM(tf.amount), 0)
        FROM bookings.ticket_flights tf
        WHERE tf.flight_id = f.flight_id
    ) AS total_amount
FROM bookings.flights f
WHERE f.scheduled_departure > NOW() - INTERVAL '7 days'
ORDER BY total_amount DESC NULLS LAST
LIMIT 20;
