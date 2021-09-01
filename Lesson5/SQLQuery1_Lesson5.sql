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

INSERT INTO Patients (FirstName, LastName, Temp, CreateDate)
VALUES
    ('Sidorov', 'Pavel', 50, '1995-03-01'),
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

set datefirst 1
DECLARE @DateFormat DATE = FORMAT(GETDATE(), 'yyyy-MM-01')
SELECT CONVERT(date, GETDATE()) AS 'Текущая дата',
	CASE DATEPART(WEEKDAY, @DateFormat)
		WHEN 6 THEN DATEADD(DAY, 2, @DateFormat)
		WHEN 7 THEN DATEADD(DAY, 1, @DateFormat)
		ELSE @DateFormat
	END AS [Первый рабочий день]


declare @startdate date, @enddate date;
 
select
 @startdate = dateadd(day, -day(getdate()) + 1, cast(getdate() as date)),
 @enddate = dateadd(day, -1, dateadd(month, 1, @startdate));


   SELECT TABLE_NAME AS [Имя таблицы],
           COLUMN_NAME AS [Имя столбца],
           DATA_TYPE AS [Тип данных столбца],
           IS_NULLABLE AS [Значения NULL]
   FROM AdventureWorks2017.INFORMATION_SCHEMA.COLUMNS
   WHERE table_name='Person.Address'

--
EXEC sp_columns [Address]

SELECT DATEPART(WEEKDAY, '2021-08-29') 'Day Name'
		--WHEN 6 THEN DATEADD(DAY, 2, @formateddate)
		--WHEN 7 THEN DATEADD(DAY, 1, @formateddate)
		--ELSE @formateddate
	--END AS [First weekday]


set datefirst 1;
DECLARE @formateddate DATE = FORMAT(GETDATE(), 'yyyy-MM-01')
SELECT DATEPART(weekday, @formateddate) 'Day Name'


SELECT GETDATE() 'Today', DATENAME(weekday,GETDATE()) 'Day Name'