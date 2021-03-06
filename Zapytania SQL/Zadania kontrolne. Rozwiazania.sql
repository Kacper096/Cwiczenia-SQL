USE [NorthwindZajecia]
GO

/* 1. */
/* A */
SELECT CAST(Z.[DataZamówienia] AS DATE) AS [Data], Z.[IDzamówienia] AS [ID zam.]
FROM Zamówienia AS Z
WHERE Z.[IDzamówienia] = (SELECT TOP(1) PZ.[IDzamówienia]
						  FROM PozycjeZamowienia AS PZ
						  GROUP BY PZ.IDzamówienia
						  ORDER BY COUNT(PZ.[IDzamówienia]) DESC);

/* B */ /* skorelowane */
SELECT TOP(1) CAST(Z.[DataZamówienia] AS DATE) AS [Data], Z.[IDzamówienia] AS [ID zam.]
FROM Zamówienia AS Z 
LEFT JOIN PozycjeZamowienia AS PZ ON Z.[IDzamówienia] = PZ.[IDzamówienia]
GROUP BY Z.[DataZamówienia], Z.[IDzamówienia] 
HAVING COUNT(Z.[IDzamówienia]) = (SELECT COUNT(PZ.[IDzamówienia])
								  FROM PozycjeZamowienia AS PZ
								  WHERE PZ.[IDzamówienia] = Z.[IDzamówienia]
								  )
ORDER BY COUNT(Z.[IDzamówienia]) DESC;
						  
		
/* 2 */
/* A */
SELECT (P.[Nazwisko] + ' ' + P.[Imię]) AS [Nazwisko Imie], Z.[IDzamówienia] AS [ID zam.]
FROM Pracownicy AS P
JOIN Zamówienia AS Z ON Z.[IDpracownika] = P.[IDpracownika]
WHERE Z.[IDzamówienia] = (SELECT  PZ.[IDzamówienia]
						  FROM PozycjeZamowienia AS PZ
						  GROUP BY PZ.IDzamówienia
						  ORDER BY COUNT(PZ.[IDzamówienia]) DESC);
/* B */
SELECT TOP(1) (P.[Nazwisko] + ' ' + P.[Imię]) AS [Nazwisko Imie], Z.[IDzamówienia] AS [ID zam.]
FROM Pracownicy AS P
INNER JOIN Zamówienia AS Z ON P.[IDpracownika] = Z.[IDpracownika]
INNER JOIN PozycjeZamowienia AS PZ ON PZ.[IDzamówienia] = Z.[IDzamówienia]
GROUP BY (P.[Nazwisko] + ' ' + P.[Imię]),Z.[IDzamówienia]
HAVING COUNT(Z.[IDzamówienia]) = (SELECT COUNT(PZ.[IDzamówienia])
								  FROM PozycjeZamowienia AS PZ
								  WHERE PZ.[IDzamówienia] = Z.[IDzamówienia]
								  )
ORDER BY COUNT(Z.[IDzamówienia]) DESC;

/* 3 */
SELECT TOP(1) K.[NazwaFirmy], Z.[KrajOdbiorcy], (SELECT SUM(Ilość * CenaJednostkowa)
										 FROM PozycjeZamowienia AS PZ
										 WHERE Z.[IDzamówienia] = PZ.[IDzamówienia]) AS [Wartość zam.]
FROM Klienci AS K
INNER JOIN Zamówienia AS Z ON Z.[IDklienta] = K.[IDklienta]
ORDER BY [Wartość zam.] DESC;

/* 4 */
SELECT K.[NazwaFirmy], (SELECT MAX(Z.[DataZamówienia])
						FROM Zamówienia AS Z 
						WHERE Z.[IDklienta] = K.[IDklienta]) AS [Ostatnie zam.]
FROM Klienci AS K
WHERE (
			SELECT MAX(Z.[DataZamówienia])
			FROM Zamówienia AS Z 
			WHERE Z.[IDklienta] = K.[IDklienta]
      ) IS NOT NULL
ORDER BY K.[NazwaFirmy];

/* 5 */
SELECT K.[NazwaFirmy], (SELECT MIN(Z.[DataZamówienia])
						FROM Zamówienia AS Z
						WHERE Z.IDklienta = K.IDklienta) AS [Pierwsze zam.], (SELECT SUM(Ilość * CenaJednostkowa)
																			  FROM PozycjeZamowienia AS PZ
																			  JOIN Zamówienia AS Z ON PZ.[IDzamówienia] = Z.[IDzamówienia]
																			  WHERE Z.[DataZamówienia] = (SELECT MIN(Z1.[DataZamówienia])
																										  FROM Zamówienia AS Z1
																									      WHERE Z1.IDklienta = K.IDklienta)) AS [Wartość]
FROM Klienci AS K
WHERE (
		SELECT MIN(Z.[DataZamówienia])
		FROM Zamówienia AS Z
		WHERE Z.IDklienta = K.IDklienta
	   ) IS NOT NULL
ORDER BY [Pierwsze zam.]

/* 6 */

/*SELECT K.[NazwaKategorii], (SELECT MIN(Z.[DataZamówienia])
											   FROM Zamówienia AS Z
											   JOIN PozycjeZamowienia AS PZ ON PZ.[IDzamówienia] = Z.[IDzamówienia]
											   JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
											   WHERE P.[IDkategorii] = K.[IDkategorii]
											   ) AS [Data pierwszego zam.]
FROM mg.Kategorie AS K
ORDER BY K.[NazwaKategorii]*/

SELECT K.[NazwaKategorii], P.[NazwaProduktu], Z.[IDzamówienia], CAST(MIN(Z.[DataZamówienia]) AS DATE) AS [Data pierw. zam.], PZ.[Ilość] AS [Ilość zam.]
FROM mg.Kategorie AS K
JOIN mg.Produkty AS P ON P.[IDkategorii] = K.[IDkategorii]
JOIN PozycjeZamowienia AS PZ ON PZ.[IDproduktu] = P.[IDproduktu]
JOIN Zamówienia AS Z ON Z.[IDzamówienia] = PZ.[IDzamówienia]
GROUP BY K.[NazwaKategorii], P.[NazwaProduktu], Z.[IDzamówienia], K.[IDkategorii], PZ.[Ilość]
HAVING MIN(Z.[DataZamówienia]) IN (SELECT MIN(Z1.[DataZamówienia])
											   FROM Zamówienia AS Z1
											   JOIN PozycjeZamowienia AS PZ1 ON PZ1.[IDzamówienia] = Z1.[IDzamówienia]
											   JOIN mg.Produkty AS P1 ON P1.[IDproduktu] = PZ1.[IDproduktu]
											   WHERE P1.[IDkategorii] = K.[IDkategorii]
											   )
ORDER BY K.NazwaKategorii

/* 7 */
/*Created by Simon*/
select datename(dw,DataZamówienia) as day, za.DataZamówienia, ka.NazwaKategorii, Ilość
from Zamówienia as za join PozycjeZamowienia as pz on za.IDzamówienia=pz.IDzamówienia
join mg.Produkty as pr on pz.IDproduktu=pr.IDproduktu join mg.Kategorie as ka on
pr.IDkategorii=ka.IDkategorii
where datename(dw,DataZamówienia) = 'monday' and ka.NazwaKategorii='Mięso/Drób'
/*-----------------*/


/*CREATE FUNCTION DatyZam(@NazwaKategorii AS VARCHAR(50))
RETURNS TABLE
AS

RETURN
	(SELECT Z.[DataZamówienia]
	FROM Zamówienia AS Z 
	WHERE Z.IDzamówienia NOT IN 
		( 
			SELECT PZ.IDzamówienia
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
		AND DATENAME(dw,Z.DataZamówienia) LIKE 'Monday')*/

SELECT Z.[IDzamówienia]
FROM dbo.Zamówienia AS Z
WHERE Z.[DataZamówienia] IN
(SELECT DZ.[DataZamówienia] FROM DatyZam('Mięso/Drób') AS DZ)



/* 8 */
SELECT K.[NazwaKategorii]
FROM mg.Kategorie AS K
WHERE K.[IDkategorii] NOT IN
	(SELECT P.[IDkategorii]
	FROM mg.Produkty AS P
	WHERE p.[IDproduktu] IN
		(SELECT PZ1.[IDproduktu]
			FROM PozycjeZamowienia AS PZ1
			JOIN Zamówienia AS Z1 ON Z1.[IDzamówienia] = PZ1.[IDzamówienia]
			WHERE Z1.[KrajOdbiorcy] LIKE 'USA'
			AND Z1.[DataWysyłki] IN (SELECT DATEADD(day,D.[Digit] - 1,'19970601') 
									 FROM DIGITS AS D)))

/* 9 */
SELECT K.[NazwaFirmy], K.[Kraj]
FROM Klienci AS K
WHERE K.[IDklienta] NOT IN 
	(SELECT Z.[IDklienta]
	 FROM Zamówienia AS Z)

/* 10 */
/* A */
SELECT P.[IDpracownika], P.[Imię], P.[Nazwisko], P.[DataZatrudnienia]
FROM Pracownicy AS P
WHERE P.[IDpracownika]  IN 
	(SELECT Z.[IDpracownika]
	 FROM Zamówienia AS Z
	 WHERE Z.[IDzamówienia] IS  NULL)
ORDER BY P.[IDpracownika]

/* B */
SELECT P.[IDpracownika], P.[Imię], P.[Nazwisko], P.[DataZatrudnienia]
FROM Pracownicy AS P
WHERE P.[IDpracownika] <> ALL 
	(SELECT Z.[IDpracownika]
	 FROM Zamówienia AS Z)

/* 11 */
SELECT DISTINCT P.[Miasto]
FROM Pracownicy AS P
WHERE EXISTS (SELECT K.[IDklienta]
			  FROM Klienci AS K
			  WHERE K.[Miasto] = P.[Miasto])

/* 12 */
SELECT P.[IDpracownika], P.[Imię], P.[Nazwisko], P.[Miasto]
FROM Pracownicy AS P
WHERE EXISTS (SELECT K.[IDklienta]
			  FROM Klienci AS K
			  WHERE K.[Miasto] = P.[Miasto])

/* 13 */
SELECT MAX(MONTH(Z.[DataZamówienia]))
FROM Zamówienia AS Z
WHERE Z.[DataZamówienia] BETWEEN '19980101' and '19990101'


SELECT Z.[DataZamówienia], Z.[IDzamówienia], (SELECT K.[NazwaFirmy]
											  FROM Klienci AS K
											  WHERE Z.[IDklienta] = K.[IDklienta])
FROM Zamówienia AS Z
WHERE Z.[IDzamówienia] IN 
	(SELECT MAX(Z.[IDzamówienia])
	FROM Zamówienia AS Z
	WHERE Z.[DataZamówienia] BETWEEN '19980101' and '19990101')
OR
	Z.[IDzamówienia] IN 
	(SELECT MIN(Z.IDzamówienia)
	 FROM Zamówienia AS Z
	 WHERE MONTH(Z.[DataZamówienia] ) LIKE 5
	 AND Z.[DataZamówienia] BETWEEN '19980101' and '19990101')

/* 14 */
SELECT Z.[IDzamówienia], Z.[DataZamówienia], (SELECT P.[Imię] + P.[Nazwisko]
											  FROM Pracownicy AS P
											  WHERE P.[IDpracownika] = Z.[IDpracownika]) AS [Imię Nazwisko]
FROM Zamówienia AS Z
WHERE Z.[DataZamówienia] BETWEEN '19980113' AND '19980113'
	AND 
	  Z.[IDpracownika] IN 
	   (SELECT P.[IDpracownika]
	    FROM Pracownicy AS P
		WHERE P.[Nazwisko] NOT LIKE 'D%')

/* 15 */
SELECT K.[IDklienta], (SELECT CAST(MAX(Z.[DataZamówienia]) AS DATE)
					   FROM Zamówienia AS Z
					   WHERE Z.[IDklienta] = K.[IDklienta]) AS [Data], (SELECT Z.[IDzamówienia]
																		FROM Zamówienia AS Z
																		WHERE Z.[IDklienta] = K.[IDklienta]
																		AND Z.[DataZamówienia] IN (SELECT CAST(MAX(Z.[DataZamówienia]) AS DATE)
																								   FROM Zamówienia AS Z
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
SELECT TOP(1) WITH TIES YEAR(Z.[DataZamówienia]) AS [Rok], MONTH(Z.[DataZamówienia]) AS [Miesiac], COUNT(Z.[IDzamówienia]) AS [Ilość]
FROM Zamówienia AS Z
GROUP BY YEAR(Z.[DataZamówienia]), MONTH(Z.[DataZamówienia])
ORDER BY [Ilość] DESC;

/* 24 */
SELECT TOP(1) WITH TIES YEAR(Z.[DataZamówienia]) AS [Rok], MONTH(Z.[DataZamówienia]) AS [Miesiac], COUNT(Z.[IDzamówienia]) AS [Ilość]
FROM Zamówienia AS Z
GROUP BY YEAR(Z.[DataZamówienia]), MONTH(Z.[DataZamówienia])
ORDER BY [Ilość];

/* 25 */
SELECT Q.Rok, Q.Miesiac, Q.Ilość
FROM
	(SELECT TOP(1) WITH TIES YEAR(Z.[DataZamówienia]) AS [Rok], MONTH(Z.[DataZamówienia]) AS [Miesiac], COUNT(Z.[IDzamówienia]) AS [Ilość]
	FROM Zamówienia AS Z
	GROUP BY YEAR(Z.[DataZamówienia]), MONTH(Z.[DataZamówienia])
	ORDER BY [Ilość] DESC) AS Q
UNION ALL
SELECT Q2.Rok, Q2.Miesiac, Q2.Ilość
FROM
	(SELECT TOP(1) WITH TIES YEAR(Z.[DataZamówienia]) AS [Rok], MONTH(Z.[DataZamówienia]) AS [Miesiac], COUNT(Z.[IDzamówienia]) AS [Ilość]
	FROM Zamówienia AS Z
	GROUP BY YEAR(Z.[DataZamówienia]), MONTH(Z.[DataZamówienia])
	ORDER BY [Ilość]) AS Q2

/* 26 */
SELECT COUNT(K.[IDkategorii])
FROM mg.Kategorie AS K
WHERE NOT EXISTS 
	(SELECT P.[IDproduktu]
	FROM mg.Produkty AS P
	WHERE K.[IDkategorii] = P.[IDkategorii])

/* 27 */
SELECT TOP(1) WITH TIES P.[NazwaProduktu], (SELECT SUM(PZ.[CenaJednostkowa] * PZ.[Ilość])
										    FROM PozycjeZamowienia AS PZ 
										    WHERE PZ.[IDproduktu] = P.[IDproduktu]) AS [Wartość sprzedaży]
FROM mg.Produkty AS P
ORDER BY [Wartość sprzedaży] DESC;

/* 28 */
SELECT TOP(1) WITH TIES K.[NazwaKategorii], (SELECT SUM(PZ.[CenaJednostkowa] * PZ.[Ilość])
							FROM PozycjeZamowienia AS PZ 
							JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
							WHERE P.[IDkategorii] = K.[IDkategorii] ) AS [Wartość sprzedaży]
FROM mg.Kategorie AS K
ORDER BY [Wartość sprzedaży] 

/* 29 */
SELECT Q.Rok, Q.NazwaKategorii, MAX(Q.[Wartość]) AS [Wartość sprzedaży]
FROM
	(SELECT YEAR(Z.[DataZamówienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], SUM(PZ.[CenaJednostkowa] * PZ.[Ilość]) AS [Wartość]
	FROM Zamówienia AS Z
	JOIN PozycjeZamowienia AS PZ ON PZ.[IDzamówienia] = Z.[IDzamówienia]
	JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
	JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
	GROUP BY YEAR(Z.[DataZamówienia]), K.[NazwaKategorii], K.[IDkategorii]) AS Q
GROUP BY Q.Rok, Q.NazwaKategorii
HAVING MAX(Q.Wartość) IN (SELECT MAX(Q2.Wartość)
                         FROM (SELECT YEAR(Z.[DataZamówienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], SUM(PZ.[CenaJednostkowa] * PZ.[Ilość]) AS [Wartość]
							FROM Zamówienia AS Z
							JOIN PozycjeZamowienia AS PZ ON PZ.[IDzamówienia] = Z.[IDzamówienia]
							JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
							JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
							GROUP BY YEAR(Z.[DataZamówienia]), K.[NazwaKategorii], K.[IDkategorii]) AS Q2
						GROUP BY Q2.ROK)
ORDER BY Q.Rok

/* 30 */
SELECT Q.Rok, Q.NazwaKategorii, Q.NazwaProduktu,Q.KrajDostawcy, MIN(Q.[Wartość]) AS [Wartość sprzedaży]
FROM
	(SELECT YEAR(Z.[DataZamówienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], SUM(PZ.[CenaJednostkowa] * PZ.[Ilość]) AS [Wartość], D.[Kraj] AS [KrajDostawcy]
	FROM Zamówienia AS Z
	JOIN PozycjeZamowienia AS PZ ON PZ.[IDzamówienia] = Z.[IDzamówienia]
	JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
	JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
	JOIN mg.Dostawcy AS D ON D.[IDdostawcy] = P.[IDdostawcy]
	GROUP BY YEAR(Z.[DataZamówienia]), K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], D.[Kraj]) AS Q
GROUP BY Q.Rok, Q.NazwaKategorii, Q.NazwaProduktu, Q.KrajDostawcy
HAVING MIN(Q.[Wartość]) IN (SELECT MIN(Q2.[Wartość])
FROM
	(SELECT YEAR(Z.[DataZamówienia]) AS [Rok], K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], SUM(PZ.[CenaJednostkowa] * PZ.[Ilość]) AS [Wartość], D.[Kraj] AS [KrajDostawcy]
		FROM Zamówienia AS Z
		JOIN PozycjeZamowienia AS PZ ON PZ.[IDzamówienia] = Z.[IDzamówienia]
		JOIN mg.Produkty AS P ON P.[IDproduktu] = PZ.[IDproduktu]
		JOIN mg.Kategorie AS K ON K.[IDkategorii] = P.[IDkategorii]
		JOIN mg.Dostawcy AS D ON D.[IDdostawcy] = P.[IDdostawcy]
		GROUP BY YEAR(Z.[DataZamówienia]), K.[NazwaKategorii], K.[IDkategorii], P.[NazwaProduktu], D.[Kraj]) AS Q2
	GROUP BY Q2.Rok)



	
