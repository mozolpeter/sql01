CREATE TABLE Masolat (
    MemberID INT IDENTITY PRIMARY KEY,
    USERNEV nvarchar(40) MASKED WITH (Function = 'default()'),
    NEV nvarchar(100) MASKED WITH (Function = 'default()'),
    EMAIL nvarchar(120) MASKED WITH (Function = 'partial(1,"xxxxxxx",0)') DEFAULT 'random' UNIQUE,
    SZAML_CIM nvarchar(200) MASKED WITH (Function = 'default()'),
    SZUL_DAT date MASKED WITH (Function = 'default()')
);


INSERT INTO Masolat (USERNEV, NEV, EMAIL, SZAML_CIM, SZUL_DAT)
SELECT 
    'user' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR) AS USERNEV,
    'nev' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR) AS NEV,
    'email' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR) + '@example.com' AS EMAIL,
    'szaml_cim' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR) AS SZAML_CIM,
    DATEADD(day, ROW_NUMBER() OVER(ORDER BY (SELECT NULL)), '2000-01-01') AS SZUL_DAT
FROM Vendeg;

CREATE USER Pistike2 WITHOUT LOGIN;
GRANT SELECT ON Masolat TO Pistike2;


