/* Run after both procedures exist. No fake benchmark numbers: this records real measurements.
   Test same parameters; cache, concurrent load and server hardware affect timings.
   Run multiple times, recording IO and CPU from SSMS Messages and actual plan. */
USE SyntheticQueryTuning13M;
GO
SELECT COUNT_BIG(*) AS RowCount FROM dbo.RequestEvents;
GO
CREATE TABLE #Baseline (TeamId tinyint, RegionId tinyint, RequestCount bigint, CompletedCount bigint, TotalDurationMinutes bigint);
CREATE TABLE #Optimized (TeamId tinyint, RegionId tinyint, RequestCount bigint, CompletedCount bigint, TotalDurationMinutes bigint);
INSERT #Baseline EXEC dbo.usp_RequestSummary_Baseline 2025, 2;
INSERT #Optimized EXEC dbo.usp_RequestSummary_Optimized 2025, 2;
IF EXISTS (SELECT * FROM #Baseline EXCEPT SELECT * FROM #Optimized)
   OR EXISTS (SELECT * FROM #Optimized EXCEPT SELECT * FROM #Baseline)
    THROW 51002, 'Result mismatch: optimized and baseline output differs.', 1;
PRINT 'PASS: baseline and optimized results match exactly for February 2025.';
DROP TABLE #Baseline, #Optimized;
GO
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
DECLARE @t datetime2(7), @baselineMs bigint, @optimizedMs bigint;
-- Use 3+ trials; separate executions are preferred for a rigorous benchmark.
SET @t = SYSDATETIME();
EXEC dbo.usp_RequestSummary_Baseline 2025, 2;
SET @baselineMs = DATEDIFF_BIG(MILLISECOND, @t, SYSDATETIME());
SET @t = SYSDATETIME();
EXEC dbo.usp_RequestSummary_Optimized 2025, 2;
SET @optimizedMs = DATEDIFF_BIG(MILLISECOND, @t, SYSDATETIME());
SELECT (SELECT COUNT_BIG(*) FROM dbo.RequestEvents) AS RowsInTable,
       @baselineMs AS BaselineElapsedMs,
       @optimizedMs AS OptimizedElapsedMs,
       CAST(CASE WHEN @baselineMs = 0 THEN NULL
                 ELSE 100.0 * (@baselineMs - @optimizedMs) / @baselineMs END AS decimal(9,2)) AS ImprovementPercent,
       CASE WHEN @optimizedMs < 45000 THEN 'PASS: optimized under 45 sec on this run'
            ELSE 'NOT UNDER 45 sec on this run' END AS TargetCheck;
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
