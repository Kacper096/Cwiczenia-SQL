CREATE VIEW HierarchiaPrac 
AS
	(SELECT Pracownik, Szef
	FROM (SELECT (PR.Imiê + ' ' + PR.Nazwisko) AS Pracownik,
		   (SZ.Imiê + ' '+ SZ.Nazwisko) AS Szef
	FROM
		(SELECT Imiê,Nazwisko, Szef
		 FROM Pracownicy) AS PR
	   LEFT OUTER JOIN 
		(SELECT Imiê,Nazwisko, IDpracownika
		 FROM Pracownicy) AS SZ
	   ON PR.Szef = SZ.IDpracownika
	GROUP BY PR.Imiê, PR.Nazwisko, SZ.Imiê, SZ.Nazwisko) AS [Hierarchy])
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

