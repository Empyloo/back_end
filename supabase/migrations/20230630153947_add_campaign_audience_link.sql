CREATE TABLE campaign_audience_link (
    campaign_id UUID REFERENCES campaigns(id),
    audience_id UUID REFERENCES audiences(id),
    created_by UUID REFERENCES users(id),
    edited_by UUID REFERENCES users(id),
    PRIMARY KEY (campaign_id, audience_id)
);
