USE [Northwind]
GO

SELECT P.LastName,P.FirstName, P.Title
FROM [Employees] AS P;

SELECT P.LastName AS [Nazwisko], P.FirstName AS [Imiê], P.Title AS [Stanowisko], P.Country AS [Kraj]
FROM [Employees] AS P
WHERE P.Country LIKE 'USA';

SELECT *
FROM [Customers] AS C
WHERE C.CompanyName LIKE 'Alfreds Futterkiste';

SELECT S.[SupplierID], S.[CompanyName], S.[Address] + ' / ' + S.[City] AS [Address / City], S.[Phone]
FROM [Suppliers] AS S
INNER JOIN [Products] AS P ON S.[SupplierID] = P.[SupplierID]
WHERE P.[ProductName] LIKE 'Chocolade';

SELECT YEAR(O.[OrderDate]) AS [Rok],
		MONTH(O.[OrderDate]) AS [Miesi¹c],
		SUM(OD.[UnitPrice] * OD.[Quantity]) AS [Sprzedaz]
FROM [Orders] AS O
INNER JOIN [Order Details] AS OD ON O.[OrderID] = OD.[OrderID]
WHERE O.[OrderDate] >= '19960101' AND O.[OrderDate] < '19970101'
GROUP BY YEAR(O.[OrderDate]), MONTH(O.[OrderDate])
ORDER BY [Sprzedaz];

SELECT  COUNT(P.[EmployeeID])
FROM [Employees] AS P;

SELECT P.[ProductID],P.[ProductName], P.[UnitPrice]
FROM [Products] AS P
WHERE P.[Discontinued] LIKE 0;

SELECT E.[FirstName],E.[LastName]
FROM [Employees] AS E
WHERE E.[LastName] LIKE 'D%';


