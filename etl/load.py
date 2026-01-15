import psycopg2
from psycopg2.extras import execute_values

def get_connection(db_config):
    """Create database connection"""
    return psycopg2.connect(**db_config)

def load_dimension(conn, table, df, conflict_column=None):
    """Load data into dimension table"""
    if df.empty:
        return
    
    cols = ','.join(df.columns)
    values = [tuple(row) for row in df.values]
    
    with conn.cursor() as cur:
        if conflict_column:
            query = f"INSERT INTO {table} ({cols}) VALUES %s ON CONFLICT ({conflict_column}) DO NOTHING"
        else:
            query = f"INSERT INTO {table} ({cols}) VALUES %s"
        
        execute_values(cur, query, values)
    conn.commit()
    print(f"Loaded {len(df)} records into {table}")

def load_all(transformed_data, db_config):
    """Load all transformed data to warehouse"""
    conn = get_connection(db_config)
    
    try:
        load_dimension(conn, 'dim_customers', transformed_data['customers'])
        load_dimension(conn, 'dim_products', transformed_data['products'], 'product_id')
        load_dimension(conn, 'fact_orders', transformed_data['orders'], 'order_id')
        load_dimension(conn, 'fact_payments', transformed_data['payments'], 'payment_id')
        
        print("ETL pipeline completed successfully")
    finally:
        conn.close()
