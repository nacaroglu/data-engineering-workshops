FROM apache/airflow:2.6.1
ENV AIRFLOW_HOME=/opt/airflow

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pandas sqlalchemy psycopg2-binary

WORKDIR $AIRFLOW_HOME

USER $AIRFLOW_UID
