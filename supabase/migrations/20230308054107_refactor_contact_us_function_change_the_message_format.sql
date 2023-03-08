CREATE OR REPLACE FUNCTION public.post_to_slack() 
RETURNS TRIGGER AS $$
BEGIN 
    PERFORM net.http_post(
        url := 'https://hooks.slack.com/services/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', 
        headers := '{"Content-Type": "application/json"}'::jsonb, 
        body := json_build_object(
            'blocks', json_build_array(
                json_build_object(
                    'type', 'section',
                    'text', json_build_object(
                        'type', 'mrkdwn',
                        'text', '*New visitor on the landing page:*'
                    )
                ),
                json_build_object(
                    'type', 'divider'
                ),
                json_build_object(
                    'type', 'section',
                    'fields', json_build_array(
                        json_build_object(
                            'type', 'mrkdwn',
                            'text', '*CompanyName:*\n' || NEW.company
                        ),
                        json_build_object(
                            'type', 'mrkdwn',
                            'text', '*Email:*\n' || NEW.email
                        )
                    )
                ),
                json_build_object(
                    'type','section',
                    'text',json_build_object(
                        'type', 'mrkdwn',
                        'text', '*Message:*\n' || NEW.message
                    )
                )
            )
        )::jsonb
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop trigger post_visitor_to_slack on "contact_us";
CREATE TRIGGER post_visitor_to_slack AFTER INSERT ON "contact_us" FOR EACH ROW EXECUTE FUNCTION public.post_to_slack();
