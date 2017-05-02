SELECT hersteller.*

FROM futter

JOIN verkauft
USING (f_pkey)

JOIN hersteller
USING (h_pkey)

WHERE futter.name = 'Stroh'
;


SELECT *

FROM haustiere

WHERE p_pkey IS NULL
;


SELECT *

FROM haustiere

WHERE ha_pkey IN (
	SELECT mag.ha_pkey
	FROM mag
	GROUP BY ha_pkey
	HAVING max(grad) = min(grad)
)
;


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
