-- Migration: Add company_id to questionnaires
-- Created at: 2023-07-01

BEGIN;

ALTER TABLE questionnaires ADD COLUMN company_id uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE;

COMMIT;
