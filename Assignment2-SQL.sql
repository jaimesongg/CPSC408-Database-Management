-- 1) Create
CREATE TABLE Patient(
    patientID INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    dob DATE,
    phone INTEGER
);

-- 2) Alter Add
ALTER TABLE Patient
ADD COLUMN address VARCHAR(100);

-- 3) Drop
DROP TABLE Patient;

-- 4) Retrieve
SELECT FirstName, LastName, Email
FROM employees;

-- 5) Retrieve
SELECT EmployeeId
FROM employees
WHERE HireDate LIKE '2004%';

-- 6) Retrieve
SELECT *
FROM employees
WHERE Title LIKE '%Manager';

-- 7) Return
SELECT DISTINCT BillingCity
FROM invoices;

-- 8) Return
SELECT DISTINCT BillingCountry
FROM invoices
WHERE Total > 10
AND InvoiceDate LIKE '2013%';