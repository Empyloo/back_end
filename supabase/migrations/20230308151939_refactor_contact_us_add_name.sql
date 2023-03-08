ALTER TABLE contact_us ADD COLUMN name text;

CREATE OR REPLACE FUNCTION public.post_to_slack() 
RETURNS TRIGGER AS $$
BEGIN 
    PERFORM net.http_post(
        url := 'https://hooks.slack.com/services/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', 
        headers := '{"Content-Type": "application/json"}'::jsonb, 
        body := json_build_object(
            'blocks', json_build_array(
                json_build_object(
                    'type', 'header',
                    'text', json_build_object(
                        'type', 'plain_text',
                        'text', 'New visitor on the landing page'
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
                            'text', ':office: *CompanyName:*'
                        ),
                        json_build_object(
                            'type', 'plain_text',
                            'text', NEW.company
                        )
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
                            'text', ':bust_in_silhouette: *Name:*'
                        ),
                        json_build_object(
                            'type', 'plain_text',
                            'text', NEW.name
                        )
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
                            'text', ':e-mail: *Email:*'
                        ),
                        json_build_object(
                            'type', 'mrkdwn',
                            'text', NEW.email
                        )
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
                            'text', ':speech_balloon: *Message:*'
                        )
                    )
                ),
                json_build_object(
                    'type', 'section',
                    'text', json_build_object(
                        'type', 'plain_text',
                        'text', NEW.message
                    )
                )
            )
        )::jsonb
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS post_visitor_to_slack ON "contact_us";
CREATE TRIGGER post_visitor_to_slack AFTER INSERT ON "contact_us" FOR EACH ROW EXECUTE FUNCTION public.post_to_slack();
