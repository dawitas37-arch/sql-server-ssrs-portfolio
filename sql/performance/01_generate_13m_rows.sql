/* Run AFTER 00_create_database.sql, BEFORE adding the tuning index.
   WARNING: 13,000,000 rows can consume significant disk, transaction log space,
   and load time. Use a nonproduction instance with sufficient free storage.
   For a quick smoke test, set @TargetRows = 100000, then use a fresh database for full load.
   Script resumes from existing row count; do not mix manually inserted rows. */
USE SyntheticQueryTuning13M;
SET NOCOUNT ON;
DECLARE @TargetRows bigint = 13000000;
DECLARE @BatchSize int = 100000;
DECLARE @Existing bigint = (SELECT COUNT_BIG(*) FROM dbo.RequestEvents);
IF @Existing > @TargetRows THROW 51000, 'Existing rows exceed target. Stop and inspect data.', 1;

WHILE @Existing < @TargetRows
BEGIN
    DECLARE @RowsThisBatch int = CONVERT(int, CASE WHEN @TargetRows - @Existing < @BatchSize
                                                 THEN @TargetRows - @Existing ELSE @BatchSize END);
    ;WITH N AS
    (
        SELECT TOP (@RowsThisBatch)
               ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @Existing AS n
        FROM sys.all_objects AS a CROSS JOIN sys.all_objects AS b
    )
    INSERT dbo.RequestEvents (EventDate, TeamId, RegionId, StatusCode, DurationMinutes, SourceReference)
    SELECT DATEADD(MINUTE, CONVERT(int, n % 1440),
                   DATEADD(DAY, CONVERT(int, n % 1461), CONVERT(datetime2(0), '20230101', 112))),
           CONVERT(tinyint, 1 + n % 8),
           CONVERT(tinyint, 1 + (n / 7) % 4),
           CASE WHEN n % 11 = 0 THEN 'P' WHEN n % 17 = 0 THEN 'O' ELSE 'C' END,
           CONVERT(smallint, 1 + n % 240),
           CONCAT('SYN-', CONVERT(varchar(20), n))
    FROM N;

    SET @Existing += @RowsThisBatch;
    RAISERROR('Synthetic rows loaded: %I64d', 0, 1, @Existing) WITH NOWAIT;
END;
SELECT COUNT_BIG(*) AS LoadedRows, MIN(EventDate) AS FirstDate, MAX(EventDate) AS LastDate
FROM dbo.RequestEvents;
GO
