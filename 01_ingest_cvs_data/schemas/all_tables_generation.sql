CREATE TABLE customers (
    customer_id CHAR(32) NOT NULL PRIMARY KEY,
    customer_unique_id CHAR(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(16) NOT NULL,
    customer_city VARCHAR(128) NOT NULL,
    customer_state CHAR(2) NOT NULL
);

CREATE INDEX idx_customer_unique ON customers(customer_unique_id);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(16) NOT NULL,
    geolocation_lat DECIMAL(10,8) NOT NULL,
    geolocation_lng DECIMAL(11,8) NOT NULL,
    geolocation_city VARCHAR(128) NOT NULL,
    geolocation_state CHAR(2) NOT NULL,
    
    INDEX idx_zip_code (geolocation_zip_code_prefix),
    INDEX idx_lat_lng (geolocation_lat, geolocation_lng)
);

CREATE TABLE order_items (
    order_id CHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id CHAR(32) NOT NULL,
    seller_id CHAR(32) NOT NULL,
    shipping_limit_date DATETIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id),
    INDEX idx_product (product_id),
    INDEX idx_seller (seller_id),
    INDEX idx_shipping_date (shipping_limit_date)
);

CREATE TABLE order_payments (
    order_id CHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type ENUM('credit_card', 'boleto', 'voucher', 'debit_card', 'not_defined') NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential),
    INDEX idx_payment_type (payment_type),
    INDEX idx_payment_value (payment_value)
);

CREATE TABLE order_reviews (
    review_id CHAR(32) NOT NULL,
    order_id CHAR(32) NOT NULL,
    review_score TINYINT NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title VARCHAR(255) NULL,
    review_comment_message TEXT NULL,
    review_creation_date DATETIME NOT NULL,
    review_answer_timestamp DATETIME NULL,

    PRIMARY KEY (review_id),
    INDEX idx_review_score (review_score),
    INDEX idx_review_creation_date (review_creation_date)
);

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

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(255) PRIMARY KEY,
    product_category_name_english VARCHAR(255) NOT NULL
);

CREATE TABLE products (
    product_id CHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(255),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE sellers (
    seller_id CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(16),
    seller_city VARCHAR(255),
    seller_state CHAR(2)
);
