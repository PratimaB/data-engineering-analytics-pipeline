import pandas as pd

def transform_customers(df):
    """Transform customers with SCD Type 2 logic"""
    df['valid_from'] = pd.to_datetime(df['updated_at']).dt.date
    df['valid_to'] = None
    df['is_current'] = True
    return df[['customer_id', 'customer_name', 'region', 'status', 'valid_from', 'valid_to', 'is_current']]

def transform_products(df):
    """Transform products dimension"""
    return df[['product_id', 'product_name', 'unit_price']]

def transform_orders(df):
    """Transform orders fact table"""
    df['order_date'] = pd.to_datetime(df['order_date']).dt.date
    return df[['order_id', 'customer_id', 'order_date', 'total_amount']]

def transform_payments(df):
    """Transform payments fact table"""
    df['payment_date'] = pd.to_datetime(df['payment_date']).dt.date
    return df[['payment_id', 'order_id', 'payment_date', 'amount']]

def transform_all(raw_data):
    """Apply all transformations"""
    transformed = {
        'customers': transform_customers(raw_data['customers']),
        'products': transform_products(raw_data['products']),
        'orders': transform_orders(raw_data['orders']),
        'payments': transform_payments(raw_data['payments'])
    }
    
    print(f"Transformed {len(transformed)} tables")
    return transformed
