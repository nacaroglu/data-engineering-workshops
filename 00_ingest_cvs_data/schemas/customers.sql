CREATE TABLE customers (
    customer_id CHAR(32) NOT NULL PRIMARY KEY,  -- Assuming it's a unique identifier (MD5 or UUID-like)
    customer_unique_id CHAR(32) NOT NULL,       -- Also appears to be a unique identifier
    customer_zip_code_prefix VARCHAR(16) NOT NULL, -- Zip code (assuming it's short)
    customer_city VARCHAR(128) NOT NULL,        -- City name
    customer_state CHAR(2) NOT NULL             -- State abbreviation (SP, MG, RJ, etc.)
);

CREATE INDEX idx_customer_unique ON customers(customer_unique_id);