-- Migration: Add ON DELETE CASCADE constraints to link tables
-- Created at: 2023-06-30

BEGIN;

ALTER TABLE campaign_audience_link DROP CONSTRAINT campaign_audience_link_campaign_id_fkey;
ALTER TABLE campaign_audience_link ADD CONSTRAINT campaign_audience_link_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE;
ALTER TABLE campaign_audience_link DROP CONSTRAINT campaign_audience_link_audience_id_fkey;
ALTER TABLE campaign_audience_link ADD CONSTRAINT campaign_audience_link_audience_id_fkey FOREIGN KEY (audience_id) REFERENCES audiences(id) ON DELETE CASCADE;

ALTER TABLE campaign_questionnaire_link DROP CONSTRAINT campaign_questionnaire_link_campaign_id_fkey;
ALTER TABLE campaign_questionnaire_link ADD CONSTRAINT campaign_questionnaire_link_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE;
ALTER TABLE campaign_questionnaire_link DROP CONSTRAINT campaign_questionnaire_link_questionnaire_id_fkey;
ALTER TABLE campaign_questionnaire_link ADD CONSTRAINT campaign_questionnaire_link_questionnaire_id_fkey FOREIGN KEY (questionnaire_id) REFERENCES questionnaires(id) ON DELETE CASCADE;

COMMIT;
