from airflow import DAG
from datetime import datetime
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig

with DAG(
    dag_id="dbt_jaffle_pipeline",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    dbt_tg = DbtTaskGroup(
        group_id="dbt_transformations",
        project_config=ProjectConfig(dbt_project_path="/opt/airflow/dbt"),
        profile_config=ProfileConfig(
            profile_name="jaffle_shop",
            target_name="dev",
            profiles_yml_filepath="/opt/airflow/dbt/profiles.yml"
        ),
        execution_config=ExecutionConfig(),
    )