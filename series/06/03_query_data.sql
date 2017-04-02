SELECT a.*

FROM Vorlesungen AS v

LEFT JOIN HaeltBetreut AS hb
       ON hb.VorlesungsNr = v.VorlesungsNr

LEFT JOIN Angestellte AS a
       ON a.PersonalNr = hb.PersonalNr

WHERE v.Titel = 'Programmieren'
  AND a.Typ   = 'Assistent'
;


SELECT Titel,
       ECTS

FROM Vorlesungen

WHERE semester = 'fs11'
;


SELECT DISTINCT v.ECTS,
                v.Titel

FROM Vorlesungen AS v

LEFT JOIN HaeltBetreut AS hb
       ON hb.VorlesungsNr = v.VorlesungsNr

LEFT JOIN Angestellte AS a
       ON a.PersonalNr = hb.PersonalNr

WHERE a.Name = 'Zauder'
  AND a.Typ  = 'Professor'
;

