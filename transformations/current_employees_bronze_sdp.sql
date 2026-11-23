CREATE OR REFRESH STREAMING TABLE current_employees_bronze_sdp
COMMENT "Raw employee data ingested from CSV files in the myfiles volume."
AS SELECT *
FROM STREAM read_files(
  '/Volumes/${my_catalog}/${my_schema}/myfiles/',
  format => 'csv',
  header => true,
  inferSchema => true
);
