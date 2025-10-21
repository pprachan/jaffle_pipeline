from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime
import os

# Define Airflow DAG
with DAG(
    dag_id="dbt_test",
    start_date=datetime(2025, 1, 1),
    schedule=None,  # or "0 6 * * *" for daily at 6 AM
    catchup=False,
    tags=["dbt", "test"],
) as dag:

    # Paths inside your Airflow container
    DBT_PROJECT_DIR = "/opt/airflow/dbt"
    DBT_PROFILES_DIR = "/opt/airflow/dbt"

    # (Optional) environment variables, e.g., for Snowflake, BigQuery, etc.
    DBT_ENV_VARS = {
        "DBT_PROFILES_DIR": DBT_PROFILES_DIR,
    }

    # Define the dbt source freshness command
    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt test --profiles-dir {DBT_PROFILES_DIR} --target dev
        """,
        env={**os.environ, **DBT_ENV_VARS},  # merge system + custom env
    )

    dbt_test
