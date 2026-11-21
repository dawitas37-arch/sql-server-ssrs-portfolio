/*
  Loads exactly 50,000 *fabricated* activity records for reporting.
  Idempotent: when table contains rows it exits without duplicating them.
  Calendar dates and categories have no relationship to employer information.
*/
USE SyntheticReportingPortfolio;
GO
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM dbo.OperationsActivity)
BEGIN
    ;WITH N AS
    (
      SELECT TOP (50000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
      FROM sys.all_objects a CROSS JOIN sys.all_objects b
    )
    INSERT dbo.OperationsActivity
        (ActivityDate,TeamId,RegionId,ServiceCategory,RequestStatus,
         ResolutionDays,HasQualityFlag,SyntheticReference)
    SELECT
        DATEADD(DAY, CONVERT(int,(n-1)%730), CONVERT(date,'20250101',112)),
        CONVERT(tinyint,1+n%6),
        CONVERT(tinyint,1+(n/7)%4),
        CASE n%4 WHEN 0 THEN 'Enrollment' WHEN 1 THEN 'Eligibility'
                 WHEN 2 THEN 'Documentation' ELSE 'Support' END,
        CASE WHEN n%13=0 THEN 'Overdue' WHEN n%7=0 THEN 'Pending'
                 ELSE 'Completed' END,
        CASE WHEN n%13=0 OR n%7=0 THEN NULL ELSE CONVERT(smallint,1+n%12) END,
        CASE WHEN n%17=0 THEN CONVERT(bit,1) ELSE CONVERT(bit,0) END,
        CONCAT('DEMO-',CONVERT(varchar(15),n))
    FROM N;
END;
SELECT COUNT_BIG(*) AS SyntheticActivityRows FROM dbo.OperationsActivity;
GO
-- Helpful report filtering index; create AFTER loading the synthetic data.
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.OperationsActivity')
               AND name = 'IX_OperationsActivity_DateTeamRegion')
CREATE NONCLUSTERED INDEX IX_OperationsActivity_DateTeamRegion
ON dbo.OperationsActivity (ActivityDate,TeamId,RegionId)
INCLUDE(ServiceCategory,RequestStatus,ResolutionDays,HasQualityFlag);
GO
