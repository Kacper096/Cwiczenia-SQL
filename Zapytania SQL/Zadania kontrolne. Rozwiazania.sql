USE [NorthwindZajecia]
GO

/* 1. */
/* A */
SELECT CAST(Z.[DataZam�wienia] AS DATE) AS [Data], Z.[IDzam�wienia] AS [ID zam.]
FROM Zam�wienia AS Z
WHERE Z.[IDzam�wienia] = (SELECT TOP(1) PZ.[IDzam�wienia]
						  FROM PozycjeZamowienia AS PZ
						  GROUP BY PZ.IDzam�wienia
						  ORDER BY COUNT(PZ.[IDzam�wienia]) DESC);

/* B */ /* skorelowane */
SELECT TOP(1) CAST(Z.[DataZam�wienia] AS DATE) AS [Data], Z.[IDzam�wienia] AS [ID zam.]
FROM Zam�wienia AS Z 
LEFT JOIN PozycjeZamowienia AS PZ ON Z.[IDzam�wienia] = PZ.[IDzam�wienia]
GROUP BY Z.[DataZam�wienia], Z.[IDzam�wienia] 
HAVING COUNT(Z.[IDzam�wienia]) = (SELECT COUNT(PZ.[IDzam�wienia])
								  FROM PozycjeZamowienia AS PZ
								  WHERE PZ.[IDzam�wienia] = Z.[IDzam�wienia]
								  )
ORDER BY COUNT(Z.[IDzam�wienia]) DESC;
						  
		
/* 2 */
/* A */
SELECT (P.[Nazwisko] + ' ' + P.[Imi�]) AS [Nazwisko Imie], Z.[IDzam�wienia] AS [ID zam.]
FROM Pracownicy AS P
JOIN Zam�wienia AS Z ON Z.[IDpracownika] = P.[IDpracownika]
WHERE Z.[IDzam�wienia] = (SELECT  PZ.[IDzam�wienia]
						  FROM PozycjeZamowienia AS PZ
						  GROUP BY PZ.IDzam�wienia
						  ORDER BY COUNT(PZ.[IDzam�wienia]) DESC);
/* B */
SELECT TOP(1) (P.[Nazwisko] + ' ' + P.[Imi�]) AS [Nazwisko Imie], Z.[IDzam�wienia] AS [ID zam.]
FROM Pracownicy AS P
INNER JOIN Zam�wienia AS Z ON P.[IDpracownika] = Z.[IDpracownika]
INNER JOIN PozycjeZamowienia AS PZ ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
GROUP BY (P.[Nazwisko] + ' ' + P.[Imi�]),Z.[IDzam�wienia]
HAVING COUNT(Z.[IDzam�wienia]) = (SELECT COUNT(PZ.[IDzam�wienia])
								  FROM PozycjeZamowienia AS PZ
								  WHERE PZ.[IDzam�wienia] = Z.[IDzam�wienia]
								  )
ORDER BY COUNT(Z.[IDzam�wienia]) DESC;

/* 3 */
SELECT TOP(1) K.[NazwaFirmy], Z.[KrajOdbiorcy], (SELECT SUM(Ilo�� * CenaJednostkowa)
										 FROM PozycjeZamowienia AS PZ
										 WHERE Z.[IDzam�wienia] = PZ.[IDzam�wienia]) AS [Warto�� zam.]
FROM Klienci AS K
INNER JOIN Zam�wienia AS Z ON Z.[IDklienta] = K.[IDklienta]
ORDER BY [Warto�� zam.] DESC;

/* 4 */
SELECT K.[NazwaFirmy], (SELECT MAX(Z.[DataZam�wienia])
						FROM Zam�wienia AS Z 
						WHERE Z.[IDklienta] = K.[IDklienta]) AS [Ostatnie zam.]
FROM Klienci AS K
WHERE (
			SELECT MAX(Z.[DataZam�wienia])
			FROM Zam�wienia AS Z 
			WHERE Z.[IDklienta] = K.[IDklienta]
      ) IS NOT NULL
ORDER BY K.[NazwaFirmy];

/* 5 */
SELECT K.[NazwaFirmy], (SELECT MIN(Z.[DataZam�wienia])
						FROM Zam�wienia AS Z
						WHERE Z.IDklienta = K.IDklienta) AS [Pierwsze zam.], (SELECT SUM(Ilo�� * CenaJednostkowa)
																			  FROM PozycjeZamowienia AS PZ
																			  JOIN Zam�wienia AS Z ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
																			  WHERE Z.[DataZam�wienia] = (SELECT MIN(Z1.[DataZam�wienia])
																										  FROM Zam�wienia AS Z1
																									      WHERE Z1.IDklienta = K.IDklienta)) AS [Warto��]
FROM Klienci AS K
WHERE (
		SELECT MIN(Z.[DataZam�wienia])
		FROM Zam�wienia AS Z
		WHERE Z.IDklienta = K.IDklienta
	   ) IS NOT NULL
ORDER BY [Pierwsze zam.]

/* 6 */

/*SELECT K.[NazwaKategorii], (SELECT MIN(Z.[DataZam�wienia])
											   FROM Zam�wienia AS Z
											   JOIN PozycjeZamowienia AS PZ ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
											   JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
											   WHERE P.[IDkategorii] = K.[IDkategorii]
											   ) AS [Data pierwszego zam.]
FROM mg.Kategorie AS K
ORDER BY K.[NazwaKategorii]*/

SELECT K.[NazwaKategorii], P.[NazwaProduktu], Z.[IDzam�wienia], CAST(MIN(Z.[DataZam�wienia]) AS DATE) AS [Data pierw. zam.], PZ.[Ilo��] AS [Ilo�� zam.]
FROM mg.Kategorie AS K
JOIN mg.Produkty AS P ON P.[IDkategorii] = K.[IDkategorii]
JOIN PozycjeZamowienia AS PZ ON PZ.[IDproduktu] = P.[IDproduktu]
JOIN Zam�wienia AS Z ON Z.[IDzam�wienia] = PZ.[IDzam�wienia]
GROUP BY K.[NazwaKategorii], P.[NazwaProduktu], Z.[IDzam�wienia], K.[IDkategorii], PZ.[Ilo��]
HAVING MIN(Z.[DataZam�wienia]) IN (SELECT MIN(Z1.[DataZam�wienia])
											   FROM Zam�wienia AS Z1
											   JOIN PozycjeZamowienia AS PZ1 ON PZ1.[IDzam�wienia] = Z1.[IDzam�wienia]
											   JOIN mg.Produkty AS P1 ON P1.[IDproduktu] = PZ1.[IDproduktu]
											   WHERE P1.[IDkategorii] = K.[IDkategorii]
											   )
ORDER BY K.NazwaKategorii

/* 7 */
/*Created by Simon*/
select datename(dw,DataZam�wienia) as day, za.DataZam�wienia, ka.NazwaKategorii, Ilo��
from Zam�wienia as za join PozycjeZamowienia as pz on za.IDzam�wienia=pz.IDzam�wienia
join mg.Produkty as pr on pz.IDproduktu=pr.IDproduktu join mg.Kategorie as ka on
pr.IDkategorii=ka.IDkategorii
where datename(dw,DataZam�wienia) = 'monday' and ka.NazwaKategorii='Mi�so/Dr�b'
/*-----------------*/


/*CREATE FUNCTION DatyZam(@NazwaKategorii AS VARCHAR(50))
RETURNS TABLE
AS

RETURN
	(SELECT Z.[DataZam�wienia]
	FROM Zam�wienia AS Z 
	WHERE Z.IDzam�wienia NOT IN 
		( 
			SELECT PZ.IDzam�wienia
			FROM PozycjeZamowienia AS PZ
			WHERE PZ.[IDproduktu] IN
					(
						SELECT P.[IDproduktu]
						FROM mg.Produkty AS P
						WHERE P.[IDkategorii] IN
							(
								SELECT K.[IDkategorii]
								FROM mg.Kategorie AS K
								WHERE K.[NazwaKategorii] LIKE @NazwaKategorii
							)
					)
		)
		AND DATENAME(dw,Z.DataZam�wienia) LIKE 'Monday')*/

SELECT Z.[IDzam�wienia]
FROM dbo.Zam�wienia AS Z
WHERE Z.[DataZam�wienia] IN
(SELECT DZ.[DataZam�wienia] FROM DatyZam('Mi�so/Dr�b') AS DZ)



/* 8 */
SELECT K.[NazwaKategorii]
FROM mg.Kategorie AS K
WHERE K.[IDkategorii] NOT IN
	(SELECT P.[IDkategorii]
	FROM mg.Produkty AS P
	WHERE p.[IDproduktu] IN
		(SELECT PZ1.[IDproduktu]
			FROM PozycjeZamowienia AS PZ1
			JOIN Zam�wienia AS Z1 ON Z1.[IDzam�wienia] = PZ1.[IDzam�wienia]
			WHERE Z1.[KrajOdbiorcy] LIKE 'USA'
			AND Z1.[DataWysy�ki] IN (SELECT DATEADD(day,D.[Digit] - 1,'19970601') 
									 FROM DIGITS AS D)))

/* 9 */
SELECT K.[NazwaFirmy], K.[Kraj]
FROM Klienci AS K
WHERE K.[IDklienta] NOT IN 
	(SELECT Z.[IDklienta]
	 FROM Zam�wienia AS Z)

/* 10 */
/* A */
SELECT P.[IDpracownika], P.[Imi�], P.[Nazwisko], P.[DataZatrudnienia]
FROM Pracownicy AS P
WHERE P.[IDpracownika]  IN 
	(SELECT Z.[IDpracownika]
	 FROM Zam�wienia AS Z
	 WHERE Z.[IDzam�wienia] IS  NULL)
ORDER BY P.[IDpracownika]

/* B */
SELECT P.[IDpracownika], P.[Imi�], P.[Nazwisko], P.[DataZatrudnienia]
FROM Pracownicy AS P
WHERE P.[IDpracownika] <> ALL 
	(SELECT Z.[IDpracownika]
	 FROM Zam�wienia AS Z)

/* 11 */
SELECT DISTINCT P.[Miasto]
FROM Pracownicy AS P
WHERE EXISTS (SELECT K.[IDklienta]
			  FROM Klienci AS K
			  WHERE K.[Miasto] = P.[Miasto])

/* 12 */
SELECT P.[IDpracownika], P.[Imi�], P.[Nazwisko], P.[Miasto]
FROM Pracownicy AS P
WHERE EXISTS (SELECT K.[IDklienta]
			  FROM Klienci AS K
			  WHERE K.[Miasto] = P.[Miasto])

/* 13 */
SELECT MAX(MONTH(Z.[DataZam�wienia]))
FROM Zam�wienia AS Z
WHERE Z.[DataZam�wienia] BETWEEN '19980101' and '19990101'


SELECT Z.[DataZam�wienia], Z.[IDzam�wienia], (SELECT K.[NazwaFirmy]
											  FROM Klienci AS K
											  WHERE Z.[IDklienta] = K.[IDklienta])
FROM Zam�wienia AS Z
WHERE Z.[IDzam�wienia] IN 
	(SELECT MAX(Z.[IDzam�wienia])
	FROM Zam�wienia AS Z
	WHERE Z.[DataZam�wienia] BETWEEN '19980101' and '19990101')
OR
	Z.[IDzam�wienia] IN 
	(SELECT MIN(Z.IDzam�wienia)
	 FROM Zam�wienia AS Z
	 WHERE MONTH(Z.[DataZam�wienia] ) LIKE 5
	 AND Z.[DataZam�wienia] BETWEEN '19980101' and '19990101')

/* 14 */
SELECT Z.[IDzam�wienia], Z.[DataZam�wienia], (SELECT P.[Imi�] + P.[Nazwisko]
											  FROM Pracownicy AS P
											  WHERE P.[IDpracownika] = Z.[IDpracownika]) AS [Imi� Nazwisko]
FROM Zam�wienia AS Z
WHERE Z.[DataZam�wienia] BETWEEN '19980113' AND '19980113'
	AND 
	  Z.[IDpracownika] IN 
	   (SELECT P.[IDpracownika]
	    FROM Pracownicy AS P
		WHERE P.[Nazwisko] NOT LIKE 'D%')

/* 15 */
SELECT K.[IDklienta], (SELECT CAST(MAX(Z.[DataZam�wienia]) AS DATE)
					   FROM Zam�wienia AS Z
					   WHERE Z.[IDklienta] = K.[IDklienta]) AS [Data], (SELECT Z.[IDzam�wienia]
																		FROM Zam�wienia AS Z
																		WHERE Z.[IDklienta] = K.[IDklienta]
																		AND Z.[DataZam�wienia] IN (SELECT CAST(MAX(Z.[DataZam�wienia]) AS DATE)
																								   FROM Zam�wienia AS Z
																								   WHERE Z.[IDklienta] = K.[IDklienta])) AS [ID zam.]
FROM Klienci AS K
WHERE K.[NazwaFirmy] LIKE 'A%' OR K.[NazwaFirmy] LIKE 'K%'
ORDER BY K.[IDklienta]

/* 16 */
SELECT D.[NazwaFirmy], D.[Miasto], D.[Kraj]
FROM mg.Dostawcy AS D
WHERE D.[Kraj] LIKE 'Szwecja'
	AND
	  D.[IDdostawcy] IN 
		(SELECT P.[IDdostawcy]
		 FROM mg.Produkty AS P)

/* 17 */
 
SELECT D.[NazwaFirmy], D.[Miasto], D.[Kraj]
FROM mg.Dostawcy AS D
WHERE D.[IDdostawcy] NOT IN 
		(SELECT P.[IDdostawcy]
		 FROM mg.Produkty AS P)

/*WITH EXISTS*/
SELECT D.[NazwaFirmy], D.[Miasto], D.[Kraj]
FROM mg.Dostawcy AS D
WHERE NOT EXISTS
	(SELECT P.[IDdostawcy]
	 FROM mg.Produkty AS P
	 WHERE D.[IDdostawcy] = P.[IDdostawcy])

/* 18 */
/*INSERT INTO mg.Kategorie(IDkategorii,NazwaKategorii,Opis,Rysunek)
VALUES(10,'Alkohole','Wysokie %',NULL)*/

/* A */
SELECT K.[NazwaKategorii]
FROM mg.Kategorie AS K
WHERE NOT EXISTS
	(SELECT P.[IDkategorii]
	 FROM mg.Produkty AS P
	 WHERE K.[IDkategorii] = P.[IDkategorii])

/* B */
SELECT K.[NazwaKategorii]
FROM mg.Kategorie AS K
WHERE K.[IDkategorii] NOT IN
	(SELECT P.[IDkategorii]
	 FROM mg.Produkty AS P)

/* 19 */
/*INSERT INTO mg.Produkty(IDproduktu,NazwaProduktu,Wycofany)
VALUES(81,'Kefir',0)*/


SELECT P.[NazwaProduktu]
FROM mg.Produkty AS P
WHERE P.[IDproduktu] NOT IN
	(SELECT PZ.[IDproduktu]
	 FROM PozycjeZamowienia AS PZ)

/* 20 */
/*UPDATE mg.Produkty
SET IDkategorii = 4
WHERE IDproduktu = 81*/
SELECT K.[NazwaKategorii]
FROM mg.Kategorie AS K
WHERE K.[IDkategorii] IN
	(SELECT P.[IDkategorii]
	 FROM mg.Produkty AS P
	 WHERE P.[IDproduktu] NOT IN
		(SELECT PZ.[IDproduktu]
		 FROM PozycjeZamowienia AS PZ))

/* 21 */
SELECT TOP(1) K.[Kraj], COUNT(K.[IDklienta]) AS [Liczba]
FROM Klienci AS K
GROUP BY K.[Kraj]
ORDER BY [Liczba] DESC

/* 22 */
SELECT TOP(1) WITH TIES K.[Kraj], COUNT(K.[IDklienta]) AS [Liczba]
FROM Klienci AS K
GROUP BY K.[Kraj]
ORDER BY [Liczba];

/* 23 */
SELECT TOP(1) WITH TIES YEAR(Z.[DataZam�wienia]) AS [Rok], MONTH(Z.[DataZam�wienia]) AS [Miesiac], COUNT(Z.[IDzam�wienia]) AS [Ilo��]
FROM Zam�wienia AS Z
GROUP BY YEAR(Z.[DataZam�wienia]), MONTH(Z.[DataZam�wienia])
ORDER BY [Ilo��] DESC;

/* 24 */
SELECT TOP(1) WITH TIES YEAR(Z.[DataZam�wienia]) AS [Rok], MONTH(Z.[DataZam�wienia]) AS [Miesiac], COUNT(Z.[IDzam�wienia]) AS [Ilo��]
FROM Zam�wienia AS Z
GROUP BY YEAR(Z.[DataZam�wienia]), MONTH(Z.[DataZam�wienia])
ORDER BY [Ilo��];

/* 25 */
SELECT Q.Rok, Q.Miesiac, Q.Ilo��
FROM
	(SELECT TOP(1) WITH TIES YEAR(Z.[DataZam�wienia]) AS [Rok], MONTH(Z.[DataZam�wienia]) AS [Miesiac], COUNT(Z.[IDzam�wienia]) AS [Ilo��]
	FROM Zam�wienia AS Z
	GROUP BY YEAR(Z.[DataZam�wienia]), MONTH(Z.[DataZam�wienia])
	ORDER BY [Ilo��] DESC) AS Q
UNION ALL
SELECT Q2.Rok, Q2.Miesiac, Q2.Ilo��
FROM
	(SELECT TOP(1) WITH TIES YEAR(Z.[DataZam�wienia]) AS [Rok], MONTH(Z.[DataZam�wienia]) AS [Miesiac], COUNT(Z.[IDzam�wienia]) AS [Ilo��]
	FROM Zam�wienia AS Z
	GROUP BY YEAR(Z.[DataZam�wienia]), MONTH(Z.[DataZam�wienia])
	ORDER BY [Ilo��]) AS Q2

/* 26 */
SELECT COUNT(K.[IDkategorii])
FROM mg.Kategorie AS K
WHERE NOT EXISTS 
	(SELECT P.[IDproduktu]
	FROM mg.Produkty AS P
	WHERE K.[IDkategorii] = P.[IDkategorii])

/* 27 */
SELECT TOP(1) WITH TIES P.[NazwaProduktu], (SELECT SUM(PZ.[CenaJednostkowa] * PZ.[Ilo��])
										    FROM PozycjeZamowienia AS PZ 
										    WHERE PZ.[IDproduktu] = P.[IDproduktu]) AS [Warto�� sprzeda�y]
FROM mg.Produkty AS P
ORDER BY [Warto�� sprzeda�y] DESC;

/* 28 */
SELECT TOP(1) WITH TIES K.[NazwaKategorii], (SELECT SUM(PZ.[CenaJednostkowa] * PZ.[Ilo��])
							FROM PozycjeZamowienia AS PZ 
							JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
							WHERE P.[IDkategorii] = K.[IDkategorii] ) AS [Warto�� sprzeda�y]
FROM mg.Kategorie AS K
ORDER BY [Warto�� sprzeda�y] 

/* 29 */
SELECT Q.Rok, Q.NazwaKategorii, MAX(Q.[Warto��]) AS [Warto�� sprzeda�y]
FROM
	(SELECT YEAR(Z.[DataZam�wienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], SUM(PZ.[CenaJednostkowa] * PZ.[Ilo��]) AS [Warto��]
	FROM Zam�wienia AS Z
	JOIN PozycjeZamowienia AS PZ ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
	JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
	JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
	GROUP BY YEAR(Z.[DataZam�wienia]), K.[NazwaKategorii], K.[IDkategorii]) AS Q
GROUP BY Q.Rok, Q.NazwaKategorii
HAVING MAX(Q.Warto��) IN (SELECT MAX(Q2.Warto��)
                         FROM (SELECT YEAR(Z.[DataZam�wienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], SUM(PZ.[CenaJednostkowa] * PZ.[Ilo��]) AS [Warto��]
							FROM Zam�wienia AS Z
							JOIN PozycjeZamowienia AS PZ ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
							JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
							JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
							GROUP BY YEAR(Z.[DataZam�wienia]), K.[NazwaKategorii], K.[IDkategorii]) AS Q2
						GROUP BY Q2.ROK)
ORDER BY Q.Rok

/* 30 */
SELECT Q.Rok, Q.NazwaKategorii, Q.NazwaProduktu,Q.KrajDostawcy, MIN(Q.[Warto��]) AS [Warto�� sprzeda�y]
FROM
	(SELECT YEAR(Z.[DataZam�wienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], SUM(PZ.[CenaJednostkowa] * PZ.[Ilo��]) AS [Warto��], D.[Kraj] AS [KrajDostawcy]
	FROM Zam�wienia AS Z
	JOIN PozycjeZamowienia AS PZ ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
	JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
	JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
	JOIN mg.Dostawcy AS D ON D.[IDdostawcy] = P.[IDdostawcy]
	GROUP BY YEAR(Z.[DataZam�wienia]), K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], D.[Kraj]) AS Q
GROUP BY Q.Rok, Q.NazwaKategorii, Q.NazwaProduktu, Q.KrajDostawcy
HAVING MIN(Q.[Warto��]) IN (SELECT MIN(Q2.[Warto��])
FROM
	(SELECT YEAR(Z.[DataZam�wienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], SUM(PZ.[CenaJednostkowa] * PZ.[Ilo��]) AS [Warto��], D.[Kraj] AS [KrajDostawcy]
		FROM Zam�wienia AS Z
		JOIN PozycjeZamowienia AS PZ ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
		JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
		JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
		JOIN mg.Dostawcy AS D ON D.[IDdostawcy] = P.[IDdostawcy]
		GROUP BY YEAR(Z.[DataZam�wienia]), K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], D.[Kraj]) AS Q2
	GROUP BY Q2.Rok)



	
