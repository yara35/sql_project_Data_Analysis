SELECT
    COUNT(job_id) as job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM 
    job_postings_fact
where job_title_short = 'Data Analyst'
GROUP BY date_month
ORDER BY job_posted_count DESC;


--Date function
CREATE TABLE january_job AS
    SELECT * 
    FROM job_postings_fact
    where EXTRACT (MONTH FROM job_posted_date) = 1;

SELECT job_posted_date
FROM january_job;

SELECT 
    count(job_id) as job_number,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        else 'Onsite'
    END AS location_category
FROM job_postings_fact 
where job_title_short = 'Data Analyst'
GROUP BY location_category;
    
-- SUBQUERY
SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN (
    SELECT 
        company_id
    FROM 
        job_postings_fact
    WHERE 
        job_no_degree_mention = true
    )
ORDER BY company_id ASC;

WITH company_job_count AS(
    SELECT 
        company_id,
        count(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)

SELECT 
    company_dim.name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON  company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;

SELECT job_id,
       job_title_short,
       job_location,
       job_via,
       salary_year_avg,
       job_posted_date::Date 
FROM(
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1
    UNION ALL
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=2
    UNION ALL
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=3
    )
WHERE salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC