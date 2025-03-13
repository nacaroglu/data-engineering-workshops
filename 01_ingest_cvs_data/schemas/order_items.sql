CREATE TABLE order_items (
    order_id CHAR(32) NOT NULL,          -- Unique order identifier
    order_item_id INT NOT NULL,          -- Item number within the order
    product_id CHAR(32) NOT NULL,        -- Unique product identifier
    seller_id CHAR(32) NOT NULL,         -- Unique seller identifier
    shipping_limit_date DATETIME NOT NULL, -- Shipping deadline
    price DECIMAL(10,2) NOT NULL,        -- Price of the item
    freight_value DECIMAL(10,2) NOT NULL, -- Shipping cost

    PRIMARY KEY (order_id, order_item_id), -- Ensuring uniqueness within an order
    INDEX idx_product (product_id),        -- Index for fast product lookups
    INDEX idx_seller (seller_id),          -- Index for searching by seller
    INDEX idx_shipping_date (shipping_limit_date) -- For queries based on shipping deadlines
);
