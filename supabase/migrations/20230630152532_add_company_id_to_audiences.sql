ALTER TABLE audiences
ADD COLUMN company_id UUID REFERENCES companies(id);
