/* Tuning: SARGable range + covering index.
   Measure baseline first. Creating this index is a separate one-time operation;
   include its storage and write overhead in any real design decision. */
USE SyntheticQueryTuning13M;
GO
IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.RequestEvents')
      AND name = N'IX_RequestEvents_EventDate_Covering'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_RequestEvents_EventDate_Covering
    ON dbo.RequestEvents (EventDate)
    INCLUDE (TeamId, RegionId, StatusCode, DurationMinutes);
END;
GO
CREATE OR ALTER PROCEDURE dbo.usp_RequestSummary_Optimized
    @Year int = 2025,
    @Month int = 2
AS
BEGIN
    SET NOCOUNT ON;
    IF @Year NOT BETWEEN 1 AND 9998 OR @Month NOT BETWEEN 1 AND 12
        THROW 51001, 'Provide a valid year (1-9999) and month (1-12).', 1;
    DECLARE @StartDate date = DATEFROMPARTS(@Year, @Month, 1);
    DECLARE @EndDate date = DATEADD(MONTH, 1, @StartDate);
    SELECT TeamId, RegionId,
           COUNT_BIG(*) AS RequestCount,
           SUM(CASE WHEN StatusCode = 'C' THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS CompletedCount,
           SUM(CONVERT(bigint, DurationMinutes)) AS TotalDurationMinutes
    FROM dbo.RequestEvents
    WHERE EventDate >= @StartDate AND EventDate < @EndDate
    GROUP BY TeamId, RegionId;
END;
GO
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
-- In SSMS: Ctrl+M to include actual plan; look for index seek/range access.
EXEC dbo.usp_RequestSummary_Optimized @Year = 2025, @Month = 2;
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
