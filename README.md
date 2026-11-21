# SQL Server Query Optimization & SSRS Reporting Portfolio

An **independent** SQL Server + SSRS portfolio demonstration using **100% synthetic data**. It illustrates the types of T-SQL, query tuning, stored procedure, report dataset, and SSRS development techniques used in professional reporting work. **No employer database, code, reports, confidential data, identifiers, or connections are included.**

> **Benchmark integrity:** My resume describes a separate historical optimization of a query over roughly 13 million records, improving runtime from ~2 minutes to under 45 seconds. **Those historical numbers have not been reproduced or verified by this portfolio lab.** This lab uses a new, fictional dataset. Actual demo performance numbers should only be published after measurement on a local SQL Server instance.

## What this project demonstrates

- **13M-row SQL performance lab:** deliberately non-SARGable date predicates vs. a date-range rewrite with a covering nonclustered index, captured execution plans, logical reads, CPU, and elapsed time.
- **SSRS sample reports:** parameterized datasets and stored procedures for a generic **Program Activity Summary** and **Monthly Tracking Summary**. These are original fictional examples, **not copies** of internal CA or MCTA reports.
- **SQL validation:** matching result sets between baseline and optimized queries, source row-count checks, and consistent report aggregates.
- **Clear, commented scripts:** the `sql/` folder is numbered to reflect the order of operations and the reason for each change.

## Reproduce: SQL performance tuning

**Prerequisites:** Personal SQL Server 2019+ instance with ample free disk/log space, SSMS; permissions to create a local lab database. Loading 13M rows can consume significant storage and time. Never run in a company environment.

Execute in order in SSMS:

1. `sql/performance/00_create_database.sql` — creates `SyntheticQueryTuning13M` and `dbo.RequestEvents`.
2. `sql/performance/01_generate_13m_rows.sql` — generates 13,000,000 synthetic rows in batches (use a fresh DB and change 13M to 100K for a smoke test).
3. `sql/performance/02_baseline.sql` — baseline stored procedure and query, capture actual plan and `STATISTICS IO/TIME`.
4. `sql/performance/03_add_index_and_optimized.sql` — covering index and date-range stored procedure; capture plan and stats.
5. `sql/performance/04_validate_and_benchmark.sql` — proves identical baseline and optimized aggregate outputs and captures a first elapsed-time comparison.

Record repeat trials in `results/benchmark_template.csv`, then summarize them in `results/BENCHMARK_RESULTS.md`. The exact runtime is hardware-, cache-, distribution-, and environment-dependent. Separately note that indexing has storage/write costs; do not claim every query becomes faster.

## Reproduce: SQL Server Reporting Services

1. Run `sql/reporting/00_create_reporting_schema.sql` — creates a *separate* `SyntheticReportingPortfolio` database.
2. Run `sql/reporting/01_load_synthetic_data.sql` — generates 50,000 entirely fabricated records plus a reporting index.
3. Run `sql/reporting/02_reporting_procedures.sql` — creates `usp_ProgramActivitySummary` and `usp_MonthlyTrackingSummary`.
4. Run `sql/reporting/03_validate_reporting.sql` — validates count and executes both report datasets.
5. Open `ssrs/Program_Activity_Summary.rdl` or `ssrs/Monthly_Tracking_Summary.rdl` in a compatible Report Builder/SSDT version. Point `SyntheticPortfolioDataSource` to **your own** SQL Server instance and test/refresh fields and parameters before use. The RDLs are starter report layouts and have **not been rendered in Report Builder in this environment**.

Stored procedure parameters: `@StartDate`, `@EndDate` (**end exclusive**), `@TeamId` and `@RegionId` (`0` = all).

## Files

```text
sql/performance/00..04_*.sql       SQL Server 13-million-row benchmark lab
sql/reporting/00..03_*.sql         Fictional reporting database and stored procedures
ssrs/Program_Activity_Summary.rdl   Program activity report starter
ssrs/Monthly_Tracking_Summary.rdl  Monthly tracking report starter
docs/SSRS_DEVELOPMENT.md           How to edit, preview, troubleshoot and document
docs/GITHUB_PUBLISH.md             GitHub upload walkthrough
results/benchmark_template.csv     Fill with actual repeated run measurements
results/BENCHMARK_RESULTS.md       Results template (not benchmark evidence yet)
screenshots/README.md              Screenshot checklist
```

## Skills represented

Microsoft SQL Server • T-SQL • Stored Procedures • Execution Plans • Covering Indexes • Query Performance Tuning • SSRS • Report Builder / SSDT • Parameters • Report Datasets • Data Validation • Git / GitHub

## Security and provenance

All synthetic records, generic labels, schemas, and report layouts were created independently for a public portfolio. Do not upload original company RDL/PBIX/SQL, internal screenshots, credentials, server names, personal information, or employer proprietary business logic. This is not an official employer project.
