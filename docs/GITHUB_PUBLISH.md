# GitHub publishing checklist

1. Review the folder thoroughly and confirm no employer code, data, credentials, connection details or screenshots are present.
2. On GitHub, create a public repository called `sql-server-ssrs-portfolio` (or reuse an existing personal portfolio repository).
3. Choose **Add file → Upload files**; drag the **contents** of this extracted project folder (not the ZIP itself). Keep `sql/`, `ssrs/`, `docs/`, `results/`, and `screenshots/` paths intact.
4. Commit with the message `Add SQL tuning and SSRS portfolio`.
5. In SSMS, run the lab on a local SQL Server instance, fill `results/benchmark_template.csv` and the results document with actual measurements, and add screenshots captured only with synthetic data.
6. Validate the reports in Report Builder/SSDT, and upload the locally tested generic RDL files if edits are needed.
7. Pin the repository to the GitHub profile. Link it in the Projects section of the resume, not as evidence of verified historical benchmark figures.

Note: GitHub displays .sql/.md directly and offers RDL files for download. Reports generally require SSRS-compatible tools to preview.
