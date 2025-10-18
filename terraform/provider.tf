# Define the required providers and their versions
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.90.0"
    }
  }
}

# --- Provider Configuration ---

# This block configures the Snowflake provider using the variables defined
# in variables.tf (which are sourced from environment variables).
provider "snowflake" {
  account   = var.SNOWFLAKE_ACCOUNT
  user      = var.SNOWFLAKE_USER
  password  = var.SNOWFLAKE_PASS
  role      = var.SNOWFLAKE_ROLE
  warehouse = var.SNOWFLAKE_WAREHOUSE
}