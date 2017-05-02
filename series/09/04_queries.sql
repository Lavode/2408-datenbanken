-- Marcel Zauder, 16-124-836
-- Michael Senn,  16-126-880

-- DB used: fs17_m.senn1_s06

-- Manufacturer of food 'Stroh'
SELECT hersteller.*

FROM futter

JOIN verkauft
USING (f_pkey)

JOIN hersteller
USING (h_pkey)

WHERE futter.name = 'Stroh'
;


-- Pets without owner
SELECT *

FROM haustiere

WHERE p_pkey IS NULL
;


-- Pets which like all sampled food equally
SELECT *

FROM haustiere

WHERE ha_pkey IN (
	SELECT mag.ha_pkey
	FROM mag
	GROUP BY ha_pkey
	HAVING max(grad) = min(grad)
)
;



-- Pets grouped by (food, liking), i.e. two pets which like food A equally will
-- be in the same group.
SELECT array_agg(haustiere.name) AS "Haustiere",
       futter.name               AS "Futter",
       mag.grad                  AS "Gemeinsame Bewertung"

FROM mag

JOIN haustiere
USING (ha_pkey)

JOIN futter
USING (f_pkey)

GROUP BY futter.f_pkey,
         grad
;
