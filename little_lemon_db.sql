-- ============================================================
-- Little Lemon Restaurant Booking System
-- Database Schema & Stored Procedures
-- ============================================================

CREATE DATABASE IF NOT EXISTS little_lemon;
USE little_lemon;

-- ============================================================
-- TABLE: Customers
-- ============================================================
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID   INT          NOT NULL AUTO_INCREMENT,
    FirstName    VARCHAR(50)  NOT NULL,
    LastName     VARCHAR(50)  NOT NULL,
    Email        VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber  VARCHAR(20),
    PRIMARY KEY (CustomerID)
);

-- ============================================================
-- TABLE: Staff
-- ============================================================
CREATE TABLE IF NOT EXISTS Staff (
    StaffID   INT         NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName  VARCHAR(50) NOT NULL,
    Role      VARCHAR(50) NOT NULL,
    Salary    DECIMAL(10,2),
    PRIMARY KEY (StaffID)
);

-- ============================================================
-- TABLE: Tables
-- ============================================================
CREATE TABLE IF NOT EXISTS Tables (
    TableID      INT NOT NULL AUTO_INCREMENT,
    TableNumber  INT NOT NULL UNIQUE,
    Capacity     INT NOT NULL,
    Location     VARCHAR(50),   -- e.g. 'Indoor', 'Outdoor', 'Terrace'
    PRIMARY KEY (TableID)
);

-- ============================================================
-- TABLE: MenuCategory
-- ============================================================
CREATE TABLE IF NOT EXISTS MenuCategory (
    CategoryID   INT         NOT NULL AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL,
    PRIMARY KEY (CategoryID)
);

-- ============================================================
-- TABLE: Menu
-- ============================================================
CREATE TABLE IF NOT EXISTS Menu (
    MenuID      INT           NOT NULL AUTO_INCREMENT,
    CategoryID  INT           NOT NULL,
    ItemName    VARCHAR(100)  NOT NULL,
    Description VARCHAR(255),
    Price       DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (MenuID),
    FOREIGN KEY (CategoryID) REFERENCES MenuCategory(CategoryID)
);

-- ============================================================
-- TABLE: Bookings
-- ============================================================
CREATE TABLE IF NOT EXISTS Bookings (
    BookingID    INT          NOT NULL AUTO_INCREMENT,
    CustomerID   INT          NOT NULL,
    TableID      INT          NOT NULL,
    StaffID      INT,
    BookingDate  DATE         NOT NULL,
    BookingTime  TIME         NOT NULL,
    NumGuests    INT          NOT NULL DEFAULT 1,
    PRIMARY KEY (BookingID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TableID)    REFERENCES Tables(TableID),
    FOREIGN KEY (StaffID)    REFERENCES Staff(StaffID)
);

-- ============================================================
-- TABLE: Orders
-- ============================================================
CREATE TABLE IF NOT EXISTS Orders (
    OrderID     INT           NOT NULL AUTO_INCREMENT,
    BookingID   INT           NOT NULL,
    MenuID      INT           NOT NULL,
    Quantity    INT           NOT NULL DEFAULT 1,
    TotalCost   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (MenuID)    REFERENCES Menu(MenuID)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber) VALUES
('Anna',    'Iversen',  'anna.i@gmail.com',      '312-555-0101'),
('Joakim',  'Iversen',  'joakim.i@gmail.com',    '312-555-0102'),
('Vanessa', 'McCarthy', 'vmccarthy@gmail.com',   '312-555-0103'),
('Marcos',  'Romero',   'mromero@outlook.com',   '312-555-0104'),
('Hiroki',  'Yamane',   'hiroki.y@gmail.com',    '312-555-0105'),
('Diana',   'Pinto',    'dpinto@mail.com',        '312-555-0106');

INSERT INTO Staff (FirstName, LastName, Role, Salary) VALUES
('Mario',   'Gollini',  'Manager',       70000.00),
('Adrian',  'Gollini',  'Assistant Manager', 65000.00),
('Giorgos', 'Dioudis',  'Head Chef',     50000.00),
('Fatma',   'Kaya',     'Assistant Chef', 45000.00),
('Elena',   'Salvai',   'Head Waiter',   40000.00),
('John',    'Millar',   'Receptionist',  35000.00);

INSERT INTO Tables (TableNumber, Capacity, Location) VALUES
(1, 2, 'Indoor'),
(2, 2, 'Indoor'),
(3, 4, 'Indoor'),
(4, 4, 'Indoor'),
(5, 6, 'Indoor'),
(6, 8, 'Indoor'),
(7, 4, 'Outdoor'),
(8, 4, 'Outdoor'),
(9, 6, 'Terrace'),
(10, 8, 'Terrace');

INSERT INTO MenuCategory (CategoryName) VALUES
('Starters'),
('Main Courses'),
('Desserts'),
('Drinks');

INSERT INTO Menu (CategoryID, ItemName, Description, Price) VALUES
(1, 'Olives',            'Marinated mixed olives',              5.00),
(1, 'Bread',             'Freshly baked artisan bread',         3.50),
(1, 'Bruschetta',        'Tomato & basil on grilled bread',     6.50),
(1, 'Falafel',           'Crispy chickpea patties',             7.50),
(2, 'Greek Salad',       'Classic Greek salad',                12.00),
(2, 'Bean Soup',         'Hearty white bean soup',             10.00),
(2, 'Pizza',             'Margherita wood-fired pizza',        15.00),
(2, 'Grilled Fish',      'Catch of the day, grilled',          18.00),
(2, 'Pasta',             'Spaghetti with marinara sauce',      13.00),
(3, 'Cheesecake',        'New York style cheesecake',           7.00),
(3, 'Ice Cream',         'Three scoops of gelato',              5.50),
(4, 'Lemonade',          'Freshly squeezed lemonade',           4.00),
(4, 'House Wine (Glass)','Red or white, glass',                 8.00),
(4, 'Sparkling Water',   '500ml sparkling water',               3.00);

INSERT INTO Bookings (CustomerID, TableID, StaffID, BookingDate, BookingTime, NumGuests) VALUES
(1, 1, 5, '2022-10-10', '18:30:00', 2),
(2, 2, 5, '2022-11-12', '19:00:00', 2),
(3, 4, 6, '2022-10-11', '18:00:00', 4),
(4, 3, 6, '2022-10-13', '20:00:00', 3),
(5, 5, 5, '2022-10-12', '18:30:00', 6),
(6, 6, 6, '2022-11-03', '19:30:00', 8);

INSERT INTO Orders (BookingID, MenuID, Quantity, TotalCost) VALUES
(1,  1, 1,  5.00),
(1,  7, 2, 30.00),
(1, 13, 2, 16.00),
(2,  5, 2, 24.00),
(2,  8, 2, 36.00),
(3,  3, 4, 26.00),
(3,  7, 4, 60.00),
(3, 11, 4, 22.00),
(4,  6, 3, 30.00),
(4,  9, 3, 39.00),
(5,  2, 6, 21.00),
(5,  8, 6,108.00),
(6,  4, 8, 60.00),
(6,  7, 8,120.00),
(6, 12, 8, 32.00);


-- ============================================================
-- STORED PROCEDURE 1: GetMaxQuantity()
-- Returns the maximum quantity ever ordered for a single menu item
-- ============================================================
DROP PROCEDURE IF EXISTS GetMaxQuantity;
DELIMITER $$
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT  m.ItemName          AS `Menu Item`,
            MAX(o.Quantity)     AS `Max Ordered Quantity`
    FROM    Orders  o
    JOIN    Menu    m ON o.MenuID = m.MenuID
    GROUP BY o.MenuID, m.ItemName
    ORDER BY MAX(o.Quantity) DESC
    LIMIT 1;
END$$
DELIMITER ;


-- ============================================================
-- STORED PROCEDURE 2: ManageBooking(booking_date, table_id)
-- Checks whether a table is already booked on a given date.
-- ============================================================
DROP PROCEDURE IF EXISTS ManageBooking;
DELIMITER $$
CREATE PROCEDURE ManageBooking(
    IN  p_BookingDate DATE,
    IN  p_TableID     INT
)
BEGIN
    DECLARE v_Count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_Count
    FROM   Bookings
    WHERE  BookingDate = p_BookingDate
      AND  TableID     = p_TableID;

    IF v_Count > 0 THEN
        SELECT CONCAT(
            'Table ', p_TableID,
            ' is already booked on ', p_BookingDate,
            '. Please choose a different table or date.'
        ) AS `Booking Status`;
    ELSE
        SELECT CONCAT(
            'Table ', p_TableID,
            ' is available on ', p_BookingDate, '.'
        ) AS `Booking Status`;
    END IF;
END$$
DELIMITER ;


-- ============================================================
-- STORED PROCEDURE 3: UpdateBooking(booking_id, new_date)
-- Updates the date of an existing booking.
-- ============================================================
DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER $$
CREATE PROCEDURE UpdateBooking(
    IN p_BookingID   INT,
    IN p_NewDate     DATE
)
BEGIN
    DECLARE v_Exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_Exists
    FROM   Bookings
    WHERE  BookingID = p_BookingID;

    IF v_Exists = 0 THEN
        SELECT CONCAT('Booking ', p_BookingID, ' not found.') AS `Update Status`;
    ELSE
        UPDATE Bookings
        SET    BookingDate = p_NewDate
        WHERE  BookingID  = p_BookingID;

        SELECT CONCAT(
            'Booking ', p_BookingID,
            ' successfully updated to ', p_NewDate, '.'
        ) AS `Update Status`;
    END IF;
END$$
DELIMITER ;


-- ============================================================
-- STORED PROCEDURE 4: AddBooking(customer, table, staff, date, time, guests)
-- Adds a new booking after checking table availability.
-- ============================================================
DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER $$
CREATE PROCEDURE AddBooking(
    IN p_CustomerID  INT,
    IN p_TableID     INT,
    IN p_StaffID     INT,
    IN p_BookingDate DATE,
    IN p_BookingTime TIME,
    IN p_NumGuests   INT
)
BEGIN
    DECLARE v_Conflict INT DEFAULT 0;

    SELECT COUNT(*) INTO v_Conflict
    FROM   Bookings
    WHERE  TableID     = p_TableID
      AND  BookingDate = p_BookingDate;

    IF v_Conflict > 0 THEN
        SELECT CONCAT(
            'Table ', p_TableID,
            ' is already booked on ', p_BookingDate,
            '. Booking was NOT added.'
        ) AS `Add Booking Status`;
    ELSE
        INSERT INTO Bookings
            (CustomerID, TableID, StaffID, BookingDate, BookingTime, NumGuests)
        VALUES
            (p_CustomerID, p_TableID, p_StaffID, p_BookingDate, p_BookingTime, p_NumGuests);

        SELECT CONCAT(
            'New booking added successfully! BookingID = ', LAST_INSERT_ID()
        ) AS `Add Booking Status`;
    END IF;
END$$
DELIMITER ;


-- ============================================================
-- STORED PROCEDURE 5: CancelBooking(booking_id)
-- Deletes a booking record by its ID.
-- ============================================================
DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER $$
CREATE PROCEDURE CancelBooking(
    IN p_BookingID INT
)
BEGIN
    DECLARE v_Exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_Exists
    FROM   Bookings
    WHERE  BookingID = p_BookingID;

    IF v_Exists = 0 THEN
        SELECT CONCAT('Booking ', p_BookingID, ' does not exist.') AS `Cancel Status`;
    ELSE
        DELETE FROM Bookings
        WHERE BookingID = p_BookingID;

        SELECT CONCAT(
            'Booking ', p_BookingID, ' successfully cancelled.'
        ) AS `Cancel Status`;
    END IF;
END$$
DELIMITER ;


-- ============================================================
-- QUICK TEST  (uncomment to verify after import)
-- ============================================================
-- CALL GetMaxQuantity();
-- CALL ManageBooking('2022-10-10', 1);   -- should be TAKEN
-- CALL ManageBooking('2022-10-10', 9);   -- should be AVAILABLE
-- CALL AddBooking(1, 9, 5, '2023-01-15', '19:00:00', 2);
-- CALL UpdateBooking(1, '2023-02-20');
-- CALL CancelBooking(1);
