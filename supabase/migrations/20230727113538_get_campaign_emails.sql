CREATE OR REPLACE FUNCTION get_campaign_emails(campaign_id_param uuid)
RETURNS TABLE(email character varying) AS $$
BEGIN
RETURN QUERY 
    SELECT users.email
    FROM users
    JOIN user_audience_link ON users.id = user_audience_link.user_id
    WHERE user_audience_link.audience_id IN (
        SELECT campaign_audience_link.audience_id
        FROM campaign_audience_link
        WHERE campaign_audience_link.campaign_id = campaign_id_param
    );
END; $$ 
LANGUAGE 'plpgsql' SECURITY INVOKER;
