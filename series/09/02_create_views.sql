DROP VIEW IF EXISTS LieblingsFutter;
DROP VIEW IF EXISTS cheapest_seller_per_food;
DROP VIEW IF EXISTS favourite_food_per_species;
DROP VIEW IF EXISTS food_per_species;

CREATE VIEW food_per_species AS (
	SELECT haustiere.art AS species,
	       futter.name   AS food,
	       avg(mag.grad) AS rating

	FROM mag

	JOIN haustiere
	  ON haustiere.ha_pkey = mag.ha_pkey

	JOIN futter
	  ON futter.f_pkey = mag.f_pkey

	GROUP BY haustiere.art, futter.f_pkey
)
;

CREATE VIEW favourite_food_per_species AS (
	WITH max_food_rating AS (
		SELECT MAX(rating),
		       species
		FROM food_per_species
		GROUP BY species
        )

	SELECT food_per_species.species,
	       food_per_species.food

	FROM food_per_species

	JOIN max_food_rating
	  ON food_per_species.species = max_food_rating.species
	 AND food_per_species.rating  = max_food_rating.max
)
;

CREATE VIEW cheapest_seller_per_food AS (
	SELECT DISTINCT ON (verkauft.f_pkey)
	                   futter.name     AS food,
			   verkauft.preis  AS price,
			   hersteller.name AS manufacturer

	FROM futter

	JOIN verkauft
	  ON verkauft.f_pkey = futter.f_pkey

	JOIN hersteller
	  ON hersteller.h_pkey = verkauft.h_pkey

	ORDER BY verkauft.f_pkey,
	         verkauft.preis ASC
)
;

CREATE VIEW LieblingsFutter AS (
	SELECT favourite_food_per_species.species    AS "Tierart",
	       favourite_food_per_species.food       AS "Futter",
	       cheapest_seller_per_food.manufacturer AS "Hersteller",
	       cheapest_seller_per_food.price        AS "Preis"

	FROM favourite_food_per_species

	LEFT JOIN cheapest_seller_per_food
	    USING (food)
)
;
