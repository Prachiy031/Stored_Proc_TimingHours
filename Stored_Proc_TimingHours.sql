CREATE DATABASE Project;

CREATE TABLE Dates
(
  Start_Date DATE,
  End_Date DATE
)

INSERT INTO Dates
VALUES('2023-07-12','2023-07-13'),
      ('2023-07-01','2023-07-17');


CREATE TABLE Output
(
  Start_Date DATE,
  End_Date DATE,
  No_Of_Hours INT
);
GO

--procedure
CREATE PROCEDURE spGetNoOfHours

@StartDate DATE,
@EndDate DATE
AS
BEGIN
  DECLARE @CurrentDate DATE;   --var to keep track of current date
  DECLARE @NoOfHours INT = 0; --var to keep track of no.of hours

  SET @CurrentDate = @StartDate;  --set current date as initial date

  WHILE @CurrentDate <= @EndDate
  BEGIN
  --check if current date is sunday --by default value of sunday is 1 in sql server
  IF DATEPART(WEEKDAY,@CurrentDate) = 1 OR
     DATEPART(WEEKDAY,@CurrentDate) = 7 AND --OR SAT BY DEAF 7
	 (DATEPART(DAY,@CurrentDate) <=7 OR --this is 1st sat
     (DATEPART(DAY,@CurrentDate) > 7 AND DATEPART(DAY,@CurrentDate)<=14)) --this is sec sat
  BEGIN
  --check if current date is start or end date(if start or end date is sunday or 1st/2nd sat then count them)
    IF @CurrentDate = @StartDate OR @CurrentDate = @EndDate
    BEGIN
       SET @NoOfHours = @NoOfHours + 24;
    END
  END
     ELSE
   BEGIN
	  --include all other working days
	   SET @NoOfHours = @NoOfHours + 24;
   END

	--move to next date
	SET @CurrentDate = DATEADD(DAY,1,@CurrentDate);
  END;

  INSERT INTO Output
  VALUES(@StartDate,@EndDate,@NoOfHours);
END;
GO


EXEC spGetNoOfHours'2023-07-12', '2023-07-13';
EXEC spGetNoOfHours'2023-07-01', '2023-07-17';
GO

SELECT * FROM Output
--FINAL OUTPUT
