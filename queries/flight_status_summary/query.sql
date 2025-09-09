-- Aggregate count of flights per status and recent time window
SELECT status, COUNT(*) AS cnt
FROM bookings.flights
WHERE scheduled_departure > NOW() - INTERVAL '7 days'
GROUP BY status
ORDER BY cnt DESC;
