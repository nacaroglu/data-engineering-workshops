CREATE TABLE sellers (
    seller_id CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(16),
    seller_city VARCHAR(255),
    seller_state CHAR(2)
);