FROM apache/airflow:3.2.2

# dbt and the loader's dependencies live in their own virtualenv, so they
# can't conflict with Airflow's pinned dependencies.
RUN python -m venv /home/airflow/venv \
 && /home/airflow/venv/bin/pip install --no-cache-dir dbt-postgres psycopg2-binary