# Databricks SDP Medallion Pipeline (Bronze → Silver → Gold)

A Bronze → Silver → Gold medallion pipeline defined declaratively in three SQL statements using **Lakeflow Spark Declarative Pipelines (SDP)** on Databricks. Built as the capstone of the Databricks Academy course *Get Started with Data Engineering on Databricks*.

Instead of writing orchestration code (task dependencies, job config, incremental loads), the pipeline only *describes* the tables — the SDP engine determines the execution order, manages incremental ingestion, and tracks data quality.

## Architecture

| Layer | Table | Type | Purpose |
| --- | --- | --- | --- |
| Bronze | `current_employees_bronze_sdp` | Streaming table | Incremental ingestion of CSV files from a Unity Catalog volume (`STREAM read_files`) |
| Silver | `current_employees_silver_sdp` | Materialized view | Cleaned data: uppercased `Role`, `processed_timestamp` / `processed_date`; data quality expectations `valid_id`, `valid_name` |
| Gold | `total_roles_gold_sdp` | Materialized view | Business-ready aggregation: employee count per role |

Dependency order (Bronze → Silver → Gold) is inferred automatically from the SQL — no task configuration needed.

## How to run

1. In Databricks, create an **ETL Pipeline** (Spark Declarative Pipeline) and add the `transformations/` folder as its source code.
2. Set the pipeline **destination** to your Unity Catalog catalog and schema.
3. Add pipeline **configuration** parameters:

   ```
   my_catalog = <your catalog>
   my_schema  = <your schema>
   ```

   These substitute the `${my_catalog}` / `${my_schema}` placeholders in the Bronze definition, which reads from `/Volumes/<catalog>/<schema>/myfiles/`.

4. Click **Start**. The three nodes appear as `current_employees_bronze_sdp` → `current_employees_silver_sdp` → `total_roles_gold_sdp`.

## What it demonstrates

- Medallion architecture (Bronze → Silver → Gold)
- Declarative, incremental ingestion with streaming tables and Auto Loader (`read_files`)
- Data quality expectations (`EXPECT`) with automatic pass/fail tracking
- Automatic dependency resolution and orchestration
- Published Unity Catalog tables with automatic lineage

## Result

With the course sample data (6 employees across two CSV files), the first pipeline update completes with 6 rows in Bronze, 6 rows in Silver (both expectations at 100 % pass), and 4 rows in Gold (one per role).
