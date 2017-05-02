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
