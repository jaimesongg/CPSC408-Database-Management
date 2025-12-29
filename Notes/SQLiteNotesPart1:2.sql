/* 
SQLite Type Affinities (5 categories)
NULL: value is a NULL value
INTEGER: value is signed integer (1, 2, 3, 4)
REAL: value is a floating point value (1.0, 2.0, 3.0, 4.0)
BLOB: value is a blob of data, stored exactly as it was input
*/

/*
Data Definition Language (DDL): defines syntax for creating/modifying database objects in RDBMS
CREATE: create new db objects
ALTER: alter existing db objects
DROP: remove existing db objects
TRUNCATE: delete records from db objects
*/

-- CREATE -------------------------------
CREATE DATABASE db_name;
CREATE TABLE tbl_name;
CREATE VIEW view_name AS ...;

-- CREATE TABLE Syntax
CREATE TABLE tbl_name(
    attribute1 datatype,
    attribute2 datatype
);
-- Eeample:
CREATE TABLE astronaut(
    astronautID INTEGER,
    name VARCHAR(20),
    age INTEGER
);

-- constraints
CREATE TABLE astronaut(
    astronautID INTEGER NOT NULL, -- ensures values for these records are never empty
    name VARCHAR(20),
    age INTEGER
    PRIMARY KEY (astronautID) -- constraint specifies what attributes are primary key for table
);
-- another way
CREATE TABLE astronaut(
    astronautID INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(20),
    age INTEGER
);

-- foreign key: always specifiy
CREATE TABLE astronaut(
    astronautID INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(20),
    age INTEGER,
    agencyID INTEGER,
    FOREIGN KEY (agencyID) REFERENCES agency(agencyID) -- from agency table
);

-- auto increment: allows us to have our system handle assigning new values to new rows
    -- no longer need to provide a value for astronautID, system will automatically assign next available
CREATE TABLE astronaut(
    astronautID INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    age INTEGER,
    agencyID INTEGER,
);

-- INSERT INTO
INSERT INTO astronaut(name, age, agencyID)
    VALUES('Buzz', '82', '3'); -- since we used AUTO_INCREMENT when creating table, if astronautID 1-5 is taken, Buzz will be auto incremeted to astronautID 6

-- ALTER -----------------------------------------
-- adding
ALTER TABLE astronaut
ADD COLUMN agency VARCHAR(10);

-- modifying
ALTER TABLE astronaut
MODIFY COLUMN agency VARCHAR(20);

-- deleting
ALTER TABLE astronaut
DROP COLUMN agency;

-- changing primary key: 
-- first remove old key 
ALTER TABLE astronaut
DROP PRIMARY KEY;
-- then add new one
ALTER TABLE astronaut
ADD PRIMARY KEY(name);

-- DROP/TRUNCATE ---------------------------------
    -- delete database objects (once executed table cannot be recovered)
DROP TABLE astronaut; -- delete data in table and its schema
TRUNCATE TABLE astronaut; -- keeps table schema but deletes all records in it

/* 
Data Manipulation Language (DML): defines syntax to add, remove, update data from existing tables
INSERT
UPDATE
DELETE
*/

-- INSERT -----------------------------
-- first create table
CREATE TABLE astronaut(
    astronautID INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(40),
    age INTEGER,
);

INSERT INTO astronaut VALUES(1, 'Ed Lu', 60); 

-- since age doesnt specify not null u can also leave age as null
INSERT INTO astronaut(astronautID, Name) VALUES(2, 'Scott', NULL);

-- multiple records can be inserted with single insert statement as well
INSERT INTO astronaut
VALUES (3, 'Mark', 50),
(4, 'Peggy', 55);

-- UPDATE -----------------------------
UPDATE astronaut
SET Age = 50, Name = 'Oleg Kotov'
WHERE Age IS NULL; -- need or it will update every record in table (means update only rows where age is null)

-- DELETE --------------------------------
-- remove all records from astronaut table where age equals 51 
DELETE FROM astronaut
WHERE Age = 51; 

DELETE FROM astronaut
WHERE age IS NULL; -- cannot do Age = NULL

-- remove all records from table (like truncate)
DELETE FROM astronaut; 

/* 
Data Query Language (DQL): defines a single operation (SELECT) that is used to retrieve information from tables
    Does not alter anything in tuple, attribute, or relation this just generates output
*/

-- SELECT ----------------------------------
-- returns set of attributes from a table
SELECT attribute1, attribute2
FROM table;

SELECT * -- returns all attributes from table
FROM table;

-- can also pass constants in list of attributes of select like we did before
SELECT Title, ArtistID, 5 -- creates new column on output with constant value (5) filled for every row
FROM albums;

-- AS operator: used in SELECT clause to rename attributes in result
SELECT Title AS albumTitle,
    ArtistID,
    5 AS number
FROM albums;

-- DISTINCT operator: use with an attribute in SELECT clause to only return unique values of that attribute
SELECT DISTINCT Composer AS Artist
FROM tracks;

-- arithmetic operations
SELECT Total, Total/2
FROM invoices;

-- WHERE --------------------------------
-- specify conditions in where clause to filter records 
SELECT *
FROM invoices
WHERE BillingCountry = 'USA' AND total > 10;

-- IN operator: search for multiple values of an attribute
SELECT * 
FROM invoices
WHERE BillingCountry IN ('USA', 'CANADA');

-- BETWEEN operator: search within a range
SELECT *
FROM invoices 
WHERE Total BETWEEN 10 AND 20; -- also works with data attributes as well as alphabetically with text

-- LIKE operator: search for substrings in attribute values given some pattern 
SELECT *
FROM customers
WHERE FirstName LIKE 'Harry';

-- % and _ operators:
SELECT *
FROM customers
WHERE FirstName LIKE 'S%' -- returns all users whose name starts with S
OR FirstName LIKE 'H_ _'; -- returns all users whose name starts with H and is exactly 3 chars long
WHERE FirstName LIKE 'H_ _ %'; -- returns all first names that start with H and at least 3 chars long
WHERE FirstName LIKE '%Alex%'; -- returns all names that contain Alex
OR FirstName LIKE 'S%a'; -- specifies beginning and end 
WHERE FirstName NOT LIKE '%Jaime%'; -- returns all names that dont have Jaime

-- ORDER BY ------------------------------
-- sort resulting records by values of attributes in ascending or descending order (ascending is default)
SELECT *
FROM invoices
ORDER BY Total ASC;

-- can also provide more than one attribute to order by
SLEECT BillingCountry, Total
FROM invoices
WHERE InvoiceData > '2009-05-01'
ORDER BY total DESC, BillingCountry ASC; 

-- LIMIT -----------------------------
-- limit number of records you want to retun in result
SELECT *
FROM customers
LIMIT 10; -- return first 10 records on customer table





