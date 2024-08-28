# SQL Jobs Analysis

## Intoduction

📊 Welcome to the insights and analysis section of this repository. This document provides a detailed overview of the potential analyses and insights that can be derived from the tech_job postings data. Our goal is to uncover valuable patterns and trends 📈 that can help in understanding job market dynamics and the skill requirements across various roles and locations.

🔍 SQL queries? Check them out here:

## Background

In today’s competitive job market, understanding the demand for various skills and job roles is crucial for both job seekers and employers. This project emerged from a need to gain a deeper understanding of the current job market dynamics, particularly in the field of data analysis and related roles. By analyzing job postings, the objective is to identify key trends, in-demand skills, and common job titles to help streamline career planning and hiring strategies.

The data used in this analysis comes from an extensive SQL course project, encompassing job postings data that includes information on job titles, required skills, locations, and other relevant details. This dataset provides a comprehensive view of the job market, allowing for insightful analysis on various aspects of job postings.

The primary questions driving this analysis were:

  - What are the most sought-after skills across different job postings?
  - How do job titles and skill requirements vary by job type and location?
  - Which companies are the top employers, and what skills do they prioritize?
  - How do job postings trends evolve over time?
  - What are the correlations between job levels, skills, and locations?
    
By addressing these questions, the analysis aims to provide actionable insights that can guide job seekers in identifying lucrative opportunities and help employers in targeting the right talent. This project not only enhances our understanding of the job market but also equips stakeholders with valuable information to make informed decisions.

## Tools I Used

For my deep dive into the job market, I harnessed the power of several key tools:

 - **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
 - **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
 - **Visual Studio Code**: My go-to for database management and executing SQL queries.
 - **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

## Insights and Analysis



### Job Title and Seniority Analysis

1. **Common Job Titles**: Determine the most frequently listed job titles.
2. **Job Level Distribution**: Analyze the distribution of job levels (e.g., entry, mid, senior) across different roles.
3. **Title vs. Skill Correlation**: Examine the correlation between job titles and required skills.

### Skill Analysis

1. **Top Skills**: Identify the most common skills required across all job postings.
2. **Skill Distribution by Job Type**: Analyze which skills are more common in certain job types (e.g., onsite vs. remote).
3. **Skill Clustering**: Group similar job titles by skill sets to identify common roles and required expertise.

### Location-Based Analysis

1. **Job Distribution by Location**: Identify which cities or countries have the highest number of job postings.
2. **Location vs. Job Type**: Analyze how job types (e.g., remote, onsite) vary by location.

### Company Analysis

1. **Top Hiring Companies**: Identify the companies with the most job postings.
2. **Company vs. Skill Requirements**: Compare skill requirements across different companies.

### Time-Based Analysis

1. **Job Posting Trends**: Analyze trends in job postings over time (using `first_seen` and `last_processed_time`).
2. **Processing and Status Analysis**: Examine the status and processing flags to assess how job postings are being handled over time.

### Combination Analysis

1. **Multi-Dimensional Analysis**: Combine insights, such as looking at the most in-demand skills by location and job level.
2. **Correlations**: Explore correlations between different variables, like how job level influences required skills or how certain companies prefer specific job levels and skills.
