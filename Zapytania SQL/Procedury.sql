
/*CREATE PROCEDURE GetEmployeeAddress
AS
SELECT P.Adres FROM Pracownicy AS P
GROUP BY P.Adres;

EXEC GetAddress*/


/*CREATE PROCEDURE GetEmployeeAddressByCity @City varchar(50)
AS 
SELECT P.Kraj, P.Region, P.Miasto, P.Adres, P.KodPocztowy
FROM Pracownicy AS P
WHERE P.Miasto = @City
GROUP BY P.Kraj, P.Region, P.Miasto,P.Adres, P.KodPocztowy;

EXEC GetEmployeeAddressByCity @City = 'Londyn'*/

/*CREATE PROCEDURE GetEmployeeAddresCounts @City varchar(50) = NULL, @AddresCount int OUT
AS 
SELECT @AddresCount = COUNT(*)
FROM Pracownicy AS P
WHERE P.Miasto = @City
GROUP BY P.Miasto;

DECLARE @AddresCounts  int 
EXEC GetEmployeeAddresCounts 'Seattle', @AddresCount = @AddresCounts OUTPUT
SELECt @AddresCounts*/