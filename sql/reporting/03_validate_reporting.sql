/* Run after 00-02. Results must be synthetic and internally consistent. */
USE SyntheticReportingPortfolio;
GO
IF (SELECT COUNT_BIG(*) FROM dbo.OperationsActivity) <> 50000
 THROW 51012,'Expected exactly 50,000 synthetic rows.',1;
-- A status must be exactly one of the modeled categories.
IF EXISTS(SELECT 1 FROM dbo.OperationsActivity
          WHERE RequestStatus NOT IN ('Completed','Pending','Overdue'))
 THROW 51013,'Unrecognized request status.',1;
-- Distinct reporting stored procedures, suitable for independent SSRS datasets.
EXEC dbo.usp_ProgramActivitySummary @StartDate='20260101',@EndDate='20270101';
EXEC dbo.usp_MonthlyTrackingSummary @StartDate='20260101',@EndDate='20270101';
PRINT 'PASS: synthetic source rows verified; inspect both dataset result sets.';
GO
