CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(16) NOT NULL,  -- Zip code prefix, stored as a string
    geolocation_lat DECIMAL(10,8) NOT NULL,            -- Latitude (high precision)
    geolocation_lng DECIMAL(11,8) NOT NULL,            -- Longitude (high precision)
    geolocation_city VARCHAR(128) NOT NULL,            -- City name
    geolocation_state CHAR(2) NOT NULL,                -- State abbreviation (SP, MG, RJ, etc.)
    
    INDEX idx_zip_code (geolocation_zip_code_prefix),  -- Index for fast lookup by zip code
    INDEX idx_lat_lng (geolocation_lat, geolocation_lng) -- Index for geographic queries
);
