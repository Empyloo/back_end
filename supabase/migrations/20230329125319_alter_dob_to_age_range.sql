ALTER TABLE users RENAME COLUMN date_of_birth TO age_range;
ALTER TABLE users ALTER COLUMN age_range TYPE varchar(255);