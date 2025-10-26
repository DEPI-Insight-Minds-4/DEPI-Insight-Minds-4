-- Insights queries for AI-powered job analysis

-- Number of unique entities
SELECT 
    COUNT(DISTINCT industry_id) AS total_industries,
    COUNT(DISTINCT location_id) AS total_locations,
    COUNT(DISTINCT job_id) AS total_jobs
FROM fact_ai_impact_jobs;

-- Average salary and job openings
SELECT 
    ROUND(SUM(median_salary_usd)/ 1000, 1) AS avg_salary_usd,
    ROUND(SUM(job_openings_2024) / 1000000, 1) AS openings_2024_million,
    ROUND(SUM(projected_openings_2030) / 1000000, 1) AS openings_2030_million
FROM fact_ai_impact_jobs;

-- Top industries by automation risk
SELECT 
    i.industry_name AS industry,
    ROUND(AVG(automation_risk), 2) AS avg_automation_risk
FROM fact_ai_impact_jobs f
JOIN industry i ON f.industry_id = i.industry_id
GROUP BY i.industry_name
ORDER BY avg_automation_risk DESC;