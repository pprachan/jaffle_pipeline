# Base image for Airflow
FROM apache/airflow:3.1.0

# Install system dependencies
USER root
RUN apt-get update && apt-get install -y \
    gcc \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Switch back to Airflow user
USER airflow

# Install Python packages
RUN pip install --no-cache-dir \
    apache-airflow-providers-snowflake \
    dbt-core \
    dbt-snowflake\
    astronomer-cosmos
    # apache-airflow-providers-dbt