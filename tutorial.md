Simple Data Engineering Pipeline Tutorial (S3 -> Snowflake -> dbt/Airflow)
This guide provides a step-by-step setup for a local data pipeline that extracts CSV data from S3, loads it into Snowflake using Airflow, and transforms it using dbt.
1. Prerequisites and Folder Structure
1.1. Prerequisites
Before starting, ensure you have the following installed and configured:
Docker and Docker Compose
Terraform
Snowflake Account (with admin or securityadmin rights to create roles/warehouses)
AWS S3 Bucket (with a sample CSV file uploaded, e.g., s3://your-bucket-name/raw_data/sales.csv)
1.2. Project Structure
Create a root directory named data-pipeline-project and set up the following folder structure.
data-pipeline-project/
├── dags/
│   └── s3_to_snowflake_pipeline.py  (Airflow DAG)
├── dbt_project/
│   ├── dbt_project.yml              (dbt config)
│   └── models/
│       └── transformed_data.sql     (dbt model)
├── dockerfile/
│   └── Dockerfile                   (Custom Airflow image)
├── terraform/
│   └── main.tf                      (Snowflake provisioning)
└── docker-compose.yaml              (Airflow services)



2. Snowflake Provisioning (Terraform)
We will use Terraform to provision a dedicated warehouse, database, and schema.
2.1. Configure Terraform Credentials
You need to export environment variables for Terraform to connect to Snowflake:
# Replace with your actual Snowflake credentials
export TF_VAR_SNOWFLAKE_USER="your_snowflake_user"
export TF_VAR_SNOWFLAKE_PASS="your_snowflake_password"
export TF_VAR_SNOWFLAKE_ACCOUNT="your_account_identifier" # e.g., xy12345.us-east-1
export TF_VAR_SNOWFLAKE_ROLE="SYSADMIN"
export TF_VAR_SNOWFLAKE_WAREHOUSE="COMPUTE_WH" # Use a powerful warehouse for provisioning



2.2. Create terraform/main.tf
Copy the contents of the generated terraform/main.tf file into your project.
2.3. Run Terraform
Navigate to the terraform/ directory and run:
terraform init
terraform plan
terraform apply --auto-approve



This will create:
Database: DE_PIPELINE_DB
Schema: RAW
Schema: ANALYTICS
Warehouse: DE_WH (Used by Airflow/dbt)
3. Airflow Environment Setup (Docker)
We need a custom Airflow image that includes the necessary Python packages (apache-airflow-providers-snowflake and dbt-snowflake).
3.1. Create dockerfile/Dockerfile
Copy the contents of the generated dockerfile/Dockerfile file.
3.2. Create docker-compose.yaml
Copy the contents of the generated docker-compose.yaml file.
3.3. Build and Start Airflow
In your project root directory (data-pipeline-project):
# 1. Create necessary folders and set Airflow user ID
mkdir -p ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env

# 2. Build the custom Airflow image
docker compose build

# 3. Initialize the Airflow database
docker compose up airflow-init

# 4. Start all services
docker compose up -d



Airflow should now be running locally. Access the UI at http://localhost:8080 (default credentials: airflow/airflow).
4. Airflow and dbt Configuration
4.1. Configure Airflow Connections
In the Airflow UI (Admin -> Connections), create two connections:
Snowflake Connection
Conn Id: snowflake_conn
Conn Type: Snowflake
Login: Your Snowflake User Name (must have permissions to the DB/WH created by Terraform)
Password: Your Snowflake Password
Account: Your Snowflake Account Identifier (e.g., xy12345.us-east-1)
Warehouse: DE_WH
Database: DE_PIPELINE_DB
Role: SYSADMIN (or a dedicated role with access to DE_WH)
AWS Connection
Conn Id: aws_default (or any name, ensure it matches the DAG)
Conn Type: AWS
AWS Access Key ID: Your AWS Access Key
AWS Secret Access Key: Your AWS Secret Key
4.2. Create dbt Project Files
Copy the contents of the generated dbt files into the dbt_project/ directory.
4.3. Create Airflow DAG
Copy the contents of the generated dags/s3_to_snowflake_pipeline.py file. Make sure to replace the placeholder for the S3 bucket name in the s3_copy_data task.
5. Running the Pipeline
Place Raw Data: Ensure a CSV file (e.g., sales.csv) is in your S3 bucket path (e.g., s3://your-bucket-name/raw_data/).
Unpause DAG: In the Airflow UI, find the DAG named s3_to_snowflake_pipeline and toggle it to ON.
Trigger: Click the Trigger DAG button.
Expected Outcome:
The s3_copy_data task will execute, running a COPY INTO command to load the CSV data into the DE_PIPELINE_DB.RAW.SALES_DATA table in Snowflake.
The dbt_transform task will run dbt run inside the Airflow environment.
dbt will connect to Snowflake (using Airflow's environment variables and the mounted dbt project config) and execute the transformed_data.sql model.
A new table, DE_PIPELINE_DB.ANALYTICS.transformed_data, will be created/updated in Snowflake.
(End of Tutorial Guide)
