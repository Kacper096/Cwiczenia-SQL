USE [NorthwindZajecia]
GO

/*1.*/
/* Wyœwietliæ datê zamówienia o najwy¿szej wartoœci identyfikatora  (Data Zamówienia, ID)*/
SELECT CAST(Z.[DataZamówienia] AS DATE), Z.[IDzamówienia]
FROM Zamówienia AS Z
WHERE Z.[IDzamówienia] = (SELECT TOP(1) MAX(Z2.[IDzamówienia])
						  FROM Zamówienia AS Z2);

/*2.*/
/*Wyœwietliæ daty zamówieñ: o najni¿szej i najwy¿szej wartoœci identyfikatora (DataZamówienia, IDzamówienia), przyjêtych do realizacji w grudniu 1997*/
SELECT CAST(Z.[DataZamówienia] AS DATE) AS [Data Zam.], Z.[IDzamówienia] AS [ID zam.]
FROM Zamówienia AS Z
WHERE Z.IDzamówienia = (SELECT TOP(1) MAX(Z2.IDzamówienia)
						FROM Zamówienia AS Z2
						WHERE YEAR(Z2.DataZamówienia) = 1997
							AND
							   MONTH(Z2.DataZamówienia) = 12
						) 
					OR
	  Z.IDzamówienia = (SELECT TOP(1) MIN(Z3.IDzamówienia)
	                   FROM Zamówienia AS Z3
					   WHERE YEAR(Z3.DataZamówienia) = 1997
							AND
							   MONTH(Z3.DataZamówienia) = 12
						);
						
/*3*/
/*Wyœwietliæ zamówienia przyjête w styczniu 1998 przez pracowników, których nazwa nazwiska zaczyna siê na literê "C" (IDzamówienia,DataZamówienia)*/
SELECT CAST(Z.[DataZamówienia] AS DATE) AS [Data zam.], Z.[IDzamówienia] AS [ID. zam.]
FROM Zamówienia AS Z
WHERE  YEAR(Z.DataZamówienia) = 1998 
		AND
       MONTH(Z.DataZamówienia) = 1
	    AND
	   Z.IDpracownika = (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'C%'); 
/*4*/
/*Wyœwietliæ zamówienia przyjête w styczniu 1998 roku przez pracowników, których nazwiska zaczynaj¹ siê od litery „A” (IDzamówienia, Data
zamówienia).*/
SELECT CAST(Z.[DataZamówienia] AS DATE) AS [Data zam.], Z.[IDzamówienia] AS [ID. zam.]
FROM Zamówienia AS Z
WHERE  YEAR(Z.DataZamówienia) = 1998 
		AND
       MONTH(Z.DataZamówienia) = 1
	    AND
	   Z.IDpracownika = (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'A%');

/*5*/
/*ZnaleŸæ najczêœciej i najrzadziej zamawiany towar w 1997 roku ID, Nazwa, Liczba zamówieñ.*/
SELECT P.[IDproduktu] AS [ID], P.[NazwaProduktu] AS [Nazwa], (SELECT TOP(1) COUNT(*)
															  FROM PozycjeZamowienia AS PZ
															  GROUP BY PZ.IDproduktu
															  ORDER BY COUNT(*) DESC) AS [Liczba zamówieñ]
FROM mg.Produkty AS P
WHERE P.IDproduktu = (SELECT TOP(1) P1.[IDproduktu]
					  FROM PozycjeZamowienia AS P1
					  GROUP BY P1.IDproduktu
					  ORDER BY COUNT(*) DESC)
UNION
SELECT P2.[IDproduktu] AS [ID], P2.[NazwaProduktu] AS [Nazwa], (SELECT TOP(1) COUNT(*)
															  FROM PozycjeZamowienia AS PZ2
															  GROUP BY PZ2.IDproduktu
															  ORDER BY COUNT(*) ) AS [Liczba zamówieñ]
FROM mg.Produkty AS P2
WHERE P2.IDproduktu = (SELECT TOP(1) P3.[IDproduktu]
				       	FROM mg.Produkty AS P3
						GROUP BY P3.IDproduktu
						ORDER BY COUNT(*));

/*6*/
/*Wyœwietliæ zamówienia przyjête w styczniu 1998 roku przez pracowników, których nazwiska zaczynaj¹ siê od litery „D” (IDzamówienia, Data
zamówienia).*/
SELECT CAST(Z.[DataZamówienia] AS DATE) AS [Data zam.], Z.[IDzamówienia] AS [ID. zam.]
FROM Zamówienia AS Z
WHERE  YEAR(Z.DataZamówienia) = 1998 
		AND
       MONTH(Z.DataZamówienia) = 1
	    AND
	   Z.IDpracownika IN (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'D%');
		
/*7*/
/*Wyœwietliæ zamówienia przyjête w 13. stycznia 1998 roku przez pracowników, których nazwiska nie zaczynaj¹ siê od litery „D” (IDpracownika,
IDzamówienia, Data zamówienia).*/
SELECT CAST(Z.[DataZamówienia] AS DATE) AS [Data zam.], Z.[IDzamówienia] AS [ID. zam.], Z.[IDpracownika]
FROM Zamówienia AS Z
WHERE  YEAR(Z.DataZamówienia) = 1998 
		AND
       MONTH(Z.DataZamówienia) = 1
	    AND
	   DAY(Z.DataZamówienia) = 13
	    AND
	   Z.IDpracownika NOT IN (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'D%')
ORDER BY Z.[IDpracownika];

/*8*/
/*Wyœwietliæ nazwiska i adresy pracowników, którzy mieszkaj¹ w miastach wystêpuj¹cych w adresach dostawców (IDpracownika, Nazwisko,
Miasto).*/
SELECT P.[IDpracownika] AS [ID], P.[Adres] AS [Adres], P.[Miasto] AS [Miasto]
FROM Pracownicy AS P 
WHERE P.[Miasto] = SOME (SELECT D.[Miasto]
					   FROM mg.Dostawcy AS D)
ORDER BY P.[Nazwisko];

/*9*/
/*Wyœwietliæ nazwiska i adresy pracowników, którzy mieszkaj¹ w miastach nie wystêpuj¹cych w adresach dostawców (IDpracownika, Nazwisko,
Miasto).*/
SELECT P.[IDpracownika] AS [ID], P.[Adres] AS [Adres], P.[Miasto] AS [Miasto]
FROM Pracownicy AS P 
WHERE P.[Miasto] <> ALL (SELECT D.[Miasto]
					   FROM mg.Dostawcy AS D)
ORDER BY P.[Nazwisko];

/*10*/
/*Wyœwietliæ nazwy firm oraz daty i numery ich ostatnich zamówieñ (IDklienta, IDzamówienia, Data ostatniego zamówienia).*/
SELECT Z.[IDklienta] AS [Klient], Z.[IDzamówienia] AS [ID zam.], CAST(Z.[DataZamówienia] AS DATE) AS [Data ostatniego zam.]
FROM Zamówienia AS Z
WHERE Z.[DataZamówienia] = (SELECT MAX(Z2.[DataZamówienia])
							FROM Zamówienia AS Z2
							WHERE Z.IDklienta = Z2.IDklienta)
ORDER BY Z.[IDklienta];

/*11*/
/*Wyœwietliæ nazwy dostawców z USA, którzy
dostarczyli jakiekolwiek produkty.*/
SELECT D.[NazwaFirmy] AS [Nazwa dostawcy], D.[Kraj] AS [Kraj]
FROM mg.Dostawcy AS D 
WHERE D.[Kraj] LIKE 'USA' 
		AND EXISTS
	 (SELECT P.[IDproduktu]
	 FROM mg.Produkty AS P
	 WHERE D.[IDdostawcy] = P.[IDdostawcy]);