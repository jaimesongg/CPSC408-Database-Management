/* 
Joins: how we can combine attrubutes from multiple tables into a single output
- often used to return info about the relationships we identified when creating our database

Cross Product: every possible combination of each row of table 1 and table 2 resulting relaton will have every attribute from both tables
- ex: 
x y    w z       x y w z
3 5    2 9   =   3 5 2 9
3 7    1 6       3 5 1 6
       4 8       3 5 4 8
                 3 7 2 9
                 3 7 1 6
                 3 7 4 8

- num of rows = (# of rows in R1) x (# of rows in R2)
- num of cols = (# of cols in R1) + (# of cols in R2)
*/ 

-- cross product in sql -----------------------------
SELECT albums.Title, artists.Name -- when using more than one table in query use table.attribute syntax
FROM albums
CROSS JOIN arists; -- returns all combos of album title and artist name in database

-- this would result in the table having both patient.pID and procedure.pID
SELECT * 
FROM Patients
CROSS JOIN Procedures
WHERE Patients.pID = Procedures.pID

-- natural join ----------------------------
-- cross product with built in WHERE statement
    -- WHERE statement find column both tables have in common, only returns rows that have equal values in those columns
-- can only happen on tables with exactly one attribute in common with same exact name, can only join if two values in shared column are equal to each other
-- ex: Patients(pID, Name, Phone) | Procedures(pID, Doctor, Date)
-- results in table having one shared pID
SELECT *
FROM Patients
NATURAL JOIN Procedures

-- inner join (preferred method) ---------------------------------- 
-- similar to natural join, but you get to pick on what condition rows are filtered out of result
    -- join condition can be any expression that results in boolean true/false
SELECT albums.Title, artists.Name
FROM albums
INNER JOIN artists -- remember to specify what join you are doing
    ON albums.ArtistId = artists.ArtistId -- ON specifies join condition

-- can also rename tables during any FROM statements using AS operator
SELECT al.Title, ar.Name
FROM albums AS al
INNER JOIN artists AS ar
    ON al.ArtistId = ar.ArtistId;

-- practice
SELECT tracks.Name AS trackName, -- renaming attribute names
    albums.Title AS albumName
FROM tracks
INNER JOIN albums
    ON tracks.trackName = albums.albumTitle

SELECT t.Name
FROM tracks AS t
INNER JOIN genres AS g
    ON t.GenreId = g.GenreId
WHERE g.Name = 'Classical'
ORDER BY Milliseconds ASC 
LIMIT 10;

-- set operators -------------------------------------
/* allows us to combine rows from two different tables into one output
    where joins are how we combine based on columns, set combines tables based on rows
- UNION
- INTERSECT
- DIFFERENCE (EXCEPT)

- set operators never alter what attributes are on an output
    - join tables together if you want to add/remove attributes to output
    - set operators if you want to add/remove rows to output
*/

-- UNION: performs binary union between 2 relations 
    -- a union between 2 tables will append the rows of the second table to the bottom of the first table, and remove duplicates in the result
    --  tables need to be union compatible
        -- have same number of attributes
        -- domain (data type) of each attribute in first relation is same as corresponding attribute in second relation 

-- returns all artists where names are either AC/DC or Queen
SELECT *
FROM Artists 
WHERE Name = 'AC/DC'
UNION 
SELECT *
FROM Artists 
WHERE Name = 'Queen';

-- can compile similar data from different tables
    --  if tables have different attribute names, system will keep first tables attribute name
SELECT DISTINCT FirstName, LastName
FROM Customers
UNION 
SELECT DISTINCT FirstName, LastName -- order matters
FROM Employees;

-- UNION ALL: union where all duplicates are kept instead of removed 
    -- if record appears on both tables, it will appear as 2 rows of output
SELCT *
FROM Customers
WHERE FirstName LIKE 'A%'
UNION ALL
SELECT *
FROM Customers
WHERE LastName LIKE 'M%'

-- INTERSECT: performs binary intersection between 2 relations
    -- only return rows that exist on both tables
-- only returns songs both with name equal to 'Believe' and composer equal to 'James Iha'
SELECT *
FROM tracks
WHERE Name = 'Believe'
INTERSECT
SELECT *
FROM tracks
WHERE Composer = 'James Iha'

-- DIFFERENCE/EXCEPT: performs binary difference between 2 relations
    -- actively remove rows that exist on second table from results of first table
-- returns all songs named "Believe" made by any composer other than "James Iha"
SELECT *
FROM tracks
WHERE Name = 'Believe'
EXCEPT 
SELECT *
FROM tracks
WHERE Composer = 'James Iha';

-- gives list of all artists who do not have any albums out
SELECT ArtistId
FROM Artists
EXCEPT 
SELECT ArtistId
FROM Albums;

-- Order of Operations ---------------------------
SELECT
FROM
JOIN
WHERE 
GROUP BY
    HAVING
ORDER BY
LIMIT
UNION/INTERSECT/EXCEPT