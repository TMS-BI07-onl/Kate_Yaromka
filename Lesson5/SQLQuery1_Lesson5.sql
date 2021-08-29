DROP TABLE dbo.Patients


CREATE TABLE dbo.Patients
(
	ID INT PRIMARY KEY IDENTITY(1,1),
	FirstName NVARCHAR(100),
	LastName NVARCHAR(100) NOT NULL,
	SSN uniqueidentifier NOT NULL DEFAULT NEWID(),
	Email AS UPPER(LEFT(FirstName, 1)) + LOWER(LEFT(LastName, 3)) + '@mail.com',
	Temp INT,
	CHECK (Temp BETWEEN 0 and 45),
	CreateDate Date
)

INSERT INTO Patients (FirstName, LastName, Temp, CreateDate)
VALUES
    ('Ivanov', 'Ivan', 35, '1995-03-01'),
    ('Petrov', 'Ivan', 45, '1995-05-01')

INSERT INTO Patients (FirstName, LastName, Temp, CreateDate)
VALUES
    ('Sidorov', 'Pavel', 43, '1995-03-01'),
    ('Sokolov', 'Vlad', 30, '1995-05-01')

SELECT *
FROM Patients

ALTER TABLE Patients
ADD TempType AS 
	CASE 
		WHEN Temp < 38 THEN '<38°C'
		WHEN Temp >= 38 THEN '>=38°C'
	END

ALTER TABLE Patients DROP COLUMN TempType


CREATE VIEW  Patients_v
WITH SCHEMABINDING
AS
SELECT ID, FirstName, LastName, SSN, Email, Temp = Temp * 9/5 + 32, CreateDate
FROM dbo.Patients   


DROP View Patients_v


SELECT *
FROM Patients_v


CREATE FUNCTION Convert_CtoF (@TempC INT) 
RETURNS INT 
AS 
BEGIN 
	RETURN @TempC * 9/5 + 32 
END

SELECT FirstName, Temp, TempF = dbo.Convert_CtoF(Temp)
FROM Patients 


SELECT dbo.Convert_CtoF(45)

DECLARE @formateddate DATE = FORMAT(GETDATE(), 'yyyy-MM-01')
SELECT GETDATE(),
	CASE DATEPART(WEEKDAY, @formateddate)
		WHEN 6 THEN DATEADD(DAY, 2, @formateddate)
		WHEN 7 THEN DATEADD(DAY, 1, @formateddate)
		ELSE @formateddate
	END AS [First weekday]