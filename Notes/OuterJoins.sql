-- review of other joins
    -- natural joins: join 2 tuple if they have an attribute with same name and same value
    -- theta/inner joins: join 2 tuples on some condition 
    -- cross join: join all possible combos of 2 tuples
-- OUTER JOINS-------
-- a join that can optionally return a tuple even if it finds no match in other table on any condition 
-- 3 kinds of outer joins
    -- left, right, full outer join

-- LEFT JOIN: join that will always return all rows from the left table
    -- if match on condition is found on right table, it will pair up the 2 tuples
-- RIGHT JOIN: same thing vice versa
-- OUTER JOIN: return all tuples from all rows matching up tuples where possible and filling in null values where not 

-- SQL example using left and right joins
-- want to get all info about films and how many invenstories these films are in
-- if film is in no inventory, we still want a record for it
SELECT f.film_id, i.inventory_id
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id;

-- show films that are not stocked in any inventory
SELECT f.film_id, i.inventory_id
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

-- MySQL does not support full outer joins using common synatx so we must union a left and right join
SELECT x
FROM table1
LEFT JOIN table2
UNION
SELECT x
FROM table1
RIGHT JOIN table2;

-- joins review
-- INNER joins for when you only want to view info that matches some join codition on both tables
-- LEFT/RIGHT joins for when you want to see all records of one table reagrdless fo join condition, and find its matching record of it exists
-- FULL OUTER JOIN when you want to see all records from both tables
