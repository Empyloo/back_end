-- Migration file: 20230731_update_questionnaire_link_on_delete.sql

-- Short commit message: Update question_questionnaire_link table to cascade on delete

BEGIN;

-- Drop existing foreign key constraints
ALTER TABLE question_questionnaire_link
DROP CONSTRAINT question_questionnaire_link_question_id_fkey,
DROP CONSTRAINT question_questionnaire_link_questionnaire_id_fkey;

-- Add new foreign key constraints with ON DELETE CASCADE
ALTER TABLE question_questionnaire_link
ADD CONSTRAINT question_questionnaire_link_question_id_fkey 
FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE,
ADD CONSTRAINT question_questionnaire_link_questionnaire_id_fkey 
FOREIGN KEY (questionnaire_id) REFERENCES questionnaires (id) ON DELETE CASCADE;

COMMIT;
