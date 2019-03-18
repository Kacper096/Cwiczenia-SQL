USE [NorthwindZajecia]
GO

/*1.*/
/* Wy�wietli� dat� zam�wienia o najwy�szej warto�ci identyfikatora  (Data Zam�wienia, ID)*/
SELECT CAST(Z.[DataZam�wienia] AS DATE), Z.[IDzam�wienia]
FROM Zam�wienia AS Z
WHERE Z.[IDzam�wienia] = (SELECT TOP(1) MAX(Z2.[IDzam�wienia])
						  FROM Zam�wienia AS Z2);

/*2.*/
/*Wy�wietli� daty zam�wie�: o najni�szej i najwy�szej warto�ci identyfikatora (DataZam�wienia, IDzam�wienia), przyj�tych do realizacji w grudniu 1997*/
SELECT CAST(Z.[DataZam�wienia] AS DATE) AS [Data Zam.], Z.[IDzam�wienia] AS [ID zam.]
FROM Zam�wienia AS Z
WHERE Z.IDzam�wienia = (SELECT TOP(1) MAX(Z2.IDzam�wienia)
						FROM Zam�wienia AS Z2
						WHERE YEAR(Z2.DataZam�wienia) = 1997
							AND
							   MONTH(Z2.DataZam�wienia) = 12
						) 
					OR
	  Z.IDzam�wienia = (SELECT TOP(1) MIN(Z3.IDzam�wienia)
	                   FROM Zam�wienia AS Z3
					   WHERE YEAR(Z3.DataZam�wienia) = 1997
							AND
							   MONTH(Z3.DataZam�wienia) = 12
						);
						
/*3*/
/*Wy�wietli� zam�wienia przyj�te w styczniu 1998 przez pracownik�w, kt�rych nazwa nazwiska zaczyna si� na liter� "C" (IDzam�wienia,DataZam�wienia)*/
SELECT CAST(Z.[DataZam�wienia] AS DATE) AS [Data zam.], Z.[IDzam�wienia] AS [ID. zam.]
FROM Zam�wienia AS Z
WHERE  YEAR(Z.DataZam�wienia) = 1998 
		AND
       MONTH(Z.DataZam�wienia) = 1
	    AND
	   Z.IDpracownika = (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'C%'); 
/*4*/
/*Wy�wietli� zam�wienia przyj�te w styczniu 1998 roku przez pracownik�w, kt�rych nazwiska zaczynaj� si� od litery �A� (IDzam�wienia, Data
zam�wienia).*/
SELECT CAST(Z.[DataZam�wienia] AS DATE) AS [Data zam.], Z.[IDzam�wienia] AS [ID. zam.]
FROM Zam�wienia AS Z
WHERE  YEAR(Z.DataZam�wienia) = 1998 
		AND
       MONTH(Z.DataZam�wienia) = 1
	    AND
	   Z.IDpracownika = (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'A%');

/*5*/
/*Znale�� najcz�ciej i najrzadziej zamawiany towar w 1997 roku ID, Nazwa, Liczba zam�wie�.*/
SELECT P.[IDproduktu] AS [ID], P.[NazwaProduktu] AS [Nazwa], (SELECT TOP(1) COUNT(*)
															  FROM PozycjeZamowienia AS PZ
															  GROUP BY PZ.IDproduktu
															  ORDER BY COUNT(*) DESC) AS [Liczba zam�wie�]
FROM mg.Produkty AS P
WHERE P.IDproduktu = (SELECT TOP(1) P1.[IDproduktu]
					  FROM PozycjeZamowienia AS P1
					  GROUP BY P1.IDproduktu
					  ORDER BY COUNT(*) DESC)
UNION
SELECT P2.[IDproduktu] AS [ID], P2.[NazwaProduktu] AS [Nazwa], (SELECT TOP(1) COUNT(*)
															  FROM PozycjeZamowienia AS PZ2
															  GROUP BY PZ2.IDproduktu
															  ORDER BY COUNT(*) ) AS [Liczba zam�wie�]
FROM mg.Produkty AS P2
WHERE P2.IDproduktu = (SELECT TOP(1) P3.[IDproduktu]
				       	FROM mg.Produkty AS P3
						GROUP BY P3.IDproduktu
						ORDER BY COUNT(*));

/*6*/
/*Wy�wietli� zam�wienia przyj�te w styczniu 1998 roku przez pracownik�w, kt�rych nazwiska zaczynaj� si� od litery �D� (IDzam�wienia, Data
zam�wienia).*/
SELECT CAST(Z.[DataZam�wienia] AS DATE) AS [Data zam.], Z.[IDzam�wienia] AS [ID. zam.]
FROM Zam�wienia AS Z
WHERE  YEAR(Z.DataZam�wienia) = 1998 
		AND
       MONTH(Z.DataZam�wienia) = 1
	    AND
	   Z.IDpracownika IN (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'D%');
		
/*7*/
/*Wy�wietli� zam�wienia przyj�te w 13. stycznia 1998 roku przez pracownik�w, kt�rych nazwiska nie zaczynaj� si� od litery �D� (IDpracownika,
IDzam�wienia, Data zam�wienia).*/
SELECT CAST(Z.[DataZam�wienia] AS DATE) AS [Data zam.], Z.[IDzam�wienia] AS [ID. zam.], Z.[IDpracownika]
FROM Zam�wienia AS Z
WHERE  YEAR(Z.DataZam�wienia) = 1998 
		AND
       MONTH(Z.DataZam�wienia) = 1
	    AND
	   DAY(Z.DataZam�wienia) = 13
	    AND
	   Z.IDpracownika NOT IN (SELECT P.[IDpracownika]
		                 FROM Pracownicy AS P 
						 WHERE P.Nazwisko LIKE 'D%')
ORDER BY Z.[IDpracownika];

/*8*/
/*Wy�wietli� nazwiska i adresy pracownik�w, kt�rzy mieszkaj� w miastach wyst�puj�cych w adresach dostawc�w (IDpracownika, Nazwisko,
Miasto).*/
SELECT P.[IDpracownika] AS [ID], P.[Adres] AS [Adres], P.[Miasto] AS [Miasto]
FROM Pracownicy AS P 
WHERE P.[Miasto] = SOME (SELECT D.[Miasto]
					   FROM mg.Dostawcy AS D)
ORDER BY P.[Nazwisko];

/*9*/
/*Wy�wietli� nazwiska i adresy pracownik�w, kt�rzy mieszkaj� w miastach nie wyst�puj�cych w adresach dostawc�w (IDpracownika, Nazwisko,
Miasto).*/
SELECT P.[IDpracownika] AS [ID], P.[Adres] AS [Adres], P.[Miasto] AS [Miasto]
FROM Pracownicy AS P 
WHERE P.[Miasto] <> ALL (SELECT D.[Miasto]
					   FROM mg.Dostawcy AS D)
ORDER BY P.[Nazwisko];

/*10*/
/*Wy�wietli� nazwy firm oraz daty i numery ich ostatnich zam�wie� (IDklienta, IDzam�wienia, Data ostatniego zam�wienia).*/
SELECT Z.[IDklienta] AS [Klient], Z.[IDzam�wienia] AS [ID zam.], CAST(Z.[DataZam�wienia] AS DATE) AS [Data ostatniego zam.]
FROM Zam�wienia AS Z
WHERE Z.[DataZam�wienia] = (SELECT MAX(Z2.[DataZam�wienia])
							FROM Zam�wienia AS Z2
							WHERE Z.IDklienta = Z2.IDklienta)
ORDER BY Z.[IDklienta];

/*11*/
/*Wy�wietli� nazwy dostawc�w z USA, kt�rzy
dostarczyli jakiekolwiek produkty.*/
SELECT D.[NazwaFirmy] AS [Nazwa dostawcy], D.[Kraj] AS [Kraj]
FROM mg.Dostawcy AS D 
WHERE D.[Kraj] LIKE 'USA' 
		AND EXISTS
	 (SELECT P.[IDproduktu]
	 FROM mg.Produkty AS P
	 WHERE D.[IDdostawcy] = P.[IDdostawcy]);