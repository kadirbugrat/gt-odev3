CREATE TABLE Country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Lig (
    id SERIAL PRIMARY KEY,
    adı VARCHAR(255) NOT NULL,
    id_country INT REFERENCES Country(id)
);

CREATE TABLE Takim (
    id SERIAL PRIMARY KEY,
    adı VARCHAR(255) NOT NULL,
    id_league INT REFERENCES Lig(id),
    kuruluş_yılı INT NOT NULL,
    attığı_gol INT NOT NULL,
    yediği_gol INT NOT NULL,
    puan INT NOT NULL,
    seviye INT NOT NULL
);

CREATE TABLE Oyuncu (
    id SERIAL PRIMARY KEY,
    adı VARCHAR(255) NOT NULL,
    soyadı VARCHAR(255) NOT NULL,
    id_team INT REFERENCES Takim(id),
    id_country INT REFERENCES Country(id),
    attığı_gol INT NOT NULL
);
-- Ülkeleri ekleyelim
INSERT INTO Country (name) VALUES
    ('Türkiye'),
    ('İspanya'),
    ('İngiltere');

-- Ligleri ekleyelim (Türkiye'ye ait 2 lig olduğunu varsayalım)
INSERT INTO Lig (adı, id_country) VALUES
    ('Süper Lig', 1),
    ('1. Lig', 1),
    ('La Liga', 2),
    ('Premier League', 3);

-- Takımları ekleyelim (Örnek verilerle)
INSERT INTO Takim (adı, id_league, kuruluş_yılı, attığı_gol, yediği_gol, puan, seviye) VALUES
    ('Galatasaray', 1, 1905, 50, 25, 75, 1),
    ('Fenerbahçe', 1, 1907, 55, 30, 68, 1),
    ('Real Madrid', 3, 1902, 60, 20, 80, 1),
    ('Manchester United', 4, 1878, 55, 18, 78, 1);

-- Oyuncuları ekleyelim (Örnek verilerle)
INSERT INTO Oyuncu (adı, soyadı, id_team, id_country, attığı_gol) VALUES
    ('Arda', 'Turan', 1, 1, 10),
    ('Alex', 'de Souza', 1, 1, 25),
    ('Lionel', 'Messi', 3, 2, 30),
    ('Cristiano', 'Ronaldo', 3, 2, 28),
    ('Steven', 'Gerrard', 4, 3, 22),
    ('Wayne', 'Rooney', 4, 3, 24);
SELECT * FROM Lig
WHERE id_country = (SELECT id FROM Country WHERE name = 'Türkiye');

SELECT * FROM Takim
WHERE id_league IN (SELECT id FROM Lig WHERE id_country = (SELECT id FROM Country WHERE name = 'Türkiye'));

SELECT * FROM Takim
WHERE id_league = (
    SELECT id FROM Lig
    WHERE id_country = (SELECT id FROM Country WHERE name = 'Türkiye')
    ORDER BY seviye ASC
    LIMIT 1
)
ORDER BY puan DESC;

SELECT L.adı AS "Lig Adı", AVG(T.puan) AS "Ortalama Puan"
FROM Takim T
JOIN Lig L ON T.id_league = L.id
WHERE L.id_country = (SELECT id FROM Country WHERE name = 'Türkiye')
GROUP BY L.adı;

SELECT * FROM Takim
WHERE attığı_gol < yediği_gol;


SELECT T.id, T.adı AS "Takım Adı", SUM(O.attığı_gol) AS "Toplam Oyuncu Golü", T.attığı_gol AS "Takım Golü"
FROM Takim T
JOIN Oyuncu O ON T.id = O.id_team
GROUP BY T.id, T.adı, T.attığı_gol;


SELECT O.adı, O.soyadı, T.adı AS "Takım Adı", C.name AS "Nereli"
FROM Oyuncu O
JOIN Takim T ON O.id_team = T.id
JOIN Country C ON O.id_country = C.id
WHERE T.id_league = LIG_ID
ORDER BY O.attığı_gol DESC
LIMIT 1;

