FROM python:3.11-slim

# Set working directory
WORKDIR /usr/app

# Install dbt-core and your adapter (Snowflake in this example)
RUN pip install --no-cache-dir dbt-snowflake

# Copy dbt project
COPY dbt/ ./dbt/

# Expose port for dbt docs
EXPOSE 5050

# Default command
CMD ["bash", "-c", "cd dbt && dbt docs generate && dbt docs serve --port 5050 --no-browser --host 0.0.0.0"]
