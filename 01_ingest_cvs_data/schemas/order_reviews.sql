CREATE TABLE order_reviews (
    review_id CHAR(32) NOT NULL,                      -- Benzersiz inceleme kimliği
    order_id CHAR(32) NOT NULL,                       -- İncelenen siparişin kimliği
    review_score TINYINT NOT NULL CHECK (review_score BETWEEN 1 AND 5),  -- 1-5 arasında puan
    review_comment_title VARCHAR(255) NULL,          -- Yoruma başlık (isteğe bağlı)
    review_comment_message TEXT NULL,                -- Kullanıcının detaylı yorumu (isteğe bağlı)
    review_creation_date DATETIME NOT NULL,          -- İnceleme oluşturma zamanı
    review_answer_timestamp DATETIME NULL,           -- İncelemeye yanıt verilme zamanı

    PRIMARY KEY (review_id),                         -- Her inceleme için benzersiz ID
    INDEX idx_review_score (review_score),           -- Sorgular için skor endeksi
    INDEX idx_review_creation_date (review_creation_date)  -- Tarih bazlı analizler için endeks
);
