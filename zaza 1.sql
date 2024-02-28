-- Listázzuk "laszlo2" vendég gyermek nélküli foglalásainak adatait!

--a. Egy új oszlopban jelenítsük meg, hogy a foglalás a nyári szezonban (június, július, augusztus) történt-e (Igen/Nem). 

--b. A foglalás dátumánál a METTOL oszlopot vegyük figyelembe
SELECT *, IIF(MONTH(METTOL) IN (6, 7, 8), 'Igen', 'NEM')   AS 'Nyári-e'
FROM Foglalas
WHERE UGYFEL_FK = 'laszlo2' AND GYERMEK_SZAM = 0 



--2
SELECT szh.TIPUS, 
        YEAR(f.METTOL) AS 'Év', 
        MONTH(f.METTOL) AS 'Hónap', 
        COUNT(*) AS 'Foglalások száma'
        --
FROM Foglalas f JOIN Szoba sz ON f.SZOBA_FK = sz.SZOBA_ID 
                JOIN Szallashely szh ON sz.SZALLAS_FK = szh.SZALLAS_ID--

WHERE DATEDIFF(DAY, f.METTOL, f.MEDDIG)>= 5

GROUP BY szh.TIPUS,     
    YEAR(f.METTOL), 
    MONTH(f.METTOL)
