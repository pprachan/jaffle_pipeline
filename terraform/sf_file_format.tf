resource "snowflake_file_format" "csv_comma_format" {
  name        = "CSV_COMMA_FORMAT"
  database    = "JAFFLE_SHOP"
  schema      = "RAW"

  format_type = "CSV"

  field_delimiter            = ","
  skip_header                = 1
  null_if                    = ["NULL", "null"]
  empty_field_as_null        = true
  field_optionally_enclosed_by = "\""
  compression                = "AUTO"
}

resource "snowflake_file_format" "csv_header_format" {
  name        = "CSV_HEADER_FORMAT"
  database    = "JAFFLE_SHOP"
  schema      = "RAW"
  format_type = "CSV"
  field_delimiter            = "\ts"
  skip_header                = 0
  null_if                    = ["NULL", "null"]
  empty_field_as_null        = true
  field_optionally_enclosed_by = "\""
  compression                = "AUTO"
}