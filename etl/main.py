#!/usr/bin/env python3
"""Main ETL Pipeline Runner"""

from extract import extract_all
from transform import transform_all
from load import load_all

def run_etl():
    """Execute complete ETL pipeline"""
    print("Starting ETL Pipeline...")
    
    # Extract
    print("\n[1/3] Extracting data...")
    raw_data = extract_all('data/raw')
    
    # Transform
    print("\n[2/3] Transforming data...")
    transformed_data = transform_all(raw_data)
    
    # Load
    print("\n[3/3] Loading to warehouse...")
    db_config = {
        'host': 'localhost',
        'database': 'analytics_db',
        'user': 'postgres',
        'password': 'password'
    }
    load_all(transformed_data, db_config)
    
    print("\n✓ ETL Pipeline completed!")

if __name__ == '__main__':
    run_etl()
