SELECT DISTINCT filiale.filialleiter

FROM lieferant

INNER JOIN artikel
        ON artikel.lid = lieferant.lid

INNER JOIN filiale
        ON filiale.fid = artikel.fid

WHERE lieferant.name = 'Druckwerk Trallala'
;


SELECT DISTINCT kunde.*

FROM lieferant

JOIN artikel
  ON artikel.lid = lieferant.lid

JOIN kauft
  ON kauft.aid = artikel.aid

JOIN kunde
  ON kunde.kid = kauft.kid

WHERE lieferant.land != 'Schweiz';


SELECT DISTINCT kunde.*

FROM lieferant

JOIN bietetan
  ON bietetan.lid = lieferant.lid

JOIN artikeltyp
  ON artikeltyp.typid = bietetan.typid

JOIN artikel
  ON artikel.typid = artikeltyp.typid

JOIN kauft
  ON kauft.aid = artikel.aid

JOIN kunde
  ON kunde.kid = kauft.kid

WHERE lieferant.land = 'Schweiz'
;


SELECT artikeltyp.bezeichnung,
       COUNT(1)

FROM artikel

JOIN artikeltyp
  ON artikeltyp.typid = artikel.typid

WHERE artikel.fid IS NULL

GROUP BY artikeltyp.typid
;


SELECT kunde.kid,
       SUM(artikeltyp.preis)

FROM kunde

JOIN kauft
  ON kauft.kid = kunde.kid

JOIN artikel
  ON artikel.aid = kauft.aid

JOIN artikeltyp
  ON artikeltyp.typid = artikel.typid

GROUP BY kunde.kid

ORDER BY kunde.kid
;


SELECT DISTINCT ON (bietetan.typid)
                   lieferant.*

FROM artikeltyp

JOIN bietetan
  ON bietetan.typid = artikeltyp.typid

JOIN lieferant
  ON lieferant.lid = bietetan.lid

WHERE artikeltyp.typid IN (
	SELECT artikel.typid

	FROM artikel

	WHERE artikel.fid IS NOT NULL

	GROUP BY artikel.typid

	HAVING COUNT(1) < 400
)

ORDER BY bietetan.typid,
         bietetan.angebotspreis ASC
;
