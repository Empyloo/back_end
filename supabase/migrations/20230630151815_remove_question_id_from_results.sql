ALTER TABLE results
DROP COLUMN question_id;

ALTER TABLE audiences
ALTER COLUMN id SET DEFAULT uuid_generate_v4();