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


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);



-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'

SELECT
  match_id,
  fixture,
  base_ticket_price
FROM
  matches
WHERE
  tournament_category = 'Champions League'
  AND match_status = 'Available'

-- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive)

SELECT
  user_id,
  full_name,
  email
FROM
  users
WHERE
  full_name ILIKE ('Tanvir%')
  OR full_name ILIKE ('%Haque%')


 -- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.

SELECT
  booking_id,
  user_id,
  match_id,
  COALESCE(payment_status, 'Action Required') AS systematic_status
FROM
  bookings
WHERE
  payment_status IS NULL



-- Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.

SELECT
  booking_id,
  full_name,
  fixture,
  total_cost
FROM
  bookings AS b
  INNER JOIN users AS u ON b.user_id = u.user_id
  INNER JOIN matches AS m ON b.match_id = m.match_id


-- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.

SELECT
  u.user_id,
  full_name,
  booking_id
FROM
  users AS u
  LEFT JOIN bookings AS b ON b.user_id = u.user_id