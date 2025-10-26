-- industry table
CREATE TABLE industry (
    industry_id INT AUTO_INCREMENT PRIMARY KEY,
    industry_name VARCHAR(255) UNIQUE
) AUTO_INCREMENT = 5;

-- insert unique industries
INSERT INTO industry (industry_name)
SELECT DISTINCT 
    CONCAT(
        UPPER(LEFT(TRIM(`Industry`), 1)),
        LOWER(SUBSTRING(TRIM(`Industry`), 2))
    )
FROM ai_job_trends_dataset;