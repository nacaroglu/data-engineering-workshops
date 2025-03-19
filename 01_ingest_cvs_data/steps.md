
1. Pull and run the image

docker network create airflow-default

docker run --name ecommerce-db -d \
    -e MYSQL_ROOT_PASSWORD=root \
    -p 3306:3306 \
    -v $(pwd)/ecommerce_data:/var/lib/mysql \
    --network airflow-default\
    mysql:latest


docker exec -it ecommerce-db bash

2. Create Database

mysql -u root -p

create database ecommerce;

use ecommerce;

3. Create tables

run scripts one by one in schemas folder in mysql client application

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

4. Create Virtual Enviroment & Install dependicies 

python3 -m venv .venv

source .venv/bin/activate

pip3 install pandas 
pip3 install sqlalchemy
pip install PyMySQL
pip install cryptography

5. Run script

python ingest_csv.py --user root --password root --host localhost --port 3306 --db_name ecommerce 

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

6. Check from MySQL DB

01_ingest_cvs_data git:(main) ✗ docker exec -it ecommerce-db bash
bash-5.1# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 9.2.0 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use ecommerce
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
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

7. Dumb MySQL DB

bash-5.1# mysqldump -u root  -p ecommerce  > ecommerce_export.sql

cp ecommerce_export.sql /var/lib/mysql 

