
1. Create AWS Account
    - https://www.baeldung.com/linux/aws-cli-install
    - Create an AWS account
    - Configure CLI

2. Create Terraform Config

    - Create a new directory called `terraform`
    - Create a new file called `main.tf` in the `terraform` directory
    - Add the following code to the `main.tf` file
    - Run `terraform init` in the `terraform` directory
    - Run `terraform fmt` in the `terraform` directory
    - Run `terraform plan` in the `terraform` directory
    - Run `terraform apply` in the `terraform` directory

3. Configure and Run Airflow
    - Install Airflow
    - Configure Airflow
        - Create a new directory called `airflow`
        - Add AWS config directory as mount point
        - Update requirements.txt to add aws dependencies
        - Add Connection via Airflow UI
        - Add mySQL config to docker-compose.yaml that reads from .env file

    - Run Airflow

4. Create Snowflake Account

    - Create Snowflake Tables
    - Install Required Airflow Packages
    - Create an Airflow Connection for Snowflake
    - Create Storage integration

    CREATE OR REPLACE STORAGE INTEGRATION s3_integration
        TYPE = EXTERNAL_STAGE
        STORAGE_PROVIDER = 'S3'
        STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::your-aws-account-id:role/your-s3-role'
        STORAGE_ALLOWED_LOCATIONS = ('s3://dataengineering-workshop/')
        ENABLED = TRUE;

        CREATE OR REPLACE STAGE ecommerce_stage
        STORAGE_INTEGRATION = s3_integration
        file_format = (FORMAT_NAME=ecommerce_file_format)
        URL = 's3://dataengineering-workshop/';

        create or replace file format ecommerce.public.ecommerce_file_format
            type= PARQUET


5. Design Airflow DAG

6. Create Airflow DAG

7. Run Airflow DAG

8. Validate Data on Snowflake

