from airflow import DAG
from airflow.decorators import task
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from datetime import datetime
from sqlalchemy import create_engine, inspect
import os
from airflow.utils.task_group import TaskGroup
from airflow.operators.python import get_current_context
import pandas as pd

path_to_local_home = os.environ.get("AIRFLOW_HOME")
mysql_user = os.getenv('MYSQL_USER')
mysql_password = os.getenv('MYSQL_PASSWORD')
mysql_host = os.getenv('MYSQL_HOST')
mysql_port = os.getenv('MYSQL_PORT')
db_name = "ecommerce"
bucket_name='dataengineering-workshop'

SNOWFLAKE_STAGE = "ecommerce_stage"
SNOWFLAKE_DATABASE = "ecommerce"
SNOWFLAKE_SCHEMA = "public"
SNOWFLAKE_FILE_FORMAT = "ecommerce_file_format"
SNOWFLAKE_STORAGE_INTEGRATION = "s3_integration"
SNOWFLAKE_CONNECTION = "snowflake_default"

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2025, 3, 18),
    'retries': 1,
}

@task
def list_tables():
    # Read MySQL connection properties from environment variables
    
    # MySQL connection string
    engine = create_engine(f'mysql+pymysql://{mysql_user}:{mysql_password}@{mysql_host}:{mysql_port}/{db_name}')
    inspector = inspect(engine)
    tables = inspector.get_table_names()
    print(f"List of tables to process: {tables}")
    return tables

@task
def dump_data_to_parquet(table_name):

    # MySQL connection string
    engine = create_engine(f'mysql+pymysql://{mysql_user}:{mysql_password}@{mysql_host}:{mysql_port}/{db_name}')
    query = f'SELECT * FROM {table_name}'
    df = pd.read_sql(query, engine)

    # Dump to Parquet
    df.to_parquet(f'{path_to_local_home}/{table_name}.parquet', index=False)

@task
def upload_to_s3(table_name):
    s3_hook = S3Hook(aws_conn_id='aws_default')
    s3_hook.load_file(
        filename=f'{path_to_local_home}/{table_name}.parquet',
        key=f'ecommerce/{table_name}.parquet',
        bucket_name=bucket_name
    )
@task
def create_file_format():
    context = get_current_context()
    sql=f"""
        DROP FILE FORMAT IF EXISTS 
            {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{SNOWFLAKE_FILE_FORMAT};
        CREATE OR REPLACE FILE FORMAT 
            {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{SNOWFLAKE_FILE_FORMAT}
            type= PARQUET;
        """

    return SnowflakeOperator(
        task_id='create_file_format',
        snowflake_conn_id=SNOWFLAKE_CONNECTION,
        database=SNOWFLAKE_DATABASE,
        schema=SNOWFLAKE_SCHEMA,
        sql = sql   
    ).execute(context)

@task
def create_stage():
    context = get_current_context()
    
    return SnowflakeOperator(
        task_id='create_stage',
        snowflake_conn_id=SNOWFLAKE_CONNECTION,
        sql=f"""
        DROP STAGE IF EXISTS {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{SNOWFLAKE_STAGE};
        DROP STAGE IF EXISTS {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{SNOWFLAKE_STAGE};
        CREATE OR REPLACE STAGE 
            {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{SNOWFLAKE_STAGE}
            URL = 's3://{bucket_name}'
            STORAGE_INTEGRATION = {SNOWFLAKE_STORAGE_INTEGRATION}
            FILE_FORMAT = {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{SNOWFLAKE_FILE_FORMAT}
        """
    ).execute(context)

@task
def import_to_snowflake(table_name):
    context = get_current_context()
    stage_url = f"{SNOWFLAKE_STAGE}/ecommerce/{table_name}.parquet/"
    print(f"Importing {table_name} to Snowflake...")
    print(f"Stage URL: {stage_url}")
    COPY_SQL = f"""
        USE {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA};
        COPY INTO {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{table_name}
        FROM @{stage_url}
        FILE_FORMAT = (TYPE = PARQUET)
        MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
    """
    print(f"COPY SQL: {COPY_SQL}")

    return SnowflakeOperator(
        task_id=f'import_{table_name}_to_snowflake',
        snowflake_conn_id=SNOWFLAKE_CONNECTION,
        sql=COPY_SQL
    ).execute(context)

# Define the DAG
with DAG('export_data_to_warehouse', default_args=default_args, schedule_interval='@daily') as dag:

    # List tables in the database
    tables = list_tables()

    with TaskGroup('process_tables') as process_table_tasks:
        (
            dump_data_to_parquet.expand(table_name=tables) 
            >> upload_to_s3.expand(table_name=tables) 
            >> create_file_format() 
            >> create_stage() 
            >> import_to_snowflake.expand(table_name=tables)
        )
        