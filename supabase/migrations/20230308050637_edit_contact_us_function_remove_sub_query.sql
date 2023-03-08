CREATE OR REPLACE FUNCTION post_to_slack() 
RETURNS TRIGGER AS $$
BEGIN 
    SELECT net.http_post(
        url := 'https://hooks.slack.com/services/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'::text, 
        headers := '{"Content-Type": "application/json"}'::jsonb, 
        body := json_build_object(
            'blocks', json_build_array(
                json_build_object(
                    'type', 'section', 
                    'text', json_build_object(
                        'type', 'mrkdwn', 
                        'text', 'New visitor on the landing page:\n\n' 
                            || '*CompanyName:* ' || NEW.company || '\n' 
                            || '*Email:* ' || NEW.email || '\n' 
                            || '*Message:* ' || NEW.message
                    )
                )
            )
        )::text
    ) AS request_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
