# create database
CREATE DATABASE rideshare_app;
USE rideshare_app;

CREATE TABLE Rider (
    riderID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    password VARCHAR(50)
);

CREATE TABLE Driver (
    driverID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    password VARCHAR(50),
    isActive BOOLEAN DEFAULT TRUE
);

CREATE TABLE Ride (
    rideID INT AUTO_INCREMENT PRIMARY KEY,
    riderID INT,
    driverID INT,
    pickup_location VARCHAR(100),
    dropoff_location VARCHAR(100),
    rideDate DATETIME,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (riderID) REFERENCES Rider(riderID),
    FOREIGN KEY (driverID) REFERENCES Driver(driverID)
);

INSERT INTO Rider (name, email, phone, password) VALUES
('Jaime', 'jaime@gmail.com', '2132223114', 'pass1'),
('Toby', 'toby@gmail.com', '0987654321', 'pass2');

INSERT INTO Driver (name, email, phone, password, isActive) VALUES
('Lip', 'lip@gmail.com', '5555555555', 'pass3', TRUE),
('Fiona', 'fiona@gmail.com', '6666666666', 'pass4', FALSE);

INSERT INTO Ride (riderID, driverID, pickup_location, dropoff_location, rideDate, rating) VALUES
(1, 1, '123 Main St', '456 Elm St', NOW(), 5),
(2, 1, '789 Oak St', '321 Pine St', NOW(), 4);

