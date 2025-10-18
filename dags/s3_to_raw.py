from datetime import datetime
import re
from airflow import DAG
from airflow.sdk import task
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook

# --- Configuration ---
STAGE_NAME = "@jaffle_shop.raw.s3_external_stage"
DATABASE_NAME = "JAFFLE_SHOP"
SCHEMA_NAME = "RAW"
FILE_FORMAT = "CSV_COMMA_FORMAT"           # normal file format for COPY INTO
FILE_HEADER_FORMAT = "CSV_HEADER_FORMAT"     # new format to read full header line
SNOWFLAKE_CONN_ID = "snowflake_conn"

# --- Helpers ---
def sanitize_table_name(filename: str) -> str:
    """Convert filename to a safe Snowflake table name."""
    name = filename.replace(".csv", "").lower()
    name = re.sub(r"[^a-z0-9_]", "_", name)
    return name

# --- DAG ---
with DAG(
    dag_id="s3_to_raw",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=["snowflake", "s3","raw"],
) as dag:

    @task
    def list_stage_files() -> list[str]:
        """List all CSV files in the Snowflake stage."""
        hook = SnowflakeHook(snowflake_conn_id=SNOWFLAKE_CONN_ID)
        results = hook.get_records(f"LIST {STAGE_NAME};")
        files = [r[0] for r in results if r[0].endswith(".csv")]
        return files

    @task
    def create_table_and_copy(file_path: str):
        """Create a table from CSV and copy data into it."""
        filename = file_path.split("/")[-1]
        table_name = sanitize_table_name(filename)

        hook = SnowflakeHook(snowflake_conn_id=SNOWFLAKE_CONN_ID)
        print(f"Processing file: {filename} → table: {SCHEMA_NAME}.{table_name}")

        # 1️⃣ Extract full header row using CSV_HEADER_LINE
        header_sql = f"""
            SELECT $1
            FROM {STAGE_NAME}/{filename} (FILE_FORMAT => {FILE_HEADER_FORMAT})
            LIMIT 1;
        """
        result = hook.get_first(header_sql)
        if not result or not result[0]:
            raise ValueError(f"No header found in file {filename}")

        header_line = result[0].strip()
        columns = [col.strip().replace('"', '') for col in header_line.split(",")]

        # 2️⃣ Create table with all columns
        create_sql = f"""
            CREATE OR REPLACE TABLE {DATABASE_NAME}.{SCHEMA_NAME}.{table_name} (
                {', '.join([f'{col} VARCHAR' for col in columns])}
            );
        """
        hook.run(create_sql)
        print(f"Created table: {DATABASE_NAME}.{SCHEMA_NAME}.{table_name}")

        # 3️⃣ Copy data (skip header)
        copy_sql = f"""
            COPY INTO {DATABASE_NAME}.{SCHEMA_NAME}.{table_name}
            FROM {STAGE_NAME}/{filename}
            FILE_FORMAT = (FORMAT_NAME = {FILE_FORMAT});
        """
        hook.run(copy_sql)
        print(f"Copied data into table: {DATABASE_NAME}.{SCHEMA_NAME}.{table_name}")

    # --- DAG flow ---
    files = list_stage_files()
    create_table_and_copy.expand(file_path=files)
