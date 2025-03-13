CREATE TABLE order_payments (
    order_id CHAR(32) NOT NULL,           -- Unique order identifier (same as in order_items)
    payment_sequential INT NOT NULL,      -- Payment sequence number within an order
    payment_type ENUM('credit_card', 'boleto', 'voucher', 'debit_card', 'not_defined') NOT NULL, 
    payment_installments INT NOT NULL,    -- Number of installments
    payment_value DECIMAL(10,2) NOT NULL, -- Payment amount

    PRIMARY KEY (order_id, payment_sequential), -- Ensuring uniqueness within an order
    INDEX idx_payment_type (payment_type),      -- Optimized queries by payment type
    INDEX idx_payment_value (payment_value)     -- Searching/filtering by payment amount
);
