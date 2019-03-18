USE [NorthwindZajecia]
GO

/*1*/
SELECT K.[IDklienta], Z.[IDzamówienia]
FROM [dbo].[Klienci] AS K
LEFT OUTER JOIN [dbo].[Zamówienia] AS Z ON Z.[IDklienta] = K.[IDklienta]
WHERE Z.[IDzamówienia] IS NOT NULL;

SELECT K.[IDklienta], Z.[IDzamówienia]
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zamówienia] AS Z ON Z.[IDklienta] = K.[IDklienta]
WHERE Z.[IDzamówienia] IS NOT NULL;

/*2*/
SELECT K.[IDklienta], K.[NazwaFirmy], Z.[IDzamówienia], CAST(Z.[DataZamówienia] AS VARCHAR)
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zamówienia] AS Z ON Z.[IDklienta] = K.[IDklienta]
WHERE Z.[DataZamówienia] BETWEEN '1997-01-01'  AND '1997-12-31'
ORDER BY Z.[DataZamówienia];

/*3*/
SELECT K.[IDklienta], Z.[IDzamówienia]
FROM [dbo].[Klienci] AS K
LEFT OUTER JOIN [dbo].[Zamówienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
WHERE Z.[IDzamówienia] IS NULL;

/*4*/
SELECT DISTINCT K.[IDklienta], C.[NazwaKategorii]
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zamówienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzamówienia] = PZ.[IDzamówienia]
JOIN [mg].[Produkty] AS P ON  PZ.[IDproduktu] = P.[IDproduktu]
JOIN [mg].[Kategorie] AS C ON P.[IDkategorii] = C.[IDkategorii]
WHERE Z.[IDzamówienia] IS NOT NULL
ORDER BY K.[IDklienta];

/*5*/ --- ?
SELECT E.[IDpracownika], E.[Imiê], E.[Nazwisko], COUNT(Z.[IDzamówienia]) AS [Liczba zamówieñ]
FROM [dbo].[Pracownicy] AS E
JOIN [dbo].[Zamówienia] AS Z ON E.[IDpracownika] = Z.[IDpracownika]
GROUP BY E.[IDpracownika], E.[Imiê], E.[Nazwisko]
HAVING COUNT(*) > 1
ORDER BY E.[IDpracownika];

/*6*/
SELECT DISTINCT K.[IDklienta], C.[NazwaKategorii]
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zamówienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
JOIN [dbo].[PozycjeZamowienia] AS PZ ON Z.[IDzamówienia] = PZ.[IDzamówienia]
JOIN [mg].[Produkty] AS P ON PZ.[IDproduktu] = P.[IDproduktu]
JOIN [mg].[Kategorie] AS C ON P.[IDkategorii] = C.[IDkategorii]
WHERE C.[NazwaKategorii] NOT LIKE 'S³odycze'
ORDER BY K.[IDklienta];

/*7*/
SELECT K.[IDklienta], K.[Miasto], CAST(Z.[DataZamówienia] AS CHAR)
FROM [dbo].[Klienci] AS K
JOIN [dbo].[Zamówienia] AS Z ON K.[IDklienta] = Z.[IDklienta]
WHERE K.[Miasto] LIKE 'Londyn' AND Z.[DataZamówienia] = '1997-11-14'
ORDER BY K.[IDklienta];

SELECT  K.[IDklienta], K.[Miasto], Z.[DataZamówienia]
FROM Klienci AS K
JOIN Zamówienia AS Z ON K.[IDklienta] = Z.[IDklienta]
WHERE K.[Miasto] LIKE 'Londyn'
ORDER BY K.[IDklienta];
/*9*/
SELECT DISTINCT P.[NazwaProduktu]
FROM [mg].[Produkty] AS P
JOIN [dbo].[PozycjeZamowienia] AS PZ ON P.[IDproduktu] = PZ.[IDproduktu]
JOIN [dbo].[Zamówienia] AS Z ON PZ.[IDzamówienia] = Z.[IDzamówienia]
JOIN [dbo].[Klienci] AS K ON Z.[IDklienta] = K.[IDklienta]
WHERE K.[IDklienta] LIKE 'MACKI'
ORDER BY P.[NazwaProduktu];

/*10*/







