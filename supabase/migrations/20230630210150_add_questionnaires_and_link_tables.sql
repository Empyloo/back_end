-- Migration: Create questionnaires and campaign_questionnaire_link tables with edited_at column
-- Created at: 2023-06-30

BEGIN;

CREATE TABLE questionnaires (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_by UUID REFERENCES users(id),
    edited_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE campaign_questionnaire_link (
    campaign_id UUID REFERENCES campaigns(id),
    questionnaire_id UUID REFERENCES questionnaires(id),
    created_by UUID REFERENCES users(id),
    edited_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (campaign_id, questionnaire_id)
);

COMMIT;
