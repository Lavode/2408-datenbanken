-- Marcel Zauder, 16-124-836
-- Michael Senn,  16-126-880

DROP TABLE IF EXISTS "hat-bei";

ALTER TABLE Haustier DROP CONSTRAINT haustier_pid_fkey;
DROP TABLE IF EXISTS Halter;
DROP TABLE IF EXISTS Aufpasser;
DROP TABLE IF EXISTS Person;

DROP TABLE IF EXISTS FutterHaustier;
DROP TABLE IF EXISTS Futter;

DROP TABLE IF EXISTS Hund;
DROP TABLE IF EXISTS Katze;
DROP TABLE IF EXISTS Haustier;

DROP TABLE IF EXISTS Kamin;
DROP TABLE IF EXISTS Karton;
DROP TABLE IF EXISTS Laptop;
DROP TABLE IF EXISTS Lieblingsplatz;

/* NOTE
 * > The Person - Halter - Haustier relation which is part of the requirements
 *   implies that a person can at most have one pet. (Person : Halter is 1:1,
 *   Halter : Haustier is 1:1)

 * > The expected solution is a poor implementation of disjoint subtypes 
 *   Downsides of this solution are:
 *   - Usage of non-supported CHECK constraints to ensure that e.g. an animal
 *     is either cat or dog, not both.
 *   - Each added subtype requiring one new check on each subtype's table
 * 
 *   A better solution would be - using the example of various types of animal:
 *   - Introduce an AnimalType table
 *   - Use an Animal table with:
 *     - animal_id, animal_type columns
 *     - (animal_id, animal_type) PK
 *     - animal_type -> AnimalType FK
 *   - Use one table per subtype with:
 *     - animal_id, animal_type columns, with animal_type *fixed per table*
 *     - animal_id PK
 *     - (animal_id, animal_type) -> Animal FK
 *
 *   Such a solution ensures disjointness with basic and well-supported SQL
 *   features alone, and can easily be extended with new subtypes.
 *
 * > The "Every animal has at least one haunt", and "every animal has at least
 *   one food it likes" would likely require the use of triggers in order to
 *   implement within PostgreSQL.
 */

CREATE TABLE Lieblingsplatz (
	lid SERIAL PRIMARY KEY
)
;

CREATE TABLE Kamin (
	lid      INTEGER      PRIMARY KEY,
	Material VARCHAR(64) NOT NULL,

	/* Ensure disjointedness. Mind that this is not valid in Postgres - check remark at top of file. */
	/* CHECK ((SELECT COUNT(1) FROM Karton WHERE Karton.lid = lid) = 0), */
	/* CHECK ((SELECT COUNT(1) FROM Laptop WHERE Laptop.lid = lid) = 0), */

	FOREIGN KEY (lid)
	  REFERENCES Lieblingsplatz (lid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;

CREATE TABLE Karton (
	lid INTEGER PRIMARY KEY,

	/* Ensure disjointedness. Mind that this is not valid in Postgres - check remark at top of file. */
	/* CHECK ((SELECT COUNT(1) FROM Kamin  WHERE Kamin.lid = lid)  = 0), */
	/* CHECK ((SELECT COUNT(1) FROM Laptop WHERE Laptop.lid = lid) = 0), */

	FOREIGN KEY (lid)
	  REFERENCES Lieblingsplatz (lid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;

CREATE TABLE Laptop (
	lid           INTEGER     PRIMARY KEY,
	Hersteller    VARCHAR(64) NOT NULL,
	Kennzeichnung VARCHAR(64)     NULL /* NULL if unknown */,

	/* Ensure disjointedness. Mind that this is not valid in Postgres - check remark at top of file. */
	/* CHECK ((SELECT COUNT(1) FROM Kamin  WHERE Kamin.lid = lid)  = 0), */
	/* CHECK ((SELECT COUNT(1) FROM Karton WHERE Karton.lid = lid) = 0), */

	FOREIGN KEY (lid)
	  REFERENCES Lieblingsplatz (lid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;


CREATE TABLE Haustier (
	hid      SERIAL      PRIMARY KEY,
	pid      INTEGER     NOT NULL,
	Name     VARCHAR(64) NOT NULL,
	GebTag   INTEGER     NOT NULL
	  CHECK (GebTag >= 1 AND GebTag <= 31),
	GebMonat INTEGER     NOT NULL
	  CHECK (GebMonat >= 1 AND GebMonat <= 12),
	GebJahr  INTEGER     NOT NULL /* Negative values are BC, positive AD */

	/* Ensure every animal has at least one haunt.
	 * Mind that this is not valid in Postgres, due to a) subqueries in
	 * CHECK constraint, and b) CHECK not being deferrable. Instead, this
	 * would likely have to be realised as a trigger.
	 * , CHECK DEFERRED ((SELECT COUNT(1) FROM "hat-bei" WHERE "hat-bei".hid = hid) >= 1)
	 */

	/* Ensure every animal has at least one food it likes.
	 * Mind that this is not valid in Postgres, due to a) subqueries in
	 * CHECK constraint, and b) CHECK not being deferrable. Instead, this
	 * would likely have to be realised as a trigger.
	 * , CHECK DEFERRED ((SELECT COUNT(1) FROM FutterHaustier WHERE FutterHaustier.hid = hid) >= 1)
	 */
)
;

CREATE TABLE Hund (
	hid   INTEGER     PRIMARY KEY,
	Rasse VARCHAR(64) NOT NULL,

	/* Ensure disjointedness. Mind that this is not valid in Postgres - check remark at top of file. */
	/* CHECK ((SELECT COUNT(1) FROM Katze WHERE Katze.hid = hid) = 0), */

	FOREIGN KEY (hid)
	  REFERENCES Haustier (hid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;

CREATE TABLE Katze (
	hid       INTEGER     PRIMARY KEY,
	Dominanz  INTEGER         NULL /* NULL if unkown */,
	Fellfarbe VARCHAR(64) NOT NULL,

	/* Ensure disjointedness. Mind that this is not valid in Postgres - check remark at top of file. */
	/* CHECK ((SELECT COUNT(1) FROM Hund WHERE Hund.hid = hid) = 0), */

	FOREIGN KEY (hid)
	  REFERENCES Haustier (hid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;


CREATE TABLE Futter (
	fid        SERIAL PRIMARY KEY,
	Hersteller VARCHAR(64) NOT NULL,
	Name       VARCHAR(64) NOT NULL,

	UNIQUE (Hersteller, Name)
)
;

CREATE TABLE FutterHaustier (
	fid INTEGER NOT NULL,
	hid INTEGER NOT NULL,

	PRIMARY KEY (fid, hid),

	FOREIGN KEY (fid)
	  REFERENCES Futter (fid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE,

	FOREIGN KEY (hid)
	  REFERENCES Haustier (hid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;


CREATE TABLE Person (
	pid     SERIAL      PRIMARY KEY,
	Name    VARCHAR(64) NOT NULL,
	Wohnort VARCHAR(64) NOT NULL
)
;

CREATE TABLE Halter (
	pid INTEGER     PRIMARY KEY,
	hid INTEGER     NOT NULL,
	Typ VARCHAR(64) NOT NULL,

	FOREIGN KEY (pid)
	  REFERENCES Person (pid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE,

	FOREIGN KEY (hid)
	  REFERENCES Haustier (hid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;

/* Ensure 1:1 between Haustier and Halter */
ALTER TABLE Haustier
  ADD FOREIGN KEY (pid)
  REFERENCES Halter (pid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
;

CREATE TABLE Aufpasser (
	pid         INTEGER PRIMARY KEY,
	Stundenlohn INTEGER, /* NULL in case of volunteers */

	FOREIGN KEY (pid)
	  REFERENCES Person (pid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;


/* Great example of how not to name your tables */
CREATE TABLE "hat-bei" (
	hid INTEGER NOT NULL,
	pid INTEGER NOT NULL,
	lid INTEGER NOT NULL,

	PRIMARY KEY (hid, pid),

	FOREIGN KEY (hid)
	  REFERENCES Haustier (hid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE,

	FOREIGN KEY (pid)
	  REFERENCES Person (pid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE,

	FOREIGN KEY (lid)
	  REFERENCES Lieblingsplatz (lid)
	  ON UPDATE CASCADE
	  ON DELETE CASCADE
)
;
