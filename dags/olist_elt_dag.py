"""Daily Olist ELT: load raw CSVs -> dbt run (staging + marts) -> dbt test."""
from datetime import datetime

from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import DAG

PROJECT = "/opt/airflow/project"
PYTHON = "/home/airflow/venv/bin/python"
DBT = f"cd {PROJECT}/olist_dbt && /home/airflow/venv/bin/dbt"

with DAG(
    dag_id="olist_elt",
    description="Load raw Olist data, build dbt models, run dbt tests",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args={"retries": 2},
    tags=["olist", "elt"],
) as dag:
    load_raw = BashOperator(
        task_id="load_raw",
        bash_command=f"{PYTHON} {PROJECT}/ingestion/load_raw.py",
    )
    dbt_run = BashOperator(task_id="dbt_run", bash_command=f"{DBT} run")
    dbt_test = BashOperator(task_id="dbt_test", bash_command=f"{DBT} test")

    load_raw >> dbt_run >> dbt_test