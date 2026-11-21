/*
  PORTFOLIO LAB: synthetic operational reporting tables.
  Run on your OWN SQL Server development instance only.
  Independent fictional example, not copied from employer reports.
  The reporting module is deliberately separate from the 13M-row performance lab.
*/
IF DB_ID(N'SyntheticReportingPortfolio') IS NULL
    CREATE DATABASE SyntheticReportingPortfolio;
GO
USE SyntheticReportingPortfolio;
GO
IF OBJECT_ID(N'dbo.OperationsActivity', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.OperationsActivity
    (
        ActivityId bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OperationsActivity PRIMARY KEY,
        ActivityDate date NOT NULL,
        TeamId tinyint NOT NULL,
        RegionId tinyint NOT NULL,
        ServiceCategory varchar(30) NOT NULL,
        RequestStatus varchar(12) NOT NULL,
        ResolutionDays smallint NULL,
        HasQualityFlag bit NOT NULL,
        -- Synthetic reference, NEVER an actual person or application identifier
        SyntheticReference varchar(32) NOT NULL
    );
END;
GO
