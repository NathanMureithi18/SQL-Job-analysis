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



