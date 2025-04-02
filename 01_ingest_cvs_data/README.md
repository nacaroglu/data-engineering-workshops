# **Workshop 0: Import Data to MySQL from CSV**

## **Objective**
In this workshop, we will set up a MySQL database using Docker and import an e-commerce dataset into it. This serves as the foundational step for our data pipeline, where we prepare raw data for further processing and analytics.

We are using the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), which contains orders, products, customer details, payment information, and geolocation data.

---
## **Step 1: Pull and Run MySQL in Docker**
First, we need to run a MySQL database inside a Docker container.

### **Create a Docker Network**
We create a custom network to ensure that services like Airflow can communicate with the MySQL database.
```sh
docker network create airflow-default
```

### **Run the MySQL Container**
Execute the following command to start a MySQL container:
```sh
docker run --name ecommerce-db -d \
    -e MYSQL_ROOT_PASSWORD=root \
    -p 3306:3306 \
    -v $(pwd)/ecommerce_data:/var/lib/mysql \
    --network airflow-default \
    mysql:latest
```
- `--name ecommerce-db`: Assigns the container a recognizable name.
- `-d`: Runs the container in the background.
- `-e MYSQL_ROOT_PASSWORD=root`: Sets the root password.
- `-p 3306:3306`: Maps the MySQL port to the host machine.
- `-v $(pwd)/ecommerce_data:/var/lib/mysql`: Persists database data across container restarts.
- `--network airflow-default`: Connects the container to our custom network.

### **Login to the Running Container**
```sh
docker exec -it ecommerce-db bash
```
This will give you access to the container’s shell.

---
## **Step 2: Create a New Database**
Once inside the container, log in to the MySQL CLI:
```sh
mysql -u root -p
```
Enter the password (`root` in this case) when prompted.

Now, create a database named `ecommerce` and switch to it:
```sql
CREATE DATABASE ecommerce;
USE ecommerce;
```

---
## **Step 3: Create Tables**
The dataset contains multiple CSV files that will be mapped into tables. The SQL scripts for creating these tables are provided in the `[schemas](schemas)` folder.

Run the SQL scripts one by one inside the MySQL CLI.

To verify that tables were created successfully, run:
```sql
SHOW TABLES;
```
You should see the following output:
```
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
```

---
## **Step 4: Set Up Python Environment for Data Ingestion**
Before running the ingestion script, we need to set up a virtual environment and install dependencies.

### **Create a Virtual Environment**
```sh
python3 -m venv .venv
source .venv/bin/activate
```

### **Install Required Packages**
```sh
pip install pandas sqlalchemy PyMySQL cryptography
```

---
## **Step 5: Run the Ingestion Script**
Now, we can execute the script to load data from CSV files into MySQL.

### **Command to Run the Script**
```sh
python ingest_csv.py --user root --password root --host localhost --port 3306 --db_name ecommerce
```

### **Expected Output**
You should see output similar to:
```
Inserted 99224 rows into order_reviews
Inserted 99441 rows into customers
Inserted 32951 rows into products
Inserted 99441 rows into orders
Inserted 100000 rows into geolocation
Inserted 100000 rows into order_payments
Inserted 3095 rows into sellers
Inserted 112650 rows into order_items
All CSV files have been imported successfully!
```

---
## **Step 6: Verify Data in MySQL**
After running the ingestion script, we can check if the data was successfully loaded.

### **Login to MySQL Inside the Container**
```sh
docker exec -it ecommerce-db bash
mysql -u root -p
```
Enter the root password and switch to the `ecommerce` database:
```sql
USE ecommerce;
```

### **Check Table Counts**
Run the following queries to verify data was inserted correctly:
```sql
SELECT COUNT(*) FROM geolocation;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM customers;
```
Example output:
```
+----------+
| COUNT(*) |
+----------+
|  1000163 |
+----------+
+----------+
|   99441  |
+----------+
+----------+
|  112650  |
+----------+
+----------+
|   99441  |
+----------+
```

---
## **Summary**
At this stage, we have:
- Deployed a MySQL database inside a Docker container.
- Created an `ecommerce` database and relevant tables.
- Set up a Python virtual environment with necessary dependencies.
- Imported raw CSV data into MySQL.
- Verified that the data is correctly stored in the database.

This completes **Workshop 0**, setting the foundation for the next steps in our data pipeline.

**Next Step:** Proceed to [Workshop 1](../workshop1) to extract data from MySQL and move it to a data lake and data warehouse.

