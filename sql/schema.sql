-- Data Warehouse Schema (Star Schema)

-- Dimension: Customers (SCD Type 2)
CREATE TABLE dim_customers (
    customer_key SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    status VARCHAR(20),
    valid_from DATE NOT NULL,
    valid_to DATE,
    is_current BOOLEAN DEFAULT TRUE
);

-- Dimension: Products
CREATE TABLE dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id INT UNIQUE NOT NULL,
    product_name VARCHAR(100),
    unit_price DECIMAL(10,2)
);

-- Fact: Orders
CREATE TABLE fact_orders (
    order_key SERIAL PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    customer_key INT REFERENCES dim_customers(customer_key),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- Fact: Payments
CREATE TABLE fact_payments (
    payment_key SERIAL PRIMARY KEY,
    payment_id INT UNIQUE NOT NULL,
    order_id INT,
    payment_date DATE,
    amount DECIMAL(10,2)
);

-- Indexes for performance
CREATE INDEX idx_customer_id ON dim_customers(customer_id, is_current);
CREATE INDEX idx_order_date ON fact_orders(order_date);
CREATE INDEX idx_payment_date ON fact_payments(payment_date);
