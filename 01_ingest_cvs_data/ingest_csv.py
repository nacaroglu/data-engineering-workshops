import os
import argparse

import pandas as pd
from sqlalchemy import create_engine
import pymysql


def main(params):
    user = params.user
    password = params.password
    host = params.host 
    port = params.port 
    db_name = params.db_name    

    # Create a database connection
    engine = create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{db_name}")

    # Folder containing the CSV files
    CSV_FOLDER = "data/ecommerce/"

    # Chunk size (adjust based on your system's memory)
    CHUNK_SIZE = 100000  # 100k rows per insert    

    # Loop through CSV files and import them
    for file in os.listdir(CSV_FOLDER):
        if file.endswith(".csv"):
            file_path = os.path.join(CSV_FOLDER, file)
            table_name = os.path.splitext(file)[0]  # Use filename as table name

            # Start with an empty table
            first_chunk = True
            for chunk in pd.read_csv(file_path, chunksize=CHUNK_SIZE):
                if first_chunk:
                    chunk.to_sql(table_name, con=engine, if_exists="replace", index=False)  # Create table
                    first_chunk = False
                else:
                    chunk.to_sql(table_name, con=engine, if_exists="append", index=False)  # Append data
                print(f"Inserted {len(chunk)} rows into {table_name}")

    print("All CSV files have been imported successfully!")  

if __name__ == '__main__':
        
    # Parse the command line arguments and calls the main program
    parser = argparse.ArgumentParser(description='Ingest CSV data to MySql')

    parser.add_argument('--user', help='user name')
    parser.add_argument('--password', help='password')
    parser.add_argument('--host', help='host')
    parser.add_argument('--port', help='port')
    parser.add_argument('--db_name', help='database name')
    parser.add_argument('--table_name', help='name of the table where we will write the results to')
    
    args = parser.parse_args()

    main(args)