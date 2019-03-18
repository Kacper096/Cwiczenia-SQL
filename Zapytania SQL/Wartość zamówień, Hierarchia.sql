USE [AdventureWorksLT2012]
GO

SELECT S.[SalesOrderID], S.[TotalDue]
FROM [SalesLT].[SalesOrderHeader] AS S;

SELECT S.[SalesOrderID], S.[TotalDue],
	AVG(S.TotalDue) OVER() AS [�rednia Ca�o�ci],
	SUM(S.TotalDue) OVER() AS [Suma ca�o�ci]
FROM [SalesLT].[SalesOrderHeader] AS S;

USE [NorthwindZajecia]
GO

/* Warto�� wszystkich zam�wie�*/
SELECT  SUM(Ilo�� * CenaJednostkowa) AS [Warto�� wszystkich zam�wie�]
FROM [dbo].[PozycjeZamowienia];

SELECT DISTINCT SUM(Ilo�� * CenaJednostkowa) OVER() AS [Warto�� wszystkich zam�wie�]
FROM [dbo].[PozycjeZamowienia];

/* Warto�c zam�wie� dla poszczeg�lnych klient�w */
SELECT K.[IDklienta], SUM(Ilo�� * CenaJednostkowa) AS [Warto�� zam�wienia]
FROM [dbo].[Klienci] AS K
	INNER JOIN [dbo].[Zam�wienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
	INNER JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzam�wienia] = PZ.[IDzam�wienia]
GROUP BY K.[IDklienta]
ORDER BY K.[IDklienta];

/*Ranking wg. Najdro�szych zam�wie�*/
SELECT K.[IDklienta], SUM(Ilo�� * CenaJednostkowa) AS [Warto�� zam�wienia]
FROM [dbo].[Klienci] AS K
	INNER JOIN [dbo].[Zam�wienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
	INNER JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzam�wienia] = PZ.[IDzam�wienia]
GROUP BY K.[IDklienta]
ORDER BY [Warto�� zam�wienia] DESC;

/* Hierarchia pracownik�w */
SELECT P.[IDpracownika], P.[Imi�], P.[Nazwisko], P.[Szef], 'Szef szef�w' AS [Status]
FROM [dbo].[Pracownicy] AS P
WHERE P.[Szef] IS NULL
UNION ALL
SELECT P2.[IDpracownika], P2.[Imi�], P2.[Nazwisko], P2.[Szef], 'Szef' AS [Status]
FROM [dbo].[Pracownicy] AS P2
WHERE EXISTS
	(
		SELECT DISTINCT * 
		FROM [dbo].[Pracownicy] AS K
		WHERE P2.[IDpracownika] = K.[Szef]
		AND P2.[Szef] IS NOT NULL
	)
UNION ALL
SELECT P3.[IDpracownika], P3.[Imi�], P3.[Nazwisko], P3.[Szef], 'Pracownik' AS [Status]
FROM [dbo].[Pracownicy] AS P3
WHERE NOT EXISTS
	(
		SELECT DISTINCT * 
		FROM [dbo].[Pracownicy] AS K
		WHERE P3.[IDpracownika] = K.[Szef]
		AND P3.[Szef] IS  NULL
	)
