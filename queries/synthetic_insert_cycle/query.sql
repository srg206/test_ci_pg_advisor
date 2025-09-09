-- Synthetic idempotent insert chain creating booking->ticket->flight(if future)->ticket_flight->optional boarding_pass
-- Uses fixed keys with date shifting so function remains mostly idempotent across runs.

-- Create booking
INSERT INTO bookings.bookings (book_ref, book_date, total_amount)
VALUES ('ZZZ900', NOW(), 12345.67)
ON CONFLICT (book_ref) DO NOTHING;

-- Create ticket
INSERT INTO bookings.tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data)
VALUES ('9900000000001', 'ZZZ900', 'P900 000001', 'TEST PASSENGER', '{"phone":"+70000000001"}')
ON CONFLICT (ticket_no) DO NOTHING;

-- Create future flight (flight_id constant for demo)
INSERT INTO bookings.flights (flight_id, flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, status, aircraft_code)
VALUES (900001, 'TZ900', NOW() + interval '2 hour', NOW() + interval '4 hour', 'SVO', 'LED', 'Scheduled', '320')
ON CONFLICT (flight_id) DO NOTHING;

-- Link ticket to flight
INSERT INTO bookings.ticket_flights (ticket_no, flight_id, fare_conditions, amount)
VALUES ('9900000000001', 900001, 'Economy', 4000)
ON CONFLICT (ticket_no, flight_id) DO NOTHING;

-- Insert boarding pass if seat free (ignore errors)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM bookings.boarding_passes WHERE ticket_no='9900000000001' AND flight_id=900001
    ) THEN
        INSERT INTO bookings.boarding_passes (ticket_no, flight_id, boarding_no, seat_no)
        VALUES ('9900000000001', 900001, 1, '10A');
    END IF;
END;$$;
