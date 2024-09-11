-- Querying Dataanalyst job roles
SELECT 
    jp.job_link,
    jp.job_title,
    jp.last_status,
    jp.job_location,
    jp.is_being_worked,
    jp.job_level,
    jp.job_type,
    js.job_skills
FROM 
    job_postings AS jp
INNER JOIN job_skills AS js 
ON jp.job_link = js.job_link
WHERE LOWER(job_title) LIKE '%analyst%' 