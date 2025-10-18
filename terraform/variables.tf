# --- Variable Declarations (Input/Credentials) ---

variable "SNOWFLAKE_USER" {
  description = "Snowflake username for the connection."
  type        = string
  sensitive   = true
}

variable "SNOWFLAKE_PASS" {
  description = "Snowflake password for the connection."
  type        = string
  sensitive   = true
}

variable "SNOWFLAKE_ACCOUNT" {
  description = "Snowflake account identifier (e.g., xy12345.us-east-1)."
  type        = string
}

variable "SNOWFLAKE_ROLE" {
  description = "The default role to use for provisioning."
  type        = string
  default     = "SYSADMIN"
}

variable "SNOWFLAKE_WAREHOUSE" {
  description = "The warehouse used by the provider for execution."
  type        = string
  default     = "COMPUTE_WH"
}
