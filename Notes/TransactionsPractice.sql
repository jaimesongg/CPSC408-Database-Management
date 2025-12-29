# 1) Prepare tables
DELETE film_actor
FROM film_actor
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name = 'Cuba';
SET autocommit = 0;

# 3) Transaction
START TRANSACTION;

# current state
SELECT * FROM actor;

# insert new actor
INSERT INTO actor(actor_id, first_name, last_name, last_update)
VALUES(999, 'NICOLE', 'STREEP', NOW());

# point in transaction you can roll back to
SAVEPOINT actor_savepoint;

# delete actor first names
DELETE FROM actor
WHERE first_name = 'CUBA';
SELECT * FROM actor;

# undoes everything after savepoint (restores CUBA)
ROLLBACK TO SAVEPOINT actor_savepoint;
SELECT * FROM actor;
COMMIT; # makes all changes permanent

# 4) How many actors resulted in select statements
# 200 actors, 198 actors, 201 actors
# 201 actors

# 5) autocommit
SET autocommit = 1;