First step to create a MySQL DB and import some data for our e-commerce DB. 
We are using this dataset: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce



1. Pull and run MySQL image in Docker

```
docker network create airflow-default

docker run --name ecommerce-db -d \
    -e MYSQL_ROOT_PASSWORD=root \
    -p 3306:3306 \
    -v $(pwd)/ecommerce_data:/var/lib/mysql \
    --network airflow-default\
    mysql:latest
```

Login to container:

```
docker exec -it ecommerce-db bash
```


2. Create a new database

Login to MySQL CLI
```
mysql -u root -p
```

Create and switch to database
```
create database ecommerce;

use ecommerce;
```

3. Create tables

Run SQL Scripts one by one which are located in [schemas](schemas) folder against to MySQL CLI.

Check created tables with below command:

```
mysql> show tables;
+------------------------------------+
| Tables_in_ecommerce                |
+------------------------------------+
| customers                          |
| geolocation                        |
| order_items                        |
| order_payments                     |
| order_reviews                      |
| orders                             |
| product_category_name_translations |
| products                           |
| sellers                            |
+------------------------------------+
9 rows in set (0.00 sec)
```

4. Create Virtual Enviroment & Install dependicies for ingestion script

```
python3 -m venv .venv

source .venv/bin/activate

pip3 install pandas 
pip3 install sqlalchemy
pip install PyMySQL
pip install cryptography
```

5. Run ingestion script. CSV files located in [data](data) folder

```
python ingest_csv.py --user root --password root --host localhost --port 3306 --db_name ecommerce
```

Output of the script should be like:

```
Inserted 99224 rows into order_reviews
Inserted 99441 rows into customers
Inserted 32951 rows into products
Inserted 99441 rows into orders
Inserted 71 rows into product_category_name_translation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 100000 rows into geolocation
Inserted 163 rows into geolocation
Inserted 100000 rows into order_payments
Inserted 3886 rows into order_payments
Inserted 3095 rows into sellers
Inserted 100000 rows into order_items
Inserted 12650 rows into order_items
All CSV files have been imported successfully!
.venv➜  01_ingest_cvs_data git:(main) ✗ 
```

6. Check from MySQL DB

Login to container and start MySQL CLI

```
docker exec -it ecommerce-db bash
```
```
bash-5.1# mysql -u root -p
```


```
mysql> use ecommerce
```

List tables to check

```
mysql> show tables;
+------------------------------------+
| Tables_in_ecommerce                |
+------------------------------------+
| customers                          |
| geolocation                        |
| order_items                        |
| order_payments                     |
| order_reviews                      |
| orders                             |
| product_category_name_translation  |
| product_category_name_translations |
| products                           |
| sellers                            |
+------------------------------------+
10 rows in set (0.01 sec)
```

Check some of the tables ingested correctly:

```
mysql> select count(1) from geolocation;
+----------+
| count(1) |
+----------+
|  1000163 |
+----------+
1 row in set (0.05 sec)

mysql> select count(1) from orders;
+----------+
| count(1) |
+----------+
|    99441 |
+----------+
1 row in set (0.04 sec)

mysql> select count(1) from order_items;
+----------+
| count(1) |
+----------+
|   112650 |
+----------+
1 row in set (0.02 sec)

mysql> select count(1) from customers;
+----------+
| count(1) |
+----------+
|    99441 |
+----------+
1 row in set (0.03 sec)

