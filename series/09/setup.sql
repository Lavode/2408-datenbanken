DROP VIEW IF EXISTS LieblingsFutter;
DROP VIEW IF EXISTS cheapest_seller_per_food;
DROP VIEW IF EXISTS favourite_food_per_species;
DROP VIEW IF EXISTS food_per_species;

DROP TABLE IF EXISTS mag;
DROP TABLE IF EXISTS Haustiere;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS verkauft;
DROP TABLE IF EXISTS Futter;
DROP TABLE IF EXISTS Hersteller;

CREATE TABLE Hersteller (
	h_pkey INTEGER PRIMARY KEY,
	name VARCHAR(10) NOT NULL,
	adresse VARCHAR(14)
);

CREATE TABLE Futter (
	f_pkey INTEGER PRIMARY KEY,
	name VARCHAR(10) NOT NULL
);

CREATE TABLE verkauft (
	f_pkey INTEGER REFERENCES Futter NOT NULL,
	h_pkey INTEGER REFERENCES Hersteller NOT NULL,
	preis DECIMAL(4,2),
	PRIMARY KEY (f_pkey,h_pkey)
);

CREATE TABLE Person (
	p_pkey INTEGER PRIMARY KEY,
	name VARCHAR(10) NOT NULL
);

CREATE TABLE Haustiere (
	ha_pkey INTEGER PRIMARY KEY,
	name VARCHAR(10) NOT NULL,
	gewicht DECIMAL(8,3), --kg
	art VARCHAR(10) NOT NULL,
	p_pkey INTEGER REFERENCES Person
);

CREATE TABLE mag (
	ha_pkey INTEGER REFERENCES Haustiere NOT NULL,
	f_pkey INTEGER REFERENCES Futter NOT NULL,
	grad DECIMAL(3,1),
	PRIMARY KEY (ha_pkey,f_pkey)
);

