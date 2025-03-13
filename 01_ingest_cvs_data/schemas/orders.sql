CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL,
    order_status ENUM('created', 'approved', 'invoiced', 'shipped', 'delivered', 'canceled', 'unavailable') NOT NULL,
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME NOT NULL,
    INDEX idx_customer_id (customer_id),
    INDEX idx_order_status (order_status),
    INDEX idx_order_purchase_timestamp (order_purchase_timestamp)
);