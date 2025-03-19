-- Crear una nueva instancia de AWAS e instalar mysql server
-- Crear una base de datos  'sakila' con un usuario sakila@'%' (passwors que queramos)


-- Conectate desde el DBeaver al servdor con el usuario skaila
-- ejecuta salika-schema.sql y sakila-data.sql


-- Crear una vista que muestre:
-- Lista de clientes que haya alquilado al menos 3 peliculas de las 5 categorias más alquiladas.

CREATE VIEW mivista AS 
WITH categ5 AS (
    SELECT fc.category_id
    FROM film_category fc  
        JOIN film f USING(film_id)
        JOIN inventory USING(film_id)
        JOIN rental r USING(inventory_id)
    GROUP BY fc.category_id
    ORDER BY COUNT(fc.film_id) DESC
    LIMIT 5
)
SELECT r.customer_id
FROM rental r
   JOIN inventory i USING(inventory_id)
   JOIN film_category fc USING(film_id)
   JOIN categ5 c5 USING(category_id)
GROUP BY r.customer_id;


WITH categ5 AS(
   SELECT c.name, count(r.rental_id) mas_alquiladas
   FROM rental r 
      JOIN inventory i USING(inventory_id)
      JOIN film_category fc USING(film_id)
      JOIN category c USING(category_id)
   GROUP BY c.name 
   ORDER BY mas_alquiladas DESC
   LIMIT 5
)
SELECT r.customer_id
FROM rental r
   JOIN inventory i USING(inventory_id)
   JOIN film_category fc USING(film_id)
   JOIN categ5 c USING(category_id)
GROUP BY r.customer_id
HAVING COUNT(r.rental_id) >= 3;


SELECT c.name, count(r.rental_id) mas_alquiladas
FROM rental r 
   JOIN inventory i USING(inventory_id)
   JOIN film f USING(film_id)
   JOIN film_category fc USING(film_id)
   JOIN category c USING(category_id)
GROUP BY c.name 
ORDER BY mas_alquiladas DESC
LIMIT 5;


