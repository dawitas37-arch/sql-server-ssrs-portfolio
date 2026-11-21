/* Baseline: intentionally non-SARGable YEAR/MONTH predicates; no date index yet.
   Produces team/region aggregates for February 2025. Run BEFORE 03_add_index.sql. */
USE SyntheticQueryTuning13M;
GO
CREATE OR ALTER PROCEDURE dbo.usp_RequestSummary_Baseline
    @Year int = 2025,
    @Month int = 2
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TeamId, RegionId,
           COUNT_BIG(*) AS RequestCount,
           SUM(CASE WHEN StatusCode = 'C' THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS CompletedCount,
           SUM(CONVERT(bigint, DurationMinutes)) AS TotalDurationMinutes
    FROM dbo.RequestEvents
    WHERE YEAR(EventDate) = @Year AND MONTH(EventDate) = @Month
    GROUP BY TeamId, RegionId;
END;
GO
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
-- In SSMS: Query -> Include Actual Execution Plan (Ctrl+M), then execute.
EXEC dbo.usp_RequestSummary_Baseline @Year = 2025, @Month = 2;
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
