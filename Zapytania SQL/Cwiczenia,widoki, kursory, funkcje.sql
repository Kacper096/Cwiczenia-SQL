CREATE VIEW HierarchiaPrac 
AS
	(SELECT Pracownik, Szef
	FROM (SELECT (PR.Imi� + ' ' + PR.Nazwisko) AS Pracownik,
		   (SZ.Imi� + ' '+ SZ.Nazwisko) AS Szef
	FROM
		(SELECT Imi�,Nazwisko, Szef
		 FROM Pracownicy) AS PR
	   LEFT OUTER JOIN 
		(SELECT Imi�,Nazwisko, IDpracownika
		 FROM Pracownicy) AS SZ
	   ON PR.Szef = SZ.IDpracownika
	GROUP BY PR.Imi�, PR.Nazwisko, SZ.Imi�, SZ.Nazwisko) AS [Hierarchy])
GO

WITH Bakalie AS
(
	SELECT p.IDproduktu, K.NazwaKategorii, p.CenaJednostkowa
	FROM mg.Produkty AS p
	INNER JOIN mg.Kategorie AS K ON p.IDkategorii = K.IDkategorii
	WHERE K.NazwaKategorii = 'Przyprawy'

)
SELECT * FROM Bakalie


SELECT Pracownik, 'Jestem szefem' AS [Szef] 
FROM dbo.HierarchiaPrac
WHERE Szef IS NULL

UNION ALL

SELECT Pracownik, Szef
FROM dbo.HierarchiaPrac
WHERE Szef IS NOT NULL

