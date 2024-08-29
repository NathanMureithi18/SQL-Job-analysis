# Analyst Jobs Analysis

## Introduction

📊 Welcome to the insights and analysis section of this repository. This 📝document provides a detailed overview of the potential analyses and insights that can be derived from the analyst job postings data. Our goal is to uncover valuable patterns and trends 📈 that can help in understanding the job market dynamics and the skill requirements specifically for analyst roles across various locations.

🔍 **SQL queries?** Check them out here:

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
  - **DBeaver**: My go-to for database management and executing SQL queries.
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
  INNER JOIN job_skills AS js 
  ON jp.job_link = js.job_link
  WHERE LOWER(job_title) LIKE '%analyst%';
  ```

#### N/B: The job postings table contains only posting that are active.
```sql
  -- Active data analyst job role
  SELECT
    last_status,
    count(last_status) cnt
  FROM
    job_postings
  WHERE LOWER(job_title) LIKE '%analyst%' 
  GROUP BY last_status 
  ORDER BY cnt DESC;
```

### 1. Descriptive Analysis:
 - **Count of Analyst Jobs**: Determine the total number of analyst job postings.
    ```sql
    SELECT
      count(job_link) AS data_jobs
    FROM
      job_postings
    WHERE
      LOWER(job_title) LIKE '%analyst%' ;
 - **Location Analysis**: Analyze the geographical distribution of analyst jobs to identify hotspots.

   
 - **Company Analysis**: Identify which companies are posting the most analyst jobs.







