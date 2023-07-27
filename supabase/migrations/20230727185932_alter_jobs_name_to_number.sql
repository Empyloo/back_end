-- migration changing name to number of type integer
-- Path: supabase/migrations/20230727185932_alter_jobs_name_to_number.sql

ALTER TABLE IF EXISTS public.jobs RENAME COLUMN name TO number;
ALTER TABLE IF EXISTS public.jobs ALTER COLUMN number TYPE INTEGER USING number::INTEGER;