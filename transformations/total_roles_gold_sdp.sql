CREATE OR REFRESH MATERIALIZED VIEW total_roles_gold_sdp
COMMENT "Employee count by role — business-ready aggregation."
AS SELECT
  Role,
  COUNT(*) AS TotalEmployees
FROM current_employees_silver_sdp
GROUP BY Role;
