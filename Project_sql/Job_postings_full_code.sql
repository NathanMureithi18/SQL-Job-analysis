-- Create the job_postings table
CREATE TABLE job_postings (
    job_link VARCHAR(255) PRIMARY KEY,
    last_processed_time TIMESTAMP,
    last_status BOOLEAN,
    got_summary BOOLEAN,
    got_ner BOOLEAN,
    is_being_worked BOOLEAN,
    job_title VARCHAR(255),
    company VARCHAR(255),
    job_location VARCHAR(255),
    first_seen DATE,
    search_city VARCHAR(255),
    search_country VARCHAR(255),
    search_position VARCHAR(255),
    job_level VARCHAR(255),
    job_type VARCHAR(255)
);


-- Create Job_skills table
CREATE TABLE job_skills (
    job_link VARCHAR(255),
    job_skills TEXT,
    FOREIGN KEY (job_link) REFERENCES job_postings(job_link)
);

-- Create Job_summary table
CREATE TABLE job_summary (
    job_link VARCHAR(255),
    job_summary TEXT,
    FOREIGN KEY (job_link) REFERENCES job_postings(job_link)
);

-- Change ownership of the tables to the postgres user
ALTER TABLE job_postings OWNER TO postgres;
ALTER TABLE job_skills OWNER TO postgres;
ALTER TABLE job_summary OWNER TO postgres;

-- Create indexes on foreign key columns
CREATE INDEX idx_job_skills_job_link ON job_skills (job_link);
CREATE INDEX idx_job_summary_job_link ON job_summary (job_link);


--Load job_postings csv file to the job_postings table
COPY job_postings
FROM 'C:/Users/DELL/Desktop/folders/job postings/job_postings.csv' DELIMITER ',' CSV HEADER;

--Load job_skills csv file to the job_skills table
COPY job_skills
FROM 'C:/Users/DELL/Desktop/folders/job postings/job_skills.csv' DELIMITER ',' CSV HEADER;

--Load job_summary csv file to the job_summary table
COPY job_summary
FROM 'C:/Users/DELL/Desktop/folders/job postings/job_summary.csv' DELIMITER ',' CSV HEADER;



-- Querying Data analyst job roles only
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
WHERE LOWER(job_title) LIKE '%analyst%' --Filter for the analyst job roles only



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



-- QUERY 1: Identify the most frequently mentioned skills in analyst job postings
-- Step 1: Extract individual skills from the job_skills column and filter for analyst roles
WITH ExtractedSkills AS (
    SELECT 
        jp.job_link, 
        jp.job_title,
        -- Unnest the job_skills string into individual skills
        unnest(string_to_array(js.job_skills, ',')) AS skill
    FROM 
        job_skills AS js
    INNER JOIN 
        job_postings AS jp ON js.job_link = jp.job_link
    -- Filter for job postings related to analyst roles
    WHERE 
        LOWER(jp.job_title) LIKE '%analyst%'
),

-- Step 2: Normalize the extracted skills by converting to lowercase and trimming spaces
NormalizedSkills AS (
    SELECT 
        job_link, 
        job_title,
        -- Convert skills to lowercase and trim any leading/trailing spaces
        LOWER(TRIM(skill)) AS normalized_skill
    FROM 
        ExtractedSkills
),

-- Step 3: Count the occurrences of each normalized skill
SkillCounts AS (
    SELECT 
        normalized_skill, 
        -- Count the number of occurrences of each skill
        COUNT(*) AS skill_count
    FROM 
        NormalizedSkills
    -- Group by the normalized skill to aggregate the counts
    GROUP BY 
        normalized_skill
)
-- Final Step: Select and display the skill counts, ordered by frequency
SELECT 
    *
FROM 
    SkillCounts
-- Order the results by skill count in descending order (most frequent skills first)
ORDER BY 
    skill_count DESC
LIMIT 10;



-- QUERY 2: Determine how the required skills vary across different job levels(Mid-senior,Associate)
-- Step 1:Extract skills from job postings and normalize them
WITH ExtractedSkills AS (
    SELECT 
        jp.job_link,
        jp.job_level,
        unnest(string_to_array(js.job_skills, ',')) AS skill 
        -- Split the comma-separated skills and unnest into rows
    FROM 
        job_skills AS js 
    INNER JOIN 
        job_postings AS jp ON js.job_link = jp.job_link 
    WHERE 
        LOWER(jp.job_title) LIKE '%analyst%'  
        
),
-- Step 2: Normalize skill names by trimming and converting to lower case
NormalizedSkills AS (
    SELECT 
        job_level, 
        LOWER(TRIM(skill)) AS normalized_skill 
        -- Normalize skill by trimming whitespace and converting to lowercase
    FROM 
        ExtractedSkills 
)
-- Step 3: Count the number of occurrences of each skill by job level
SELECT 
    job_level, 
    normalized_skill, 
    COUNT(*) AS skill_count 
FROM 
    NormalizedSkills
GROUP BY 
    job_level, normalized_skill 
ORDER BY 
    skill_count DESC
LIMIT 10;

-- 1. MID SENIOR
-- Step 1: Extract skills from job postings and normalize them
WITH ExtractedSkills AS (
    SELECT 
        jp.job_link,
        jp.job_level,
        unnest(string_to_array(js.job_skills, ',')) AS skill 
        -- Split the comma-separated skills and unnest into rows
    FROM 
        job_skills AS js 
    INNER JOIN 
        job_postings AS jp ON js.job_link = jp.job_link 
    WHERE 
        LOWER(jp.job_title) LIKE '%analyst%' 
),
-- Step 2: Normalize skill names by trimming and converting to lower case
NormalizedSkills AS (
    SELECT 
        job_level, 
        LOWER(TRIM(skill)) AS normalized_skill 
        -- Normalize skill by trimming whitespace and converting to lowercase
    FROM 
        ExtractedSkills 
)
-- Step 3: Count the number of occurrences of each skill by job level
SELECT 
    job_level, 
    normalized_skill, 
    COUNT(*) AS skill_count 
FROM 
    NormalizedSkills 
GROUP BY 
    job_level, normalized_skill 
ORDER BY 
    job_level DESC,skill_count DESC LIMIT 10;


-- 2. ASSOCIATE
-- Step 1:Extract skills from job postings and normalize them
WITH ExtractedSkills AS (
    SELECT 
        jp.job_link,
        jp.job_level,
        unnest(string_to_array(js.job_skills, ',')) AS skill 
        -- Split the comma-separated skills and unnest into rows
    FROM 
        job_skills AS js 
    INNER JOIN 
        job_postings AS jp ON js.job_link = jp.job_link 
    WHERE 
        LOWER(jp.job_title) LIKE '%analyst%'  AND LOWER(jp.job_level) IN ('associate')
        
),
-- Step 2: Normalize skill names by trimming and converting to lower case
NormalizedSkills AS (
    SELECT 
        job_level, 
        LOWER(TRIM(skill)) AS normalized_skill 
        -- Normalize skill by trimming whitespace and converting to lowercase
    FROM 
        ExtractedSkills 
)
-- Step 3: Count the number of occurrences of each skill by job level
SELECT 
    job_level, 
    normalized_skill, 
    COUNT(*) AS skill_count 
FROM 
    NormalizedSkills
GROUP BY 
    job_level, normalized_skill 
ORDER BY 
    skill_count DESC;


-- QUERY 3: Analyze how the demand for specific skills varies by location.
-- Extract and normalize skills from job postings 
WITH ExtractedSkills AS (
SELECT 
    jp.job_link, 
    jp.job_location, 
    unnest(string_to_array(js.job_skills, ',')) AS skill
    -- Split comma-separated skills and convert to individual rows
FROM 
    job_skills AS js 
INNER JOIN 
    job_postings AS jp ON js.job_link = jp.job_link 
WHERE 
    LOWER(jp.job_title) LIKE '%analyst%' 
),
-- CTE to normalize the skill names by trimming spaces and converting to lower case
NormalizedSkills AS (
    SELECT 
        job_location, 
        LOWER(TRIM(skill)) AS normalized_skill 
        -- Normalize skill names: trim leading/trailing spaces and convert to lower case
    FROM 
        ExtractedSkills 
)
-- Count occurrences of each skill by job location
SELECT 
    job_location, 
    normalized_skill, 
    COUNT(*) AS skill_count -- Count the number of occurrences of each skill for the given job location
FROM 
    NormalizedSkills 
GROUP BY 
    job_location, normalized_skill -- Group results by job location and skill
ORDER BY 
    skill_count DESC; 




