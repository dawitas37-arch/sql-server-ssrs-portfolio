/*
  Both dataset procedures use inclusive start / exclusive end date filters.
  @TeamId and @RegionId = 0 means "all" in this fictional portfolio.
  Fixed fields make the results straightforward to map to SSRS datasets.
*/
USE SyntheticReportingPortfolio;
GO
CREATE OR ALTER PROCEDURE dbo.usp_ProgramActivitySummary
    @StartDate date,
    @EndDate date,
    @TeamId tinyint = 0,
    @RegionId tinyint = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @StartDate IS NULL OR @EndDate IS NULL OR @EndDate <= @StartDate
       THROW 51010,'EndDate must be after StartDate (exclusive).',1;
    SELECT
        CONCAT('Team ',TeamId) AS TeamName,
        CONCAT('Region ',RegionId) AS RegionName,
        ServiceCategory,
        COUNT_BIG(*) AS TotalRequests,
        SUM(CASE WHEN RequestStatus='Completed' THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS CompletedRequests,
        SUM(CASE WHEN RequestStatus='Pending' THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS PendingRequests,
        SUM(CASE WHEN RequestStatus='Overdue' THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS OverdueRequests
    FROM dbo.OperationsActivity
    WHERE ActivityDate >= @StartDate AND ActivityDate < @EndDate
      AND (@TeamId=0 OR TeamId=@TeamId)
      AND (@RegionId=0 OR RegionId=@RegionId)
    GROUP BY TeamId, RegionId, ServiceCategory;
END;
GO
CREATE OR ALTER PROCEDURE dbo.usp_MonthlyTrackingSummary
    @StartDate date,
    @EndDate date,
    @TeamId tinyint = 0,
    @RegionId tinyint = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @StartDate IS NULL OR @EndDate IS NULL OR @EndDate <= @StartDate
       THROW 51011,'EndDate must be after StartDate (exclusive).',1;
    SELECT
        DATEFROMPARTS(YEAR(ActivityDate),MONTH(ActivityDate),1) AS MonthStart,
        CONCAT('Team ',TeamId) AS TeamName,
        COUNT_BIG(*) AS TotalRequests,
        SUM(CASE WHEN RequestStatus='Completed' THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS CompletedRequests,
        SUM(CASE WHEN RequestStatus='Overdue' THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS OverdueRequests,
        SUM(CASE WHEN HasQualityFlag=1 THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) AS QualityFlags,
        CAST(AVG(CAST(ResolutionDays AS decimal(10,2))) AS decimal(10,2)) AS AvgResolutionDays
    FROM dbo.OperationsActivity
    WHERE ActivityDate >= @StartDate AND ActivityDate < @EndDate
      AND (@TeamId=0 OR TeamId=@TeamId)
      AND (@RegionId=0 OR RegionId=@RegionId)
    GROUP BY DATEFROMPARTS(YEAR(ActivityDate),MONTH(ActivityDate),1),TeamId;
END;
GO
