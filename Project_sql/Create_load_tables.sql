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


SELECT * from job_postings;

