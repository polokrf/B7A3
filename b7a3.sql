-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    role VARCHAR(20) CHECK(role IN ('Ticket Manager','Football Fan')),
    phone_number TEXT
  );

  -- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY,
    fixture VARCHAR(100),
    tournament_category VARCHAR(100),
    base_ticket_price DECIMAL(10,2) CHECK(base_ticket_price >= 0),
    match_status VARCHAR(20) CHECK(match_status IN('Available', 'Selling Fast', 'Sold Out',' Postponed'))
);


-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    match_id INT REFERENCES matches(match_id) ON DELETE CASCADE,
    seat_number VARCHAR(50),
    payment_status VARCHAR(20) CHECK(payment_status IN('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    total_cost DECIMAL(10,2) CHECK(total_cost >= 0)
    
);


