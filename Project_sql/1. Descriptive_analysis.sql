-- Number of data analyst job roles
SELECT
    count(job_link) AS Number_of_Data_Analyst_Jobs
FROM
    job_postings
WHERE
    LOWER(job_title) LIKE '%analyst%' --Filter for analyst job roles only ;

--Data analyst job postings count per company
SELECT 
    company,
    count(company) AS Number_of_Data_Analyst_Jobs
FROM 
    job_postings 
WHERE 
    LOWER(job_title) LIKE '%analyst%'
GROUP BY 
    company 
ORDER BY 
    Number_of_Data_Analyst_Jobs DESC;

-- Data analyst job postings count per location
SELECT 
    job_location, 
    count(job_location) AS Number_of_Data_Analyst_Jobs
FROM 
    job_postings
WHERE 
    LOWER(job_title) LIKE '%analyst%' 
GROUP BY 
    job_location
ORDER BY 
    Number_of_Data_Analyst_Jobs DESC;

--Data analyst job postings count per job type(onsite,remote)
SELECT
    job_type,
    COUNT(*) AS Number_of_Data_Analyst_Jobs
FROM
    job_postings
WHERE
    LOWER(job_title) LIKE '%analyst%'
GROUP BY
    job_type
ORDER BY
    Number_of_Data_Analyst_Jobs DESC;

--Data analyst job postings count per job level(Mid senior, Associate)
SELECT 
    job_level, 
    COUNT(*) AS Number_of_Data_Analyst_Jobs
FROM 
    job_postings
WHERE 
    LOWER(job_title) LIKE '%analyst%'
GROUP BY 
    job_level
ORDER BY 
    Number_of_Data_Analyst_Jobs DESC;






