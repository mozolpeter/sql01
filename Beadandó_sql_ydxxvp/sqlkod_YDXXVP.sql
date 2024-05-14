--Táblák és kapcsolatok

CREATE TABLE Elado (
    EladoID INTEGER PRIMARY KEY,
    EladoNev VARCHAR(255),
    Email VARCHAR(255),
    Telefon VARCHAR(255)
);

CREATE TABLE Gyartok (
    GyartoID INTEGER PRIMARY KEY,
    GyartoNev VARCHAR(255),
    Orszag VARCHAR(255)
);

CREATE TABLE Vasarlok (
    VevoID INTEGER PRIMARY KEY,
    VevoNev VARCHAR(255),
    Email VARCHAR(255),
    Telefon VARCHAR(255)
);

CREATE TABLE Autok (
    CarID INTEGER PRIMARY KEY,
    Marka VARCHAR(255),
    Modell VARCHAR(255),
    Ev INTEGER,
    EladoID INTEGER,
    GyartoID INTEGER,
    FOREIGN KEY (EladoID) REFERENCES Elado(EladoID),
    FOREIGN KEY (GyartoID) REFERENCES Gyartok(GyartoID)
);

CREATE TABLE Vasarlas (
    AutoID INTEGER,
    VasarloID INTEGER,
    VasarlasIdopontja DATETIME,
    Ar DECIMAL,
    FOREIGN KEY (AutoID) REFERENCES Autok(CarID),
    FOREIGN KEY (VasarloID) REFERENCES Vasarlok(VevoID),
    PRIMARY KEY (AutoID, VasarloID)
);

--Adatokkal való feltöltésem
INSERT INTO Elado (EladoID, EladoNev, Email, Telefon)
VALUES 
    (1, 'Nagy Géza', 'nagy.geza@example.com', '+36123456799'),
    (2, 'Kiss Eszter', 'kiss.eszter@example.com', '+36123456800'),
    (3, 'Tóth István', 'toth.istvan@example.com', '+36123456801'),
    (4, 'Varga Katalin', 'varga.katalin@example.com', '+36123456802'),
    (5, 'Fekete Péter', 'fekete.peter@example.com', '+36123456803');

INSERT INTO Gyartok (GyartoID, GyartoNev, Orszag)
VALUES 
    (1, 'Toyota', 'Japán'),
    (2, 'Honda', 'Japán'),
    (3, 'Ford', 'Egyesült Államok'),
    (4, 'Tesla', 'Egyesült Államok'),
    (5, 'BMW', 'Németország');

INSERT INTO Vasarlok (VevoID, VevoNev, Email, Telefon)
VALUES 
    (1, 'Kovács Péter', 'kovacs@example.com', '+36123456789'),
    (2, 'Nagy Anna', 'nagy@example.com', '+36123456790'),
    (3, 'Szabó Gábor', 'szabo@example.com', '+36123456791'),
    (4, 'Kiss Éva', 'kiss@example.com', '+36123456792'),
    (5, 'Tóth László', 'toth@example.com', '+36123456793');

INSERT INTO Autok (CarID, Marka, Modell, Ev, EladoID, GyartoID)
VALUES 
    (1, 'Toyota', 'Corolla', 2020, 1, 1),
    (2, 'Honda', 'Civic', 2019, 2, 2),
    (3, 'Ford', 'Focus', 2018, 3, 3),
    (4, 'Tesla', 'Model S', 2021, 4, 4),
    (5, 'BMW', '3 Series', 2017, 5, 5);

INSERT INTO Vasarlas (AutoID, VasarloID, VasarlasIdopontja, Ar)
VALUES 
    (1, 1, '2024-05-10 10:00:00', 25000.00),
    (2, 2, '2024-05-11 11:30:00', 22000.00),
    (3, 3, '2024-05-12 13:45:00', 18000.00),
    (4, 4, '2024-05-13 15:20:00', 40000.00),
    (5, 5, '2024-05-14 09:15:00', 35000.00);


--Lekérdezések

--1, összes Autó listázása
SELECT * FROM Autok;

--2, Az összes eladó nevének és az általa eladott autók számának listázása

SELECT E.EladoNev, COUNT(A.CarID) AS EladottAuto
FROM Elado E
LEFT JOIN Autok A ON E.EladoID = A.EladoID
GROUP BY E.EladoNev;

--3, Az autók száma gyártó országonként

SELECT G.Orszag, COUNT(A.CarID) AS AutokSzama
FROM Gyartok G
LEFT JOIN Autok A ON G.GyartoID = A.GyartoID
GROUP BY G.Orszag;

--4, Kovács Péter álltal vásárolt autó
SELECT V.VevoNev, A.Marka, A.Modell
FROM Vasarlok V
JOIN Vasarlas VA ON V.VevoID = VA.VasarloID
JOIN Autok A ON VA.AutoID = A.CarID
WHERE V.VevoNev = 'Kovács Péter';

--5,Az átlagos vásárlásár minden eladóra lebontva
SELECT E.EladoNev, AVG(V.Ar) AS AtlagosVasarlasAr
FROM Elado E
JOIN Autok A ON E.EladoID = A.EladoID
JOIN Vasarlas V ON A.CarID = V.AutoID
GROUP BY E.EladoNev;

--6,Az autók száma gyártó szerint, az autók átlagos életkora 2020 előtt és után, a ez előttiek régebbi az utóbbiak újabb
SELECT G.GyartoNev, 
       SUM(CASE WHEN A.Ev <= 2020 THEN 1 ELSE 0 END) AS RegebbiAutokSzama,
       SUM(CASE WHEN A.Ev > 2020 THEN 1 ELSE 0 END) AS UjabbAutokSzama,
       AVG(2024 - A.Ev) AS AtlagosEletkor
FROM Gyartok G
JOIN Autok A ON G.GyartoID = A.GyartoID
GROUP BY G.GyartoNev;

--7 Azoknak az eladóknak a listája, akik 2024-ben több autót adtak el, mint 2023-ban.

SELECT E.EladoNev
FROM Elado E
JOIN Autok A ON E.EladoID = A.EladoID
JOIN Vasarlas V ON A.CarID = V.AutoID
WHERE YEAR(V.VasarlasIdopontja) = 2024
GROUP BY E.EladoNev
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM Vasarlas V2
    JOIN Autok A2 ON V2.AutoID = A2.CarID
    JOIN Elado E2 ON A2.EladoID = E2.EladoID
    WHERE YEAR(V2.VasarlasIdopontja) = 2023 AND E2.EladoID = E.EladoID
);
