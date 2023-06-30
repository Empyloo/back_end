-- Migration: Add count column to questionnaires table
-- Created at: 2023-06-30

BEGIN;

ALTER TABLE questionnaires ADD COLUMN count INTEGER;

COMMIT;
