from airflow import DAG
from datetime import datetime
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig

with DAG(
    dag_id="dbt_test_pipeline",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=["dbt", "test"],
) as dag:

    dbt_tests = DbtTaskGroup(
        group_id="dbt_tests",
        project_config=ProjectConfig("/opt/airflow/dbt"),
        profile_config=ProfileConfig(
            profiles_dir="/opt/airflow/dbt",
            target_name="dev",
        ),
        execution_config=ExecutionConfig(
            commands=["dbt test"]   # 👈 runs `dbt test`
        ),
    )

    dbt_tests
