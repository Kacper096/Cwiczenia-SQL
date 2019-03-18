USE [AdventureWorksLT2012]
GO

SELECT S.[SalesOrderID], S.[TotalDue]
FROM [SalesLT].[SalesOrderHeader] AS S;

SELECT S.[SalesOrderID], S.[TotalDue],
	AVG(S.TotalDue) OVER() AS [Œrednia Ca³oœci],
	SUM(S.TotalDue) OVER() AS [Suma ca³oœci]
FROM [SalesLT].[SalesOrderHeader] AS S;

USE [NorthwindZajecia]
GO

/* Wartoœæ wszystkich zamówieñ*/
SELECT  SUM(Iloœæ * CenaJednostkowa) AS [Wartoœæ wszystkich zamówieñ]
FROM [dbo].[PozycjeZamowienia];

SELECT DISTINCT SUM(Iloœæ * CenaJednostkowa) OVER() AS [Wartoœæ wszystkich zamówieñ]
FROM [dbo].[PozycjeZamowienia];

/* Wartoœc zamówieñ dla poszczególnych klientów */
SELECT K.[IDklienta], SUM(Iloœæ * CenaJednostkowa) AS [Wartoœæ zamówienia]
FROM [dbo].[Klienci] AS K
	INNER JOIN [dbo].[Zamówienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
	INNER JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzamówienia] = PZ.[IDzamówienia]
GROUP BY K.[IDklienta]
ORDER BY K.[IDklienta];

/*Ranking wg. Najdro¿szych zamówieñ*/
SELECT K.[IDklienta], SUM(Iloœæ * CenaJednostkowa) AS [Wartoœæ zamówienia]
FROM [dbo].[Klienci] AS K
	INNER JOIN [dbo].[Zamówienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
	INNER JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzamówienia] = PZ.[IDzamówienia]
GROUP BY K.[IDklienta]
ORDER BY [Wartoœæ zamówienia] DESC;

/* Hierarchia pracowników */
SELECT P.[IDpracownika], P.[Imiê], P.[Nazwisko], P.[Szef], 'Szef szefów' AS [Status]
FROM [dbo].[Pracownicy] AS P
WHERE P.[Szef] IS NULL
UNION ALL
SELECT P2.[IDpracownika], P2.[Imiê], P2.[Nazwisko], P2.[Szef], 'Szef' AS [Status]
FROM [dbo].[Pracownicy] AS P2
WHERE EXISTS
	(
		SELECT DISTINCT * 
		FROM [dbo].[Pracownicy] AS K
		WHERE P2.[IDpracownika] = K.[Szef]
		AND P2.[Szef] IS NOT NULL
	)
UNION ALL
SELECT P3.[IDpracownika], P3.[Imiê], P3.[Nazwisko], P3.[Szef], 'Pracownik' AS [Status]
FROM [dbo].[Pracownicy] AS P3
WHERE NOT EXISTS
	(
		SELECT DISTINCT * 
		FROM [dbo].[Pracownicy] AS K
		WHERE P3.[IDpracownika] = K.[Szef]
		AND P3.[Szef] IS  NULL
	)
