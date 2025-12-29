-- SET 1
-- 1)
SELECT
    Composer,
    AVG(Milliseconds) AS AvgDuration
FROM tracks
WHERE Composer IS NOT NULL
GROUP BY Composer
ORDER BY AvgDuration DESC;

-- 2)
SELECT
    COUNT(DISTINCT CustomerId) AS TotalUniqueCustomers
FROM customers;

-- 3)
SELECT
    mt.Name AS MediaType,
    g.Name AS Genre,
    COUNT(t.TrackId) AS TotalRecords,
    MAX(t.UnitPrice) AS MaxUnitPrice
FROM tracks t
JOIN media_types mt ON t.MediaTypeId = mt.MediaTypeId
JOIN genres g ON t.GenreId = g.GenreId
GROUP BY mt.Name, g.Name
ORDER BY mt.Name, g.Name;

-- 4)
SELECT
    g.Name AS Genre,
    AVG(t.Milliseconds) AS AvgDuration
FROM tracks t
JOIN genres g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY AvgDuration DESC;

-- 5)
SELECT
    ar.Name AS Artist,
    COUNT(al.AlbumId) AS TotalAlbums
FROM albums al
JOIN artists ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY TotalAlbums DESC;

-- 6)
SELECT
    BillingCity,
    COUNT(InvoiceId) AS TotalInvoices
FROM invoices
WHERE BillingCountry = 'USA'
GROUP BY BillingCity
ORDER BY TotalInvoices DESC;

-- SET 2
-- 1)
SELECT
    Composer,
    AVG(Milliseconds) AS AvgDuration
FROM tracks
WHERE Milliseconds < 375000
  AND Composer IS NOT NULL
GROUP BY Composer
ORDER BY AvgDuration DESC;

-- 2)
SELECT
    Composer,
    AVG(Milliseconds) AS AvgDuration
FROM tracks
WHERE Composer IS NOT NULL
GROUP BY Composer
HAVING AVG(Milliseconds) < 375000
ORDER BY AvgDuration DESC;

-- 3)
SELECT
    BillingCountry,
    COUNT(*) AS TotalRecords
FROM invoices
GROUP BY BillingCountry
HAVING COUNT(*) < 10
ORDER BY TotalRecords ASC;

-- 4)
SELECT
    BillingCountry,
    COUNT(DISTINCT BillingCity) AS NumCities
FROM invoices
GROUP BY BillingCountry
HAVING COUNT(DISTINCT BillingCity) = 8;

-- 5)
SELECT
    BillingCountry,
    SUM(Total) AS TotalSum,
    COUNT(*) AS NumRecords
FROM invoices
WHERE strftime('%Y', InvoiceDate) = '2010'
GROUP BY BillingCountry
HAVING COUNT(*) > 5
ORDER BY TotalSum DESC;