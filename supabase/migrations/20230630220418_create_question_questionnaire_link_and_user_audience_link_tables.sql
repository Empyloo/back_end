-- Migration: Create question_questionnaire_link and user_audience_link tables
-- Created at: 2023-06-30

BEGIN;

CREATE TABLE question_questionnaire_link (
    question_id UUID REFERENCES questions(id),
    questionnaire_id UUID REFERENCES questionnaires(id),
    created_by UUID REFERENCES users(id),
    edited_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMP,
    PRIMARY KEY (question_id, questionnaire_id)
);

COMMIT;
