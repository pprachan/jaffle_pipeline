from airflow import DAG
from datetime import datetime
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig
from cosmos.constants import TestBehavior

with DAG(
    dag_id="dbt_run",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    dbt_run = DbtTaskGroup(
        group_id="dbt_transformations",
        project_config=ProjectConfig(dbt_project_path="/opt/airflow/dbt"),
        profile_config=ProfileConfig(
            profile_name="jaffle_shop",
            target_name="dev",
            profiles_yml_filepath="/opt/airflow/dbt/profiles.yml"
        ),
        render_config=RenderConfig(
            test_behavior=TestBehavior.AFTER_EACH,
        ),
        execution_config=ExecutionConfig(),
    )

    dbt_run