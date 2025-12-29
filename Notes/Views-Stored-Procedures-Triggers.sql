-- 1)
CREATE OR REPLACE VIEW films_2006_A AS
SELECT film_id, title, release_year, rating, description
FROM film
WHERE release_year = 2006
  AND title LIKE 'A%';

-- 2)
SELECT * FROM films_2006_A;

-- 3)
DROP TABLE IF EXISTS rating_log;

CREATE TABLE rating_log (
    user VARCHAR(50),
    action VARCHAR(120)
);

DROP TRIGGER IF EXISTS after_film_insert;

DELIMITER $$
CREATE TRIGGER after_film_insert
AFTER INSERT ON film
FOR EACH ROW
BEGIN
    IF NEW.rating = 'R' THEN
        INSERT INTO rating_log (user, action)
        VALUES (CURRENT_USER(), CONCAT('Inserted R-rated movie: ', NEW.title));
    END IF;
END $$
DELIMITER ;

-- 4)
INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
VALUES ('A Reckless Adventure', 'An adventurous R-rated movie.', 2006, 1, 6, 2.99, 120, 19.99, 'R');

SELECT * FROM rating_log;

-- 5)
DROP PROCEDURE IF EXISTS get_movie_year;

DELIMITER $$
CREATE PROCEDURE get_movie_year (
    IN in_title VARCHAR(255),
    OUT out_release_year YEAR
)
BEGIN
    SELECT release_year INTO out_release_year
    FROM film
    WHERE title = in_title
    LIMIT 1;
END $$
DELIMITER ;

-- 6)
CALL get_movie_year('A Reckless Adventure', @movie_year);
SELECT @movie_year AS release_year;