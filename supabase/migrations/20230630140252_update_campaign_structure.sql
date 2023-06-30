-- Updates to existing tables

ALTER TABLE campaigns
ADD CONSTRAINT campaigns_name_unique UNIQUE (name);

ALTER TABLE campaigns
ADD COLUMN last_run_time TIMESTAMP;

ALTER TABLE campaigns
ADD COLUMN cloud_task_id VARCHAR(255);

ALTER TABLE campaigns
RENAME COLUMN schedule TO frequency;

ALTER TABLE campaigns
ADD COLUMN time_of_day TIME;

ALTER TABLE jobs
ALTER COLUMN name SET NOT NULL;

ALTER TABLE jobs
ADD COLUMN last_run_time TIMESTAMP;

ALTER TABLE jobs
ADD COLUMN cloud_task_id VARCHAR(255);

ALTER TABLE jobs
ADD COLUMN time_of_day TIME;

-- Create a new ENUM type for frequency
CREATE TYPE frequency_enum AS ENUM ('daily', 'weekly', 'fortnightly', 'monthly', 'quarterly', 'annually');

-- Add a new column with the new ENUM type
ALTER TABLE jobs
ADD COLUMN frequency_enum frequency_enum;

-- Populate the new column with the values from the old column
UPDATE jobs
SET frequency_enum = frequency::frequency_enum;

-- Drop the old column
ALTER TABLE jobs
DROP COLUMN frequency;

-- Rename the new column
ALTER TABLE jobs
RENAME COLUMN frequency_enum TO frequency;

-- Repeat the process for the campaigns table
ALTER TABLE campaigns
ADD COLUMN frequency_enum frequency_enum;

UPDATE campaigns
SET frequency_enum = frequency::frequency_enum;

ALTER TABLE campaigns
DROP COLUMN frequency;

ALTER TABLE campaigns
RENAME COLUMN frequency_enum TO frequency;

ALTER TABLE results
ADD COLUMN user_id UUID REFERENCES users(id);

-- New tables

CREATE TYPE audience_type AS ENUM ('custom', 'all');

CREATE TABLE audiences (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    count INT,
    type audience_type NOT NULL,
    created_by UUID REFERENCES users(id),
    edited_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_audience_link (
    user_id UUID REFERENCES users(id),
    audience_id UUID REFERENCES audiences(id),
    created_by UUID REFERENCES users(id),
    edited_by UUID REFERENCES users(id),
    PRIMARY KEY (user_id, audience_id)
);
