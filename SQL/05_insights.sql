-- How many unique industries, locations, and job titles exist in the dataset?
SELECT 
    COUNT(DISTINCT industry_id) AS total_industries,
    COUNT(DISTINCT location_id) AS total_locations,
    COUNT(DISTINCT job_id) AS total_jobs
FROM fact_ai_impact_jobs;
-- =====================================
-- What is the sum salary and total job openings in 2024 compared to projections for 2030?
-- =====================================
SELECT 
    ROUND(SUM(median_salary_usd)/ 1000, 1) AS avg_salary_usd,
    ROUND(SUM(job_openings_2024) / 1000000, 1) AS total_openings_2024_millions,
    ROUND(SUM(projected_openings_2030) / 1000000, 1) AS total_projected_openings_2030_millions
FROM fact_ai_impact_jobs;

-- =====================================
-- Which industries face the highest average automation risk due to AI?
-- =====================================

SELECT 
    i.industry_name AS industry,
    ROUND(AVG(automation_risk), 2) AS avg_automation_risk
FROM fact_ai_impact_jobs f
JOIN industry i ON f.industry_id = i.industry_id
GROUP BY i.industry_name
ORDER BY avg_automation_risk DESC;

-- =====================================
-- How will job openings in each industry change between 2024 and 2030?
-- =====================================

SELECT 
    i.industry_name AS industry,
    ROUND(SUM(job_openings_2024)/1000000, 2) AS openings_2024_million,
    ROUND(SUM(projected_openings_2030)/1000000, 2) AS projected_2030_million,
    ROUND((SUM(projected_openings_2030) - SUM(job_openings_2024)) / SUM(job_openings_2024) * 100, 2) AS growth_percent
FROM fact_ai_impact_jobs f
JOIN industry i ON f.industry_id = i.industry_id
GROUP BY i.industry_name
ORDER BY growth_percent DESC;

-- =====================================
-- Which 10 jobs are highest at risk of being automated by AI?
-- =====================================

SELECT 
    j.job_title,
    ROUND(AVG(automation_risk), 2) AS avg_automation_risk
FROM fact_ai_impact_jobs f
JOIN job j ON f.job_id = j.job_id
GROUP BY j.job_title
ORDER BY avg_automation_risk DESC
LIMIT 10;

-- =====================================
-- Which 10 jobs are least at risk of automation?
-- =====================================

SELECT 
    j.job_title,
    ROUND(AVG(automation_risk), 2) AS avg_automation_risk
FROM fact_ai_impact_jobs f
JOIN job j ON f.job_id = j.job_id
GROUP BY j.job_title
ORDER BY avg_automation_risk ASC
LIMIT 10;

-- =====================================
-- Which jobs are projected to decrease in openings by 2030?
-- =====================================

SELECT 
    j.job_title,
    SUM(job_openings_2024) AS openings_2024,
    SUM(projected_openings_2030) AS openings_2030,
    (SUM(projected_openings_2030) - SUM(job_openings_2024)) AS net_change
FROM fact_ai_impact_jobs f
JOIN job j ON f.job_id = j.job_id
GROUP BY j.job_title
-- الجزء ده بيجيب الوظيفة الي قلت فقط
HAVING net_change < 0
ORDER BY net_change ASC
LIMIT 10;

-- =====================================
--  Which locations have the highest and lowest exposure to automation?
-- =====================================

SELECT 
    l.location_name AS location,
    ROUND(AVG(automation_risk), 2) AS avg_automation_risk
FROM fact_ai_impact_jobs f
JOIN location l ON f.location_id = l.location_id
GROUP BY l.location_name
ORDER BY avg_automation_risk DESC;

-- =====================================
-- How Average Automation Risk by Education Level?
-- =====================================

SELECT 
    j.required_education AS education_level,
    ROUND(AVG(automation_risk), 2) AS avg_automation_risk
FROM fact_ai_impact_jobs f
JOIN job j ON f.job_id = j.job_id
GROUP BY j.required_education
ORDER BY avg_automation_risk DESC;

-- =====================================
-- Which industries offer the highest average remote work opportunities?
-- =====================================

SELECT 
    i.industry_name AS industry,
    ROUND(AVG(remote_work_ratio), 2) AS avg_remote_ratio
FROM fact_ai_impact_jobs f
JOIN industry i ON f.industry_id = i.industry_id
GROUP BY i.industry_name
ORDER BY avg_remote_ratio DESC;

-- =====================================
--  Which locations have the highest average remote work?
-- =====================================

SELECT 
    l.location_name AS location,
    ROUND(AVG(remote_work_ratio), 2) AS avg_remote_ratio
FROM fact_ai_impact_jobs f
JOIN location l ON f.location_id = l.location_id
GROUP BY l.location_name
ORDER BY avg_remote_ratio DESC;

-- =====================================
-- How many job openings are expected to increase or decrease between 2024 and 2030?
-- =====================================

ALTER TABLE fact_ai_impact_jobs
ADD COLUMN job_openings_between_2024_and_2030 FLOAT;

UPDATE fact_ai_impact_jobs
SET job_openings_between_2024_and_2030 = projected_openings_2030 - job_openings_2024;

-- =====================================
-- What is the overall gender diversity across all industries and locations?
-- =====================================

SELECT 
    ROUND(AVG(gender_diversity), 2) AS avg_female_percentage,
    ROUND(100 - AVG(gender_diversity), 2) AS avg_male_percentage
FROM fact_ai_impact_jobs;

-- =====================================
-- Which industries have the highest and lowest female representation?
-- =====================================

SELECT 
    i.industry_name AS industry,
    ROUND(AVG(f.gender_diversity), 2) AS avg_female_percentage,
    ROUND(100 - AVG(f.gender_diversity), 2) AS avg_male_percentage
FROM fact_ai_impact_jobs f
JOIN industry i ON f.industry_id = i.industry_id
GROUP BY i.industry_name
ORDER BY avg_female_percentage DESC;

-- =====================================
-- Gender female and male 
-- =====================================

ALTER TABLE fact_ai_impact_jobs
ADD COLUMN gender_diversity_male FLOAT;

UPDATE fact_ai_impact_jobs
SET gender_diversity_male = 100 - gender_diversity;

-- =====================================
-- How does Gender Diversity effect by Location
-- =====================================

SELECT 
    l.location_name AS location,
    ROUND(AVG(f.gender_diversity), 2) AS avg_female_percentage,
    ROUND(100 - AVG(f.gender_diversity), 2) AS avg_male_percentage
FROM fact_ai_impact_jobs f
JOIN location l ON f.location_id = l.location_id
GROUP BY l.location_name
ORDER BY avg_female_percentage DESC;
