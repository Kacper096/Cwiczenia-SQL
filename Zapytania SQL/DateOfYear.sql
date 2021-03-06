USE [NorthwindZajecia]
GO
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfYear]    Script Date: 18.01.2019 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[GetNumberOfYear](@date AS DATETIME)
RETURNS INT
AS 
BEGIN
	DECLARE @licznik AS INT, @year AS INT, @month AS nvarchar(10), @day AS INT, @temp AS INT
	SET @year = CONVERT(int,SUBSTRING(CONVERT(nvarchar(4),@date,102),1,4))
	SET @month = SUBSTRING(CONVERT(nvarchar(10),@date,102),6,2)
	SET @day = CONVERT(int,SUBSTRING(CONVERT(nvarchar(10),@date,102),9,2))
		BEGIN
			IF(@month > 2)
				BEGIN SET  @licznik = 59 + @day
					WHILE(@month > 3)
						BEGIN 
						IF(@month % 2 = 0)
							BEGIN
								SET @licznik = @licznik + 31
								SET @month = @month - 1
							END
						ELSE 
							BEGIN 
								SET @licznik = @licznik + 30
								SET @month = @month - 1
							END
						END
					IF((@year % 4 = 0 AND @year % 100 <> 0) OR @year % 400 = 0)
						SET @licznik = @licznik + 1;
				END
			ELSE
				IF(@month = 2)
					SET @licznik = 31 + @day
				ELSE 
					SET @licznik = @day
			END
			RETURN @licznik
END