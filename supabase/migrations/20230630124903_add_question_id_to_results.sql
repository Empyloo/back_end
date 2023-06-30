-- Migration: Add question_id column to results table
-- Created at: 2023-06-30

BEGIN;

ALTER TABLE results ADD question_id UUID;

COMMIT;
