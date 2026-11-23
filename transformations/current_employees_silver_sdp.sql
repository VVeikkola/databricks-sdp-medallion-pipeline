CREATE OR REFRESH MATERIALIZED VIEW current_employees_silver_sdp (
  CONSTRAINT valid_id EXPECT (ID IS NOT NULL),
  CONSTRAINT valid_name EXPECT (FirstName IS NOT NULL)
)
COMMENT "Cleaned and enriched employee data with data quality expectations."
AS SELECT
  ID,
  FirstName,
  Country,
  UPPER(Role) AS Role,
  current_timestamp() AS processed_timestamp,
  current_date() AS processed_date
FROM current_employees_bronze_sdp;
