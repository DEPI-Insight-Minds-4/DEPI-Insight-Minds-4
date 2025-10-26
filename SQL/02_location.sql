-- location table
CREATE TABLE location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(255) UNIQUE
) AUTO_INCREMENT = 10;

-- insert unique locations
INSERT INTO location (location_name)
SELECT DISTINCT 
    CONCAT(
        UPPER(LEFT(TRIM(`Location`), 1)),
        LOWER(SUBSTRING(TRIM(`Location`), 2))
    )
FROM ai_job_trends_dataset;