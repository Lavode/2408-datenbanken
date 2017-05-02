-- Marcel Zauder, 16-124-836
-- Michael Senn,  16-126-880

-- DB used: fs17_m.senn1_s06

DELETE FROM mag;
DELETE FROM verkauft;

DELETE FROM haustiere;
DELETE FROM person;

DELETE FROM futter;
DELETE FROM hersteller;

INSERT INTO futter (f_pkey, name)
VALUES
  (1, 'Whiskas'),
  (2, 'Sheba'),
  (3, 'M-Budget')
;

INSERT INTO hersteller (h_pkey, name)
VALUES
  (1, 'Migros'),
  (2, 'Nestle')
;

INSERT INTO verkauft (f_pkey, h_pkey, preis)
VALUES
  (3, 1, 5.5),
  (1, 1, 2.5),
  (3, 2, 4.5)
;

INSERT INTO person (p_pkey, name)
VALUES
  (1, 'Michael'),
  (2, 'Pascal'),
  (3, 'Marcel')
;

INSERT INTO haustiere (ha_pkey, name, art, p_pkey)
VALUES
  (1, 'Fido',  'Hund',  2),
  (2, 'Siva',  'Katze', 1),
  (3, 'Max',   'Hund',  3),
  (4, 'Buddy', 'Hund',  3),
  (5, 'Tiny',  'Katze', 1)
;

INSERT INTO mag (ha_pkey, f_pkey, grad)
VALUES
  (1, 1, 0.1),
  (1, 3, 0.5),

  (2, 1, 0),
  (2, 2, 1),
  (2, 3, 0.8),

  (3, 1, 0.3),
  (3, 3, 0.2),

  (5, 1, 0.4),
  (5, 2, 0.7),
  (5, 3, 0.9)
;
