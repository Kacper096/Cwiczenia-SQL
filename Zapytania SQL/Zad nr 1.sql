USE [NorthwindZajecia]
GO

/*1*/
SELECT K.[IDklienta], Z.[IDzam�wienia]
FROM [dbo].[Klienci] AS K
LEFT OUTER JOIN [dbo].[Zam�wienia] AS Z ON Z.[IDklienta] = K.[IDklienta]
WHERE Z.[IDzam�wienia] IS NOT NULL;

SELECT K.[IDklienta], Z.[IDzam�wienia]
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zam�wienia] AS Z ON Z.[IDklienta] = K.[IDklienta]
WHERE Z.[IDzam�wienia] IS NOT NULL;

/*2*/
SELECT K.[IDklienta], K.[NazwaFirmy], Z.[IDzam�wienia], CAST(Z.[DataZam�wienia] AS VARCHAR)
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zam�wienia] AS Z ON Z.[IDklienta] = K.[IDklienta]
WHERE Z.[DataZam�wienia] BETWEEN '1997-01-01'  AND '1997-12-31'
ORDER BY Z.[DataZam�wienia];

/*3*/
SELECT K.[IDklienta], Z.[IDzam�wienia]
FROM [dbo].[Klienci] AS K
LEFT OUTER JOIN [dbo].[Zam�wienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
WHERE Z.[IDzam�wienia] IS NULL;

/*4*/
SELECT DISTINCT K.[IDklienta], C.[NazwaKategorii]
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zam�wienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzam�wienia] = PZ.[IDzam�wienia]
JOIN [mg].[Produkty] AS P ON  PZ.[IDproduktu] = P.[IDproduktu]
JOIN [mg].[Kategorie] AS C ON P.[IDkategorii] = C.[IDkategorii]
WHERE Z.[IDzam�wienia] IS NOT NULL
ORDER BY K.[IDklienta];

/*5*/ --- ?
SELECT E.[IDpracownika], E.[Imi�], E.[Nazwisko], COUNT(Z.[IDzam�wienia]) AS [Liczba zam�wie�]
FROM [dbo].[Pracownicy] AS E
JOIN [dbo].[Zam�wienia] AS Z ON E.[IDpracownika] = Z.[IDpracownika]
GROUP BY E.[IDpracownika], E.[Imi�], E.[Nazwisko]
HAVING COUNT(*) > 1
ORDER BY E.[IDpracownika];

/*6*/
SELECT DISTINCT K.[IDklienta], C.[NazwaKategorii]
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zam�wienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzam�wienia] = PZ.[IDzam�wienia]
JOIN [mg].[Produkty] AS P ON PZ.[IDproduktu] = P.[IDproduktu]
JOIN [mg].[Kategorie] AS C ON P.[IDkategorii] = C.[IDkategorii]
WHERE C.[NazwaKategorii] NOT LIKE 'S�odycze'
ORDER BY K.[IDklienta];

/*7*/
SELECT K.[IDklienta], K.[Miasto], CAST(Z.[DataZam�wienia] AS CHAR)
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zam�wienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
WHERE K.[Miasto] LIKE 'Londyn' AND Z.[DataZam�wienia] = '1997-11-14'
ORDER BY K.[IDklienta];

SELECT  K.[IDklienta], K.[Miasto], Z.[DataZam�wienia]
FROM Klienci AS K
JOIN Zam�wienia AS Z ON K.[IDklienta] = Z.[IDklienta]
WHERE K.[Miasto] LIKE 'Londyn'
ORDER BY K.[IDklienta];
/*9*/
SELECT DISTINCT P.[NazwaProduktu]
FROM [mg].[Produkty] AS P
JOIN [dbo].[PozycjeZamowienia] AS PZ ON P.[IDproduktu] = PZ.[IDproduktu]
JOIN [dbo].[Zam�wienia] AS Z ON PZ.[IDzam�wienia] = Z.[IDzam�wienia]
JOIN [dbo].[Klienci] AS K ON Z.[IDklienta] = K.[IDklienta]
WHERE K.[IDklienta] LIKE 'MACKI'
ORDER BY P.[NazwaProduktu];

/*10*/







