-- Migration: Alter id columns to have default value

-- 1. Name the migration file
-- The migration file should be named something like "20230630_alter_id_columns_to_have_default_value.sql",
-- where "20230630" is today's date in the format "YYYYMMDD".

-- 2. Generate the code to make the alterations
BEGIN;

ALTER TABLE audiences
    ALTER COLUMN id SET DEFAULT uuid_generate_v4();

ALTER TABLE questionnaires
    ALTER COLUMN id SET DEFAULT uuid_generate_v4();

COMMIT;
