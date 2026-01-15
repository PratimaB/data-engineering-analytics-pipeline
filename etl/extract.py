import pandas as pd
from pathlib import Path

def extract_csv(file_path):
    """Extract data from CSV file"""
    return pd.read_csv(file_path)

def extract_all(data_dir='data/raw'):
    """Extract all source files"""
    base_path = Path(data_dir)
    
    data = {
        'customers': extract_csv(base_path / 'customers.csv'),
        'orders': extract_csv(base_path / 'orders.csv'),
        'payments': extract_csv(base_path / 'payments.csv'),
        'products': extract_csv(base_path / 'products.csv')
    }
    
    print(f"Extracted {sum(len(df) for df in data.values())} total records")
    return data
