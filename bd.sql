-- EXERCISE &


SELECT * FROM rental WHERE return_date IS NULL;

SELECT customer.first_name, customer.last_name, COUNT(*) as num_rentals_not_returned FROM rental JOIN customer ON rental.customer_id = customer.customer_id WHERE rental.return_date IS NULL GROUP BY customer.customer_id;

SELECT film.title
FROM film
    JOIN film_actor ON film.film_id = film_actor.film_id
    JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE
    film.rating = 'R'
    AND actor.first_name = 'Joe'
    AND actor.last_name = 'Swank'
    AND film.special_features LIKE '%Action%';

CREATE VIEW JOE_SWANK_MOVIES AS 
	SELECT film.title
	FROM film
	    JOIN film_actor ON film.film_id = film_actor.film_id
	    JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE
	    actor.first_name = 'Joe'
	    AND actor.last_name =
'SWANK'; 

SELECT title
FROM joe_swank_movies
WHERE
    special_features LIKE '%Action%';

    -- EXERCISE 2

    SELECT
    COUNT(*) AS store_count,
    city,
    country
FROM store
GROUP BY city, country;

SELECT
    SUM(inventory.length) AS total_hours,
    store.store_id
FROM inventory
    JOIN store ON inventory.store_id = store.store_id
    LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id AND rental.return_date IS NULL
WHERE rental.rental_id IS NULL
GROUP BY store.store_id;

SELECT
    store.store_id,
    store.city,
    store.country,
    SUM(inventory.length) as total_viewing_time_minutes,
    SUM(inventory.length) / 60 as total_viewing_time_hours,
    SUM(inventory.length) / (60 * 24) as total_viewing_time_days
FROM store
    JOIN inventory ON store.store_id = inventory.store_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE
    rental.return_date IS NOT NULL
GROUP BY store.store_id;

SELECT
    customer.first_name,
    customer.last_name,
    customer.email,
    city,
    country
FROM customer
    JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
WHERE city IN (
        SELECT DISTINCT city
        FROM store
    );

    SELECT
    customer.first_name,
    customer.last_name,
    customer.email,
    country
FROM customer
    JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
WHERE country IN (
        SELECT DISTINCT country
        FROM store
    );

CREATE VIEW SAFE_MOVIES AS 
	SELECT *
	FROM film
	WHERE category_id != (
	        SELECT category_id
	        FROM category
	        WHERE
	            name = 'Horror'
	    )
	    AND (
	        LOWER(description) NOT LIKE '%beast%'
	        AND LOWER(description) NOT LIKE '%monster%'
	        AND LOWER(description) NOT LIKE '%ghost%'
	        AND LOWER(description) NOT LIKE '%dead%'
	        AND LOWER(description) NOT LIKE '%zombie%'
	        AND LOWER(description) NOT LIKE '%undead%'
	        AND LOWER(title) NOT LIKE '%beast%'
	        AND LOWER(title) NOT LIKE '%monster%'
	        AND LOWER(title) NOT LIKE '%ghost%'
	        AND LOWER(title) NOT LIKE '%dead%'
	        AND LOWER(title) NOT LIKE '%zombie%'
	        AND LOWER(title) NOT LIKE '%undead%'
	    );

SELECT
    SUM(length) AS total_hours
FROM inventory
    JOIN film ON inventory.film_id = film.film_id
    JOIN safe_movies ON film.film_id = safe_movies.film_id
GROUP BY inventory.store_id;

SELECT SUM(
        EXTRACT(
            MINUTE
            FROM
                length
        )
    ) / 60.0 AS total_hours,
    SUM(
        EXTRACT(
            MINUTE
            FROM
                length
        )
    ) / (60.0 * 24) AS total_days
FROM inventory
WHERE NOT EXISTS (
        SELECT *
        FROM rental
        WHERE
            inventory.inventory_id = rental.inventory_id
            AND rental.return_date IS NULL
    )
    AND rating IN ('G', 'PG', 'PG-13', 'R') -- Liste sûre
SELECT SUM(
        EXTRACT(
            MINUTE
            FROM
                length
        )
    ) / 60.0 AS total_hours,
    SUM(
        EXTRACT(
            MINUTE
            FROM
                length
        )
    ) / (60.0 * 24) AS total_days
FROM inventory
WHERE NOT EXISTS (
        SELECT *
        FROM rental
        WHERE
            inventory.inventory_id = rental.inventory_id
            AND rental.return_date IS NULL
    )
    AND rating IN ('G', 'PG', 'PG-13', 'R')
    AND (
        category != 'Horror'
        AND (
            title NOT ILIKE '%beast%'
            AND title NOT ILIKE '%monster%'
            AND title NOT ILIKE '%ghost%'
            AND title NOT ILIKE '%dead%'
            AND title NOT ILIKE '%zombie%'
            AND title NOT ILIKE '%undead%'
            AND description NOT ILIKE '%beast%'
            AND description NOT ILIKE '%monster%'
            AND description NOT ILIKE '%ghost%'
            AND description NOT ILIKE '%dead%'
            AND description NOT ILIKE '%zombie%'
            AND description NOT ILIKE '%undead%'
        )
    );
