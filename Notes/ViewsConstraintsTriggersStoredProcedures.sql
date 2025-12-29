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