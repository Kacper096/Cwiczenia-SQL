USE NorthwindZajecia

/* 1 */ 
/* Utowrzyæ tabelê oferta o schemacie tabeli Produkty */
/* Skopiowaæ dane z tabeli Produkty do Oferta */
SELECT * INTO Oferta
FROM mg.Produkty

/* 2 */
/* Utworzyæ tabelê Oferta_Modyfikacje( kolumny jak w tabeli Oferta + kolumny poni¿ej
[Stempel_czasowy] [datetime] NOT NULL,
[User] [nvarchar(256)] NOT NULL,
[Host] [nvarchar(128)] NOT NULL) */
SELECT * INTO Oferta_modyfikacje
FROM dbo.Oferta

ALTER TABLE Oferta_modyfikacje
ADD [Stempel_czasowy] DATETIME NOT NULL DEFAULT(0),
	[User] NVARCHAR(256) NOT NULL DEFAULT(0),
	[Host] NVARCHAR(128) NOT NULL DEFAULT(0)

/* 3 */
/* Utworzyæ wyzwalacz tr_Modyfikacja_ofert kopiuj¹cy dane sprzed modyfikacji do tabeli Oferta_Modyfikacje, podaj¹c
równoczeœnie czas modyfikacji, u¿ytkownika i host serwera. */
CREATE OR ALTER TRIGGER tr_Modyfikacja_ofert ON dbo.Oferta
FOR UPDATE
AS
	BEGIN
		DECLARE @stempCzas DATETIME, @user NVARCHAR(256), @host NVARCHAR(128)
		SET @stempCzas = GETDATE()
		SET @user = CURRENT_USER
		SET @host = HOST_NAME()

		INSERT INTO dbo.Oferta_modyfikacje 
			(IDproduktu,NazwaProduktu,IDdostawcy,IDkategorii,IloœæJednostkowa,CenaJednostkowa,StanMagazynu,IloœæZamówiona,StanMinimum,Wycofany,[Stempel_czasowy],
			[User],[Host])
		SELECT 
			IDproduktu,NazwaProduktu,IDdostawcy,IDkategorii,IloœæJednostkowa,CenaJednostkowa,StanMagazynu,IloœæZamówiona,StanMinimum,Wycofany,@stempCzas,
			@user,@host
		FROM deleted
	END

/* Sprwadzenie Triggera */
/* INSERT INTO Oferta(IDproduktu, NazwaProduktu, IDdostawcy, IDkategorii, IloœæJednostkowa, CenaJednostkowa, StanMagazynu, IloœæZamówiona, StanMinimum, Wycofany)
SELECT 2, 'Orzeszki', 16, 3, 5, 3.50, 1, 3, 1, 0

UPDATE Oferta
SET NazwaProduktu = 'OrzeszkiModif'
WHERE IDproduktu = 2 AND NazwaProduktu = 'Orzeszki'

SELECT * FROM Oferta
WHERE IDproduktu = 2

SELECT * FROM Oferta_Modyfikacje
WHERE IDproduktu = 2 */

/* 4 */
/* Sprawdziæ zawartoœæ tabel sys.triggers i sys.trigger_events.  */
SELECT * FROM sys.triggers
SELECT * FROM sys.trigger_events

/* 5 */
/* Sprawdziæ zawartoœæ tabeli Oferta_Modyfikacje. */
SELECT * FROM Oferta_Modyfikacje

/* 6 */ 
/* W tabeli Oferta, dla produktu o IDproduktu=1 zmodyfikowaæ StanMagazynu do wartoœci 150
Sprawdziæ zawartoœæ tabeli Oferta_Modyfikacje. */
UPDATE Oferta
SET StanMagazynu = 150
WHERE IDproduktu = 1

SELECT * FROM Oferta_modyfikacje
WHERE IDproduktu = 1

/* 7 */
/* Utworzyæ tabelê Oferta_modyfikacja_ceny(
[IDproduktu] [int] NOT NULL,
[NazwaProduktu] [nvarchar](40) NOT NULL,
[CenaJednostkowa_Old] [money] NULL,
[CenaJednostkowa_New] [money] NULL,
[Stempel_czasowy] [datetime] NOT NULL,
[User] [nvarchar] (256) NOT NULL,
[Host] [nvarchar] (128) NOT NULL) */
IF OBJECT_ID('dbo.Oferta_modyfikacja_ceny', 'U') IS NOT NULL
	DROP TABLE Oferta_modyfikacja_ceny
CREATE TABLE Oferta_modyfikacja_ceny (
	[IDproduktu] [int] NOT NULL,
	[NazwaProduktu] [nvarchar](40) NOT NULL,
	[CenaJednostkowa_Old] [money] NULL,
	[CenaJednostkowa_New] [money] NULL,
	[Stempel_czasowy] [datetime] NOT NULL,
	[User] [nvarchar] (256) NOT NULL,
	[Host] [nvarchar] (128) NOT NULL)

/* 8 */
/* Utworzyæ wyzwalacz tr_Modyfikacja_cen_ofert kopiuj¹cy, w przypadku modyfikacji cen produktów w tabeli Oferta
odpowiednie dane do tabeli Oferta_modyfikacje_ceny, podaj¹c równoczeœnie czas modyfikacji, u¿ytkownika i host
serwera.*/
IF OBJECT_ID('tr_Modyfikacja_cen_ofert','U') IS NOT NULL
 DROP TRIGGER tr_Modyfikacja_cen_ofert

CREATE OR ALTER TRIGGER tr_Modyfikacja_cen_ofert ON dbo.Oferta
FOR UPDATE
AS 
	BEGIN 
		DECLARE @starCena MONEY, @nowCena MONEY,@stempCzas DATETIME, @user NVARCHAR(256), @host NVARCHAR(128)
		SET @user = CURRENT_USER
		SET @stempCzas = GETDATE()
		SET @host = HOST_NAME()
		SET @starCena = (SELECT TOP 1 CenaJednostkowa FROM deleted WHERE IDproduktu IN (SELECT IDproduktu FROM dbo.Oferta))
		SET @nowCena = (SELECT TOP 1 CenaJednostkowa FROM inserted WHERE IDproduktu IN (SELECT IDproduktu FROM dbo.Oferta))

		IF (@nowCena > @starCena AND @nowCena > 0)
			BEGIN
			INSERT INTO dbo.Oferta_modyfikacja_ceny(
				IDproduktu, NazwaProduktu, CenaJednostkowa_Old, CenaJednostkowa_New, Stempel_czasowy, [User], [Host])
			SELECT IDproduktu, NazwaProduktu, @starCena, @nowCena, @stempCzas, @user, @host
			FROM inserted
			WHERE IDproduktu IN (SELECT IDproduktu FROM dbo.Oferta)
			END
	END

/* 9 */
/* W tabeli Oferta, dla produktu o (IDproduktu = 2) zmodyfikowaæ StanMagazynu do wartoœci 2000.
Sprawdziæ zawartoœæ tabeli Oferta.
Sprawdziæ zawartoœæ tabeli Oferta_modyfikacja_ceny. */
UPDATE Oferta
SET StanMagazynu = 2000
WHERE IDproduktu = 2

SELECT * FROM Oferta
WHERE IDproduktu = 2

SELECT * FROM Oferta_modyfikacja_ceny
WHERE IDproduktu = 2

/* 10 */
/* W tabeli Oferta, dla produktu o (IDproduktu = 3) zmodyfikowaæ CenaJednostkowa do wartoœci 16.99.
Sprawdziæ zawartoœæ tabeli Oferta.
Sprawdziæ zawartoœæ tabeli Oferta_modyfikacja_ceny */
UPDATE Oferta 
SET CenaJednostkowa = 16.99
WHERE IDproduktu = 3

SELECT * FROM Oferta
WHERE IDproduktu = 3

SELECT * FROM Oferta_modyfikacje
WHERE IDproduktu = 3

SELECT * FROM Oferta_modyfikacja_ceny
WHERE IDproduktu = 3

/* 11 */ 
/* . Opracowaæ wyzwalacze sprawdzaj¹ce poprawnoœæ nowych danych wprowadzanych do tabeli Oferta, dla kryteriów
jak poni¿ej:
a. CenaJednostkowa > 0;
b. StanMagazynu > 0. */
IF OBJECT_ID('tr_Modyfikacja_cen_CHECK','U') IS NOT NULL
 DROP TRIGGER tr_Modyfikacja_cen_CHECK

CREATE OR ALTER TRIGGER tr_Modyfikacja_cen_CHECK ON Oferta
INSTEAD OF UPDATE
AS 
	BEGIN 
		DECLARE @nowCen MONEY, @nowStMag SMALLINT
		SET @nowCen = (SELECT TOP 1 CenaJednostkowa FROM inserted WHERE IDproduktu IN (SELECT IDproduktu FROM dbo.Oferta))
		SET @nowStMag = (SELECT TOP 1 StanMagazynu FROM inserted WHERE IDproduktu IN (SELECT IDproduktu FROM dbo.Oferta))
		BEGIN
			IF(@nowCen = 0)
				BEGIN 
					PRINT 'Nowa cena nie mo¿e byæ zerem'
					RETURN
				END
			IF(@nowStMag = 0)
				BEGIN
					PRINT 'Nowy stan magazynu nie mo¿e byæ zerem'
					RETURN
				END
		END
		RETURN
	END

UPDATE Oferta
SET CenaJednostkowa = 0
WHERE IDproduktu = 1

SELECT * from Oferta
where IDproduktu = 1

