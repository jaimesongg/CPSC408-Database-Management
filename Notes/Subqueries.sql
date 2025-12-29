-- Subquery: query nested inside another larger query
    -- may occur in: SELECT statement, FROM clause, WHERE clause
-- i need to calculate smtg before i can finish the real query

-- WHERE Clause: used when you need a value from another query to filter rows
-- example: find customers who spent more than avg total invoices
SELECT CustomerId, Total
FROM invoices
WHERE Total > (
    SELECT AVG(Total) FROM invoices
);

-- FROM clause: subquery becomes a temporary table
    -- useful for when u need to build intermeidate results
SELECT CustomerId, totalSpent
FROM (
    SELECT CustomerId, SUM(Total) AS totalSpent
    FROM invoices
    GROUP BY CustomerId
) AS spending
WHERE totalSpent > 100; 

-- SELECT clause: used to compute extra values for each row
SELECT 
    Name, 
    (SELECT COUNT(*) FROM tracks WHERE tracks.AlbumId = albums.AlbumId)
FROM albums;

/* Why we use subqueries
- When answer depends on another query
- When we need intermediate results 
- When joins become messy
- When we need to check existnce of rows
- When we cannot use joins easily

*/