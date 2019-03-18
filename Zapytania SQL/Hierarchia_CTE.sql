
WITH rekur_CTE
AS
(
	SELECT P.IDpracownika,P.Szef,P.Imiê,P.Nazwisko,P.Stanowisko, 0 AS Organizatio_level
	FROM dbo.Pracownicy AS P
	WHERE P.Szef IS NULL

	UNION ALL

	SELECT P.IDpracownika,P.Szef,P.Imiê,P.Nazwisko,P.Stanowisko, Organizatio_level + 1
	FROM dbo.Pracownicy AS P
	INNER JOIN rekur_CTE AS r
		ON P.Szef = r.IDpracownika
)
SELECT * FROM rekur_CTE;