# 1)
SELECT a.address_id
FROM address AS a
LEFT JOIN store AS s
    ON a.address_id = s.address_id
WHERE a.district = 'California'
    AND s.address_id IS NULL;

# 2)
SELECT
    f.title AS film_title,
    COUNT(DISTINCT i.store_id) AS num_of_stores
FROM
    film AS f
LEFT JOIN
    inventory AS i
    ON f.film_id = i.film_id
GROUP BY
    f.film_id, f.title
ORDER BY
    f.title;

# 3)
SELECT
    a.first_name AS actor_first_name,
    f.title AS film_title
FROM
    actor AS a
LEFT JOIN
    film_actor AS fa
    ON a.actor_id = fa.actor_id
LEFT JOIN
    film AS f
    ON fa.film_id = f.film_id
ORDER BY
    a.actor_id, f.title;

# 4)
SELECT
    a.actor_id,
    f.film_id
FROM
    actor AS a
LEFT JOIN
    film_actor AS fa
    ON a.actor_id = fa.actor_id
LEFT JOIN
    film AS f
    ON fa.film_id = f.film_id

UNION

SELECT
    a.actor_id,
    f.film_id
FROM
    film AS f
LEFT JOIN
    film_actor AS fa
    ON f.film_id = fa.film_id
LEFT JOIN
    actor AS a
    ON fa.actor_id = a.actor_id

ORDER BY
    actor_id, film_id;

# 5)
SELECT
    f.title AS film_title,
    f.rental_duration,
    (
        SELECT
            AVG(rental_duration)
        FROM
            film
    ) AS average_rental_duration
FROM
    film AS f
ORDER BY
    f.title;

# 6)
SELECT
    COUNT(*) AS categories_over_60
FROM
    (
        SELECT
            category_id,
            COUNT(film_id) AS film_count
        FROM
            film_category
        GROUP BY
            category_id
        HAVING
            COUNT(film_id) > 60
    ) AS sub;

# 7)
SELECT
    AVG(p.amount) AS average_payment_mexico
FROM
    payment AS p
WHERE
    p.customer_id IN (
        SELECT
            c.customer_id
        FROM
            customer AS c
        INNER JOIN
            address AS a
            ON c.address_id = a.address_id
        INNER JOIN
            city AS ci
            ON a.city_id = ci.city_id
        INNER JOIN
            country AS co
            ON ci.country_id = co.country_id
        WHERE
            co.country = 'Mexico'
    );

# 8)
SELECT
    a.first_name AS actor_first_name,
    f.title AS film_title
FROM
    actor AS a
LEFT JOIN
    film_actor AS fa
    ON a.actor_id = fa.actor_id
LEFT JOIN
    film AS f
    ON fa.film_id = f.film_id
ORDER BY
    a.actor_id, f.title;










