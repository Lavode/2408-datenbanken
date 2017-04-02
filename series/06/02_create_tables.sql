-- Marcel Zauder, 16-124-836
-- Michael Senn,  16-126-880

DROP TABLE IF EXISTS HaeltBetreut;
DROP TABLE IF EXISTS Angestellte;
DROP TABLE IF EXISTS Vorlesungen;

CREATE TABLE Angestellte (
	-- Would like to use a sequence here, but doesn't fit well with the
	-- data we're given.
	PersonalNr  INTEGER      PRIMARY KEY,
	Name        VARCHAR(255) NOT NULL,
	Vorname     VARCHAR(255) NOT NULL,
	Telefon     VARCHAR(255) NOT NULL,
	-- Seriously? Column name containing a space?
	"akad Grad" VARCHAR(255) NOT NULL,
	-- Lacks normalization.
	Typ         VARCHAR(255) NOT NULL
)
;
INSERT INTO Angestellte (PersonalNr, Name, Vorname, Telefon, "akad Grad", Typ)
VALUES
  (123, 'Zauder', 'Peer',  '0123-1235',  'Prof. Dr.',                         'Professor'),
  (121, 'Prau',   'Hans',  '0123-1125',  'Prof. Dr. hc.mult. Dr. ing. habil', 'Professor'),
  (171, 'Main',   'Willi', '0121-1123',  'Dipl.-Inf.',                        'Assistent'),
  (176, 'Meier',  'Hans',  '0123-1124',  'Dipl.-Math.',                       'Assistent'),
  (178, 'Meier',  'Georg', '0123-83646', 'M.sc.',                             'Assistent'),
  (179, 'Meier',  'Karl',  '0123-32546', 'M.sc.',                             'SHK')
;

CREATE TABLE Vorlesungen (
	-- Would like to use a sequence here, but doesn't fit well with the
	-- data we're given.
	VorlesungsNr INTEGER      PRIMARY KEY,
	Titel        VARCHAR(255) NOT NULL,
	ECTS         INTEGER      NOT NULL,
	Semester     Varchar(6)   NOT NULL
)
;
INSERT INTO Vorlesungen (VorlesungsNr, Titel, ECTS, Semester)
VALUES
  (121, 'Programmieren',    4, 'hs10'),
  (124, 'Datenbanken',      4, 'fs10'),
  (128, 'Datenbanken',      4, 'fs11'),
  (123, 'Programmieren',    4, 'hs11'),
  (127, 'Programmieren',    4, 'hs12'),
  (129, 'Datenbanken',      4, 'fs12'),
  (135, 'Automatentheorie', 4, 'fs14')
;

-- What kinda name is this?
CREATE TABLE HaeltBetreut (
	VorlesungsNr INTEGER NOT NULL,
	PersonalNr   INTEGER NOT NULL,

	PRIMARY KEY (VorlesungsNr, PersonalNr),

	FOREIGN KEY (VorlesungsNr)
	REFERENCES  Vorlesungen (VorlesungsNr)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	FOREIGN KEY (PersonalNr)
	REFERENCES Angestellte (PersonalNr)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)
;
INSERT INTO HaeltBetreut (VorlesungsNr, PersonalNr)
VALUES
  (121, 121),
  (124, 123),
  (128, 121),
  (123, 123),
  (127, 123),
  (129, 121),
  (135, 121),
  (121, 171),
  (121, 176),
  (127, 178),
  (129, 176),
  (135, 171)
;
