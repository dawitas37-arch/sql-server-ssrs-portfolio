/* Personal portfolio demonstration: synthetic data only. Run on a LOCAL/TEST SQL Server instance.
   SQL Server 2019+ recommended. This creates a new database; it does not touch existing databases. */
IF DB_ID(N'SyntheticQueryTuning13M') IS NULL
    CREATE DATABASE SyntheticQueryTuning13M;
GO
USE SyntheticQueryTuning13M;
GO
IF OBJECT_ID(N'dbo.RequestEvents', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.RequestEvents
    (
        EventId          bigint IDENTITY(1,1) NOT NULL,
        EventDate        datetime2(0) NOT NULL,
        TeamId           tinyint NOT NULL,
        RegionId         tinyint NOT NULL,
        StatusCode       char(1) NOT NULL,
        DurationMinutes  smallint NOT NULL,
        SourceReference  varchar(40) NOT NULL,
        CONSTRAINT PK_RequestEvents PRIMARY KEY CLUSTERED (EventId)
    );
END;
GO
