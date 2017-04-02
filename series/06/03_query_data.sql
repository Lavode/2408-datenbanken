-- Marcel Zauder, 16-124-836
-- Michael Senn,  16-126-880

SELECT Angestellte.*

FROM Vorlesungen

LEFT JOIN HaeltBetreut
       ON HaeltBetreut.VorlesungsNr = Vorlesungen.VorlesungsNr

LEFT JOIN Angestellte
       ON Angestellte.PersonalNr = HaeltBetreut.PersonalNr

WHERE Vorlesungen.Titel = 'Programmieren'
  AND Angestellte.Typ   = 'Assistent'
;


SELECT Titel,
       ECTS

FROM Vorlesungen

WHERE semester = 'fs11'
;


SELECT DISTINCT Vorlesungen.ECTS,
                Vorlesungen.Titel

FROM Vorlesungen

LEFT JOIN HaeltBetreut
       ON HaeltBetreut.VorlesungsNr = Vorlesungen.VorlesungsNr

LEFT JOIN Angestellte
       ON Angestellte.PersonalNr = HaeltBetreut.PersonalNr

WHERE Angestellte.Name = 'Zauder'
  AND Angestellte.Typ  = 'Professor'
;

