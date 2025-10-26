-- job table
CREATE TABLE job (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(255),
    job_status VARCHAR(50),
    required_education VARCHAR(100),
    experience_required_years INT,
    experience_category VARCHAR(50)
) AUTO_INCREMENT = 20;

-- insert data into job
INSERT INTO job (
    job_title, job_status, required_education, 
    experience_required_years, experience_category
)
SELECT DISTINCT 
    CONCAT(UPPER(LEFT(TRIM(`Job Title`), 1)), LOWER(SUBSTRING(TRIM(`Job Title`), 2))),
    CONCAT(UPPER(LEFT(TRIM(`Job Status`), 1)), LOWER(SUBSTRING(TRIM(`Job Status`), 2))),
    CONCAT(UPPER(LEFT(TRIM(`Required Education`), 1)), LOWER(SUBSTRING(TRIM(`Required Education`), 2))),
    `Experience Required (Years)`,
    CASE 
        WHEN `Experience Required (Years)` < 2 THEN 'Entry-Level'
        WHEN `Experience Required (Years)` BETWEEN 2 AND 5 THEN 'Junior'
        WHEN `Experience Required (Years)` BETWEEN 6 AND 8 THEN 'Senior'
        WHEN `Experience Required (Years)` BETWEEN 9 AND 12 THEN 'Supervisor'
        ELSE 'Expert'
    END
FROM ai_job_trends_dataset;

-- fix encoding issues
UPDATE job
SET required_education = REPLACE(REPLACE(REPLACE(required_education,
    'â€™', ''''),
    'â€œ', '"'),
    'â€', '"');