# --- Resources to Provision ---

# 1. Dedicated Warehouse for DE tasks
resource "snowflake_warehouse" "de_warehouse" {
  name                         = "DE_WH"
  warehouse_size               = "XSMALL"
  auto_suspend                 = 60
  auto_resume                  = true
  initially_suspended          = true
  statement_timeout_in_seconds = 3600
  comment                      = "Warehouse for Airflow ETL and dbt Transformations."
}

# 2. Dedicated Database
resource "snowflake_database" "jaffle_shop" {
  name    = "JAFFLE_SHOP"
  comment = "Database for the S3 -> Snowflake pipeline."
}

# 3. Raw Data Schema
resource "snowflake_schema" "raw_schema" {
  database    = snowflake_database.jaffle_shop.name
  name        = "RAW"
  comment     = "Schema to hold raw data loaded directly from S3."
  is_managed  = false
}

# 4. Raw Data Schema
resource "snowflake_schema" "staging_schema" {
  database    = snowflake_database.jaffle_shop.name
  name        = "STAGING"
  comment     = "Light transformations and formatting on top of RAW."
  is_managed  = false
}

# 5. Analytics/Transformed Data Schema
resource "snowflake_schema" "analytics_schema" {
  database    = snowflake_database.jaffle_shop.name
  name        = "ANALYTICS"
  comment     = "Models feeding from the clean STAGING schema."
  is_managed  = false
}

# Output the created names for reference
output "db_name" {
  value = snowflake_database.jaffle_shop.name
}

output "warehouse_name" {
  value = snowflake_warehouse.de_warehouse.name
}
