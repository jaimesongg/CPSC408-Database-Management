/* 
Aggregate Functions: allow collection and reporting of records and stats over tables
- COUNT: num of records in resulting relation
- SUM: sum of values of an attribute in a relation
- AVG: avg of an attribute in a relation
- MIN: min value of an attribute in a relation
- MAX: max value of an attribute in a relation 
*/

-- COUNT ----------------------
-- count func return num of records that meet WHERE condition 
SELECT COUNT(*) AS totalInvoices -- counts how many rows in invoices table have BillingCity = "Olso"
FROM invoices
WHERE BillingCity = 'Olso';

-- count func can also return output of records that do not have NULL value for some column
-- can include DISTINCT operator to remove duplicates before completing aggregation
SELECT COUNT(DISTINCT BillingState) AS totalStates
FROM invoices

-- MIN, MAX, AVG, SUM -------------------
SELECT MIN(attr) AS minAttr,
    MAX(attr) AS maxArrr,
    AVG(attr) AS avgAttr,
    SUM(attr) AS sumAttr
FROM tbl_name
WHERE ..;

-- GROUP BY ---------------------------
-- allows for aggregates per unique each value of some attribute(s)
-- returns total number of records per each unique value in BillingCity column
SELECT BillingCity, COUNT(*) AS TotalRecords -- attribute you group by must also be in SELECT statement
FROM invoices
GROUP BY BillingCity;

-- HAVING ----------------------
-- similar to if we had a second WHERE statement that took place after we used GROUP BY
    -- must be used in conjunction with GROUP BY
SELECT BillingCity, COUNT(*) AS RecordCount 
FROM invoices
GROUP BY BillingCity
HAVING RecordCount > 10; -- filters only for Billing Cities that have more than 10 records

-- if you want to filter value of some attribute that is already on the table before you query, filter using WHERE
-- if you want to filter vlaue of some aggregate that is generated from your query but not itself stored on table, filter using HAVING