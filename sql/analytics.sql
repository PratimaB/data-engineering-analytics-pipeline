-- Analytics Queries for Business Intelligence

-- 1. Customer Revenue Analysis
SELECT 
    c.customer_name,
    c.region,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_revenue,
    AVG(o.total_amount) as avg_order_value
FROM dim_customers c
JOIN fact_orders o ON c.customer_key = o.customer_key
WHERE c.is_current = TRUE
GROUP BY c.customer_name, c.region
ORDER BY total_revenue DESC;

-- 2. Regional Performance
SELECT 
    c.region,
    COUNT(DISTINCT c.customer_id) as active_customers,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as revenue
FROM dim_customers c
LEFT JOIN fact_orders o ON c.customer_key = o.customer_key
WHERE c.is_current = TRUE AND c.status = 'Active'
GROUP BY c.region
ORDER BY revenue DESC;

-- 3. Payment Analysis
SELECT 
    DATE_TRUNC('month', p.payment_date) as month,
    COUNT(p.payment_id) as payment_count,
    SUM(p.amount) as total_collected,
    AVG(p.amount) as avg_payment
FROM fact_payments p
GROUP BY month
ORDER BY month;

-- 4. Order Fulfillment (Orders vs Payments)
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount as order_amount,
    COALESCE(p.amount, 0) as paid_amount,
    CASE 
        WHEN p.amount IS NULL THEN 'Unpaid'
        WHEN p.amount >= o.total_amount THEN 'Paid'
        ELSE 'Partial'
    END as payment_status
FROM fact_orders o
LEFT JOIN fact_payments p ON o.order_id = p.order_id
ORDER BY o.order_date DESC;

-- 5. Customer Segmentation
WITH customer_metrics AS (
    SELECT 
        c.customer_key,
        c.customer_name,
        COUNT(o.order_id) as order_count,
        SUM(o.total_amount) as lifetime_value
    FROM dim_customers c
    LEFT JOIN fact_orders o ON c.customer_key = o.customer_key
    WHERE c.is_current = TRUE
    GROUP BY c.customer_key, c.customer_name
)
SELECT 
    customer_name,
    order_count,
    lifetime_value,
    CASE 
        WHEN lifetime_value > 1000 THEN 'High Value'
        WHEN lifetime_value > 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as segment
FROM customer_metrics
ORDER BY lifetime_value DESC;
