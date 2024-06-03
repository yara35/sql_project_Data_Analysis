--The most optimal skills
WITH skills_damand AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_work_from_home = True AND
        salary_year_avg IS NOT NULL 
    GROUP BY 
        skills_dim.skill_id
),
average_salary AS(
    SELECT 
       skills_job_dim.skill_id,
       ROUND(avg(salary_year_avg),0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        job_work_from_home = True AND
        salary_year_avg IS NOT NULL 
    GROUP BY 
        skills_job_dim.skill_id
)
SELECT 
    skills_damand.skill_id,
    skills_damand.skills,
    demand_count,
    avg_salary
FROM 
    skills_damand 
INNER JOIN average_salary ON skills_damand.skill_id = average_salary.skill_id
WHERE 
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;


--rewriting this same query more concisely
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(avg(job_postings_fact.salary_year_avg)) AS avg_salary,
    COUNT(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True AND
    salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25