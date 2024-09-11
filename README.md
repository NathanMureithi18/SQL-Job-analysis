# Analyst Jobs Analysis
---
**Table of content**
 - [Introduction](#introduction)
 - [Background](#background)
 - [Tools](#️-tools-i-used)
 - [Analysis](#analysis)
 - [Conclusion](#conclusion)

## Introduction

📊 Welcome to the insights and analysis section of this repository. This 📝document provides a detailed overview of the potential analyses and insights that can be derived from the analyst job postings data. Our goal is to uncover valuable patterns and trends 📈 that can help in understanding the job market dynamics and the skill requirements specifically for analyst roles across various locations.

🔍 **SQL queries?** Check them out here: [Project_sql](Project_sql)



## Background

In today’s competitive job market, understanding the demand for various analyst roles and the associated skills is crucial for both job seekers and employers. This project emerged from a need to gain a deeper understanding of the current job market dynamics, particularly for data analysts, business analysts, and other related roles. By analyzing job postings, the objective is to identify key trends, in-demand skills, and common job titles to help streamline career planning and hiring strategies within the analyst domain.

The data used in this analysis comes from an extensive SQL course project, encompassing job postings data that includes information on job titles, required skills, locations, and other relevant details for analyst roles. This dataset provides a comprehensive view of the job market, allowing for insightful analysis on various aspects of job postings.

The primary questions driving this analysis were:
  
  - What are the most sought-after 🧠 skills across analyst job postings?
  - How do 💼 job titles and 🧠 skill requirements vary by job type and 🗺️ location for analyst roles?
  - Which companies are the 🏢 top employers of analysts, and what skills do they prioritize?
  - How do job posting trends for analyst roles evolve over 📅 time?
  - What are the 🔗 correlations between job levels, skills, and locations within analyst roles?

By addressing these questions, the analysis aims to provide actionable insights that can guide job seekers in identifying lucrative opportunities and help employers in targeting the right talent for analyst positions. This project not only enhances our understanding of the job market but also equips stakeholders with valuable information to make informed decisions.

## 🛠️ Tools I Used

For my deep dive into the analyst job market, I harnessed the power of several key tools:

  - **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
  - **PostgreSQL**: The chosen database management system, ideal for handling the analyst job posting data.
  - **VSCode**: My go-to for database management and executing SQL queries.
  - **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

## Analysis

To focus on the analyst job roles only we will filter the data: 

```sql
  -- Data analyst job roles
  SELECT 
      jp.job_link,
      jp.job_title,
      jp.is_being_worked,
      jp.job_level,
      jp.job_type,
      js.job_skills
  FROM 
      job_postings AS jp
  INNER JOIN
    job_skills AS js 
  ON
    jp.job_link = js.job_link
  WHERE
    LOWER(job_title) LIKE '%analyst%';
  ```

#### N/B: The job postings table contains only posting that are active.
```sql
  -- Active data analyst job role
  SELECT
    last_status,
    count(last_status) cnt
  FROM
    job_postings
  WHERE
    LOWER(job_title) LIKE '%analyst%' 
  GROUP BY
    last_status 
  ORDER BY
    cnt DESC;
```


### 1. Descriptive Analysis:
 - **Count of Analyst Jobs**: Determine the total number of analyst job postings.
```sql
    -- Number of data analyst job roles
    SELECT
      count(job_link) AS data_jobs
    FROM
      job_postings
    WHERE
      LOWER(job_title) LIKE '%analyst%' ;
```

  - **Company Analysis**: Identify which companies are posting the most analyst jobs.
```sql
  SELECT 
      company,
      count(company) AS Number_of_jobs
  FROM 
      job_postings 
  WHERE
    LOWER(job_title) LIKE '%analyst%'
  GROUP BY
    company 
  ORDER BY
    Number_of_jobs DESC;
```

  | Company           | Number of Data Analyst Jobs |
  | ----------------- | --------------------------- |
  | Agoda             | 92                          |
  | Deloitte          | 66                          |
  | ClearanceJobs     | 52                          |
  | Dice              | 47                          |
  | Jobs for Humanity | 26                          |
  
*Top 5 companies based on the data analyst job roles*


 - **Location Analysis**: Analyze the geographical distribution of analyst jobs to identify hotspots.
```sql
  SELECT
    job_location,
    count(job_location) AS No_of_jobs
  FROM
    job_postings
  WHERE
    LOWER(job_title) LIKE '%analyst%' 
  GROUP BY
    job_location
  ORDER BY
    No_of_jobs DESC;
```

  | Job Location       | Number of Data Analyst Jobs |
  |--------------------|-----------------------------|
  | New York, NY       | 77                          |
  | Washington, DC     | 52                          |
  | London, UK         | 50                          |
  | Atlanta, GA        | 48                          |
  | Austin, TX         | 46                          |

*Top 5 job_location based on the number of data analyst job roles*


 - **Job_level Analysis**: Examine the distribution of job levels (e.g., junior, mid, senior) to understand the experience required for different analyst roles.
```sql
  SELECT
    job_level,
    COUNT(*) AS level_count
  FROM
    job_postings
  WHERE
    LOWER(job_title) LIKE '%analyst%'
  GROUP BY
    job_level
  ORDER BY
    level_count DESC;
```
  
  | Job Level  | Number of Data Analyst Jobs |
  |------------|-----------------------------|
  | Mid Senior | 2204                        |
  | Associate  | 409                         |


 - **Job_type Analysis**: Analyze the types of analyst jobs being offered (e.g., full-time, part-time, contract).
```sql
  SELECT
    job_type,
    COUNT(*) AS type_count
  FROM
    job_postings
  WHERE
    LOWER(job_title) LIKE '%analyst%'
  GROUP BY
    job_type
  ORDER BY
    type_count DESC;
   ```


  | Job Type | Number of Data Analyst Jobs |
  |----------|-----------------------------|
  | Onsite   | 2612                        |
  | Remote   | 1                           |


### 2. Time series Analysis
 - **Job Posting Trends Over Time**: Analyze how the number of analyst job postings has changed over time (e.g., by month or year) to identify trends or seasonality.
```sql
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
```

![Job postings trends over time](assets\Data_analyst_job_count_over_time.jpeg)
*Line graph showing the number of Job postings over time. This chart was produced by ChatGPT*
### 3. Skill Analysis
 - **Most In-Demand Skills**:Identify the most frequently mentioned skills in analyst job postings. This analysis will reveal which skills are most valued by employers.
```sql
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
      skill_count DESC;
```

![Top 10 Skills for Data analysts](assets\Top_10_skills.jpeg)
*Bar graph visualizing the top 10 in demand skills for a data analyst job role. This chart was produced by ChatGPT*

Here's the breakdown of the most demanded skills for the data analyst jobs :
  - **Data analysis** is leading with a bold count of 1634.
  - **SQL** follows closely with a bold count of 1493.
  - **Data visualization** is also highly sought after, with a bold count of 1151.

Other skills like **Python**, **Tableau**, **Communication**, and **R** show varying degrees of demand.


 - **Skill Distribution by Job Level**: Determine how the required skills vary across different job levels (Mid senior, Associate).
  
  N/B : To determine the distinct job levels for the job postings 

  ```sql
  SELECT 
    DISTINCT job_levels 
  FROM 
    job_postings;
    -- Mid senior and Associate are the job levels
  ```

Filter the data to the specific job level(Associate,Mid senior)
 **1. Associate job level**
```sql
-- ASSOCIATE
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
```
![Top 10 in demand skills for Assocaite Data analyst job roles](assets\top_in_demand_skills_associate_level.png)
*Bar graph visualizing the top 10 in demand skill of Associate data analyst job roles. This chart was produced by ChatGPT*

 **2. Mid senior job level**
```sql
 -- MID SENIOR
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
    job_level DESC,skill_count DESC LIMIT 10;
```
![Top 10 in demand skills for the Mid senior Data analyst job role](assets\top_in_demand_skills_mid_senior_level_labeled.png)
*Bar graph showing the top in-demand skills for the Mid-senior job level. This chart was produced by ChatGPT*

 - **Skill Distribution by Location**:Analyze how the demand for specific skills varies by location.
```sql
Step 1: Extract skills from job postings and normalize them
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
-- Step 2: Normalize the skill names by trimming spaces and converting to lower case
NormalizedSkills AS (
    SELECT 
        job_location, 
        LOWER(TRIM(skill)) AS normalized_skill 
        -- Normalize skill names: trim leading/trailing spaces and convert to lower case
    FROM 
        ExtractedSkills 
)
-- Step 3: Count occurrences of each skill by job location
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
```
| job_location | normalized_skill | skill_count |
|---|---|---|
| New York, NY | data analysis | 46 |
| New York, NY | sql | 41 |
| Washington, DC | data analysis | 41 |
| Austin, TX | sql | 35 |
| Houston, TX | sql | 35 |
| London, England, Unit... | data analysis | 35 |
| New York, NY | python | 33 |
| Chicago, IL | data analysis | 32 |
| London, England, Unit... | sql | 31 |
| Washington, DC | data visualization | 30 |

**Data Analysis** and **SQL** are in high demand across all locations. New York and London have a wider range of in-demand skills. Data Visualization is emerging in Washington, DC.

## Conclusion
🔍 Key Takeaways:

This analysis of analyst job postings provides critical insights into the current landscape of analyst roles. By exploring trends in job titles, skill requirements, locations, and companies, we have gained valuable knowledge that can guide both job seekers and employers in navigating the job market. Here are some major takeaways:

 - In-demand skills such as **data analysis**, **SQL**, and **data visualization** are essential for securing analyst positions.
 - Top companies, like **Agoda**, **Deloitte**, and **ClearanceJobs**, lead in the hiring of analysts.
 - Location hotspots for analyst roles include **New York**, **Washington**, **London**, and **Atlanta**.
 - The job market favors mid-senior level roles, offering a wide array of opportunities for experienced professionals.
 - The majority of positions are onsite, though remote work opportunities remain rare in this dataset.

As the demand for data-driven decision-making continues to rise, understanding the dynamics of the analyst job market becomes even more crucial. This analysis not only uncovers current trends but also highlights the importance of continuous learning and skill development to stay competitive in this ever-evolving field.

---

🌟 **Closing Thought**:

In a rapidly changing world, the ability to adapt and stay ahead of market trends is key. As the role of analysts evolves, so must our approach to understanding the skills and opportunities that define success in this field. This analysis serves as a stepping stone, reminding us that data isn't just about numbers—it's about the insights and actions that shape the future.



