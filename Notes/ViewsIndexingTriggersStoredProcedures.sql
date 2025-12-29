/* 
VIEWS
- a vritaul table, the contents of which are defined by the query
- has a set of columns and records, but does not exists as a stored set of data
    - acts as filter on top of referenced tables
-  can also act as a security feature, hiding access to some data in a table 
*/

-- basically creating a copy of another table
CREATE VIEW vFILMActorNames AS
SELECT DISTINCT Title, CONCAT(first_name,"", last_name)Actor
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id;

-- can also DROP and ALTER views
ALTER VIEW vFILMActorNames AS
SELECT DISTINCT Title, CONCAT(first_name,"", last_name)Actor
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id;
DROP VIEW vFilmActorNames;

/* 
INDEXING
- data structure that makes searching faster for a specifc column in a database
- data structure usually a b+ or hash table but it can be any other logic strutcure
- index minimizes disk accesses and quickly locates record you are searching for

- pros: sped up searches/more useful the larger the stored data becomes
- cons: need extra space to place the index

- RDBMS Systems use 2 types of indexes depending on what they are optimized for
- Indexing using hash tables
    - utilizes a hash table to optimize direct searches on some column of our database
    - direct way to find it without seaching every row
- Indexing using B+ tree index
    - utilizes tree structure to organize references to where data is stored on disk
*/

-- indexing in MYSQL
SELECT f.special_features, COUNT(*)
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
WHERE f.description IS NOT NULL
GROUP BY f.special_features;

CREATE INDEX sf_index ON film(special_features);