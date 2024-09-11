--Data analyst job postings count over time
SELECT 
    extract(MONTH FROM last_processed_time) AS month, 
    extract(DAY FROM last_processed_time) AS day,
    TO_CHAR(last_processed_time, 'Day') AS day_name,
    COUNT(*) AS job_count
FROM 
    job_postings
WHERE 
    LOWER(job_title) LIKE '%analyst%'
GROUP BY 
    month, day, day_name
ORDER BY 
    day;