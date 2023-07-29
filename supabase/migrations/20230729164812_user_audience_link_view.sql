CREATE OR REPLACE VIEW audience_users AS 
SELECT 
    user_audience_link.audience_id, 
    users.email 
FROM 
    user_audience_link 
JOIN 
    users ON user_audience_link.user_id = users.id;
