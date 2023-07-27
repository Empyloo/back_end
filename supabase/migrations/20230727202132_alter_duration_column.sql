-- Add a new temporary column and copy the contents of `duration` over
ALTER TABLE campaigns ADD COLUMN duration_temp VARCHAR;
UPDATE campaigns SET duration_temp = duration::text;

-- Drop the original column and rename the temporary column
ALTER TABLE campaigns DROP COLUMN duration;
ALTER TABLE campaigns RENAME COLUMN duration_temp TO duration;

-- Repeat the same steps for the `jobs` table
ALTER TABLE jobs ADD COLUMN duration_temp VARCHAR;
UPDATE jobs SET duration_temp = duration::text;
ALTER TABLE jobs DROP COLUMN duration;
ALTER TABLE jobs RENAME COLUMN duration_temp TO duration;
