# SSRS build and review walkthrough

The two RDL files are **starter templates** with generic data sources and fixed field mappings, not exact reproductions of any company reports. XML well-formedness is checked; compatibility and rendering must be checked on your own Report Builder or SSDT installation.

## Program Activity Summary
- Dataset: `dbo.usp_ProgramActivitySummary`
- Parameters: `StartDate`, `EndDate` (exclusive), `TeamId` and `RegionId` (`0` = all)
- Columns: team, region, service category, total, completed, pending, overdue.

## Monthly Tracking Summary
- Dataset: `dbo.usp_MonthlyTrackingSummary`
- Same parameter conventions as above.
- Columns: month, team, total, completed, overdue, quality flags, average resolution days.

## Open locally
1. Execute all `sql/reporting/` scripts in sequence in **your local SQL Server**, not in work environments.
2. Open an `.rdl` in Report Builder or an SSRS-supported SSDT project. If prompted to upgrade the report-definition schema, save the upgraded file as a new local copy.
3. Edit `SyntheticPortfolioDataSource` and point to **your own** server + `SyntheticReportingPortfolio`, use Windows Authentication (or your local approved authentication method).
4. Verify dataset properties: Command Type = Stored Procedure, matching parameter bindings and refreshed fields.
5. Preview both reports for full-year dates. Check totals, NULL handling, month sorting, and formatting. Improve titles, tables, number formatting, date formatting, and page breaks as desired.
6. Save only the newly created generic `.rdl` reports; do not mix in employer reports.

## Troubleshooting approach to document in interview
- **Parameter mismatch:** confirm report parameter types and `@StartDate`, `@EndDate`, `@TeamId`, `@RegionId` dataset parameter mappings.
- **Unexpected duplicates:** check dataset grouping/joins and confirm SUM vs COUNT in the stored procedure.
- **Missing records:** verify date range uses `>= @StartDate AND < @EndDate`, and test filters independently.
- **Slow report:** execute stored procedure directly in SSMS, inspect actual plan, `STATISTICS IO` and `STATISTICS TIME`, check indexes and row counts.
- **Unexpected NULLs:** resolution days are NULL when the synthetic request is not completed; SQL AVG ignores NULLs.

## Screenshot evidence
Capture only **local synthetic** screenshots of SSMS Messages, execution plans, the report dataset, parameters, and report preview. Never use employer screenshots.
