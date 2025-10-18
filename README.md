# 🚀 Data Pipeline: S3 → Snowflake → Airflow → dbt

This project builds a modern data pipeline to transform CSV data stored in **Amazon S3** using **dbt** (Data Build Tool).  
The infrastructure is provisioned with **Terraform**, orchestration is handled by **Airflow** running in **Docker**, and dbt is triggered via **Astronomer Cosmos**.

---

## 🧱 Architecture Overview

```
        +-------------+
        |   CSVs in   |
        |     S3       |
        +------+------+ 
               |
               v
        +------+------+
        |  Snowflake  |
        | (DB, Schema,|
        | File Format) |
        +------+------+
               |
               v
        +------+------+
        |   Airflow   |  -->  Orchestrates dbt runs
        |  (Docker)   |
        +------+------+
               |
               v
        +------+------+
        |     dbt     |
        | Transformations |
        +-------------+
```

---

## ⚙️ Tech Stack

| Component | Tool / Technology | Description |
|------------|-------------------|--------------|
| **Infrastructure** | [Terraform](https://www.terraform.io/) | Creates Snowflake resources (DB, schemas, roles, users, file formats, etc.) |
| **Data Warehouse** | [Snowflake](https://www.snowflake.com/) | Centralized data platform |
| **Data Transformation** | [dbt](https://www.getdbt.com/) | SQL-based data transformation framework |
| **Orchestration** | [Apache Airflow](https://airflow.apache.org/) | Task scheduling and workflow orchestration |
| **Integration** | [Astronomer Cosmos](https://github.com/astronomer/astronomer-cosmos) | Executes dbt models within Airflow DAGs |
| **Storage** | [Amazon S3](https://aws.amazon.com/s3/) | Source CSV files |

---

## 🗂️ Project Structure

```
project/
│
├── terraform/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── airflow/
│   ├── dags/
│   │   └── dbt_pipeline_dag.py
│   ├── docker-compose.yaml
│   └── requirements.txt
│
├── dbt/
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── models/
│   │   ├── sources/
│   │   └── analytics/
│   └── seeds/
│
└── README.md
```

---

## 🔧 Setup Instructions

### 1. Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Docker](https://docs.docker.com/get-docker/)
- [Snowflake account](https://signup.snowflake.com/)
- AWS credentials with access to S3 bucket
- Python 3.10+ (optional for dbt local debugging)

---

### 2. Provision Snowflake with Terraform

```bash
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

This creates:
- Database & schema  
- Warehouse  
- Roles & users  
- File formats and integrations  

---

### 3. Launch Airflow Locally (Docker)

```bash
cd airflow
docker-compose up -d
```

This spins up an Airflow environment at:  
👉 [http://localhost:8080](http://localhost:8080)

---

### 4. Configure dbt

Set up your Snowflake connection in `dbt/profiles.yml` and test the connection:

```bash
cd dbt
dbt debug
```

---

### 5. Run dbt via Airflow (Astronomer Cosmos)

The `dbt_pipeline_dag.py` DAG leverages **Cosmos** to trigger dbt commands.  
Once Airflow is running, trigger the DAG manually or schedule it:

```python
# Example DAG (simplified)
from cosmos import DbtDag

dbt_dag = DbtDag(
    project_dir="/usr/local/airflow/dags/dbt_project",
    profile_dir="/usr/local/airflow/dags/dbt_profiles",
    schedule_interval="@daily",
    dag_id="dbt_snowflake_pipeline"
)
```

---

## 📊 Expected Outcome

✅ Snowflake tables are created and populated with transformed data  
✅ dbt models are orchestrated and logged via Airflow  
✅ End-to-end data lineage is trackable in dbt and Airflow UIs  

---

## 🧩 Next Steps

- Add data validation tests (using `dbt test`)  
- Implement CI/CD for Terraform and dbt  
- Integrate with monitoring tools like **Great Expectations** or **Datafold**  

---

## 🪪 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙌 Acknowledgments

- [dbt Core](https://github.com/dbt-labs/dbt-core)  
- [Apache Airflow](https://github.com/apache/airflow)  
- [Astronomer Cosmos](https://github.com/astronomer/astronomer-cosmos)  
- [Terraform](https://github.com/hashicorp/terraform)
