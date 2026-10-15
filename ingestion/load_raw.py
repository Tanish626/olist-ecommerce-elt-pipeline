"""Load Olist CSVs into Postgres `raw` schema.

- All columns land as TEXT: raw layer = exact copy of the source, typing happens in dbt.
- Idempotent: each table is dropped and recreated, so re-running never duplicates rows
  and always picks up the current CSV columns.
- Uses COPY, which is far faster than row-by-row INSERTs.
"""
import csv
import logging
import os
from pathlib import Path

import psycopg2

DATA_DIR = Path(__file__).resolve().parent.parent / "data" / "raw"
# Defaults work from your laptop; Airflow's container overrides host/port via env vars.
DB = dict(
    host=os.getenv("WAREHOUSE_HOST", "localhost"),
    port=int(os.getenv("WAREHOUSE_PORT", "5433")),
    dbname="olist",
    user="de_user",
    password="de_pass",
)

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger("load_raw")


def table_name(path: Path) -> str:
    return path.stem.replace("olist_", "").replace("_dataset", "")  # e.g. orders, order_items


def load_file(conn, path: Path) -> int:
    table = table_name(path)
    # utf-8-sig strips a BOM if the CSV has one (otherwise it ends up inside the first column name)
    with open(path, newline="", encoding="utf-8-sig") as f:
        header = next(csv.reader(f))
    cols = ", ".join(f'"{c}" TEXT' for c in header)

    with conn.cursor() as cur:
        cur.execute(f"DROP TABLE IF EXISTS raw.{table} CASCADE;")
        cur.execute(f"CREATE TABLE raw.{table} ({cols});")
        with open(path, encoding="utf-8-sig") as f:
            cur.copy_expert(f"COPY raw.{table} FROM STDIN WITH (FORMAT csv, HEADER true)", f)
        cur.execute(f"SELECT count(*) FROM raw.{table};")
        return cur.fetchone()[0]


def main():
    files = sorted(DATA_DIR.glob("*.csv"))
    if not files:
        raise SystemExit(f"No CSVs found in {DATA_DIR}. Copy the Olist files there first.")
    conn = psycopg2.connect(**DB)
    try:
        for path in files:
            rows = load_file(conn, path)
            conn.commit()
            log.info("loaded %-35s -> raw.%-30s %8d rows", path.name, table_name(path), rows)
    except Exception:
        conn.rollback()
        log.exception("load failed")
        raise
    finally:
        conn.close()


if __name__ == "__main__":
    main()