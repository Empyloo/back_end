CREATE OR REPLACE FUNCTION post_to_slack()
RETURNS TRIGGER AS $$
BEGIN
    WITH message AS (
        SELECT json_build_object(
            'blocks', json_build_array(
                json_build_object(
                    'type', 'section',
                    'text', json_build_object(
                        'type', 'mrkdwn',
                        'text', 'New visitor on the landing page:\n\n' ||
                                '*Name:* ' || NEW.name || '\n' ||
                                '*Email:* ' || NEW.email || '\n' ||
                                '*Message:* ' || NEW.message
                    )
                )
            )
        ) AS message
    )
    SELECT net.http_post(
        url := 'https://hooks.slack.com/services/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',
        headers := '{"Content-Type": "application/json"}',
        body := (SELECT message FROM message)::text
    ) AS request_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION post_to_slack() IS 'Function for posting new landing page visitor data to Slack';

