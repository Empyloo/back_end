ALTER TABLE jobs
DROP CONSTRAINT jobs_campaign_id_fkey;

ALTER TABLE jobs
ADD CONSTRAINT jobs_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES campaigns (id) ON DELETE CASCADE;
