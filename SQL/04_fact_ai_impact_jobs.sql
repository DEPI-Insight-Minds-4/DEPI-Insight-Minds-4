-- fact table
CREATE TABLE fact_ai_impact_jobs (
    fact_id SERIAL PRIMARY KEY,
    location_id INT REFERENCES location(location_id),
    industry_id INT REFERENCES industry(industry_id),
    job_id INT REFERENCES job(job_id),
    ai_impact_level VARCHAR(50),
    median_salary_usd DECIMAL(10,2),
    job_openings_2024 INT,
    projected_openings_2030 INT,
    remote_work_ratio FLOAT,
    automation_risk FLOAT,
    gender_diversity FLOAT
);

-- insert data into fact table
INSERT INTO fact_ai_impact_jobs (
    location_id, industry_id, job_id,
    ai_impact_level, median_salary_usd,
    job_openings_2024, projected_openings_2030,
    remote_work_ratio, automation_risk, gender_diversity
)
SELECT 
    l.location_id,
    i.industry_id,
    j.job_id,
    d.`AI Impact Level`,
    d.`Median Salary (USD)`,
    d.`Job Openings (2024)`,
    d.`Projected Openings (2030)`,
    d.`Remote Work Ratio (%)`,
    d.`Automation Risk (%)`,
    d.`Gender Diversity (%)`
FROM ai_job_trends_dataset d
JOIN location l ON TRIM(LOWER(d.`Location`)) = TRIM(LOWER(l.location_name))
JOIN industry i ON TRIM(LOWER(d.`Industry`)) = TRIM(LOWER(i.industry_name))
JOIN job j
    ON TRIM(LOWER(d.`Job Title`)) = TRIM(LOWER(j.job_title))
   AND TRIM(LOWER(d.`Job Status`)) = TRIM(LOWER(j.job_status))
   AND TRIM(LOWER(d.`Required Education`)) = TRIM(LOWER(j.required_education))
   AND CAST(d.`Experience Required (Years)` AS UNSIGNED) = j.experience_required_years;

-- validation
SELECT COUNT(*) AS total_facts FROM fact_ai_impact_jobs;