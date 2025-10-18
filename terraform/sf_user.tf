resource "snowflake_user" "dbt_user" {
    name = "DBT_USER"
    password = "dbt_user*A123"
    default_warehouse = "DE_WH"
    default_role = "SYSADMIN"
    must_change_password = false
    comment = "Service user for dbt Core"
}