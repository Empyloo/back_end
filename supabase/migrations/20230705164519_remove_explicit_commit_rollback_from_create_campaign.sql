CREATE OR REPLACE FUNCTION create_campaign(
    _name VARCHAR,
    _type VARCHAR,
    _count INTEGER,
    _threshold INTEGER,
    _duration INTEGER,
    _status VARCHAR,
    _company_id UUID,
    _created_by UUID,
    _next_run_time TIMESTAMP WITH TIME ZONE,
    _end_date TIMESTAMP WITH TIME ZONE,
    _frequency frequency_enum,
    _time_of_day TIME WITHOUT TIME ZONE,
    _audience_ids UUID[],
    _questionnaire_ids UUID[],
    _cloud_task_id VARCHAR DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
DECLARE
    _campaign_id UUID;
BEGIN
    -- Campaign Creation
    INSERT INTO campaigns (
        name,
        type,
        count,
        threshold,
        duration,
        status,
        company_id,
        created_by,
        next_run_time,
        end_date,
        frequency,
        time_of_day,
        cloud_task_id
    )
    VALUES (
        _name,
        _type,
        _count,
        _threshold,
        _duration,
        _status,
        _company_id,
        _created_by,
        _next_run_time,
        _end_date,
        _frequency,
        _time_of_day,
        _cloud_task_id
    )
    RETURNING id INTO _campaign_id;

    -- Handling Audience Linking
    FOR i IN 1..array_length(_audience_ids, 1)
    LOOP
        INSERT INTO campaign_audience_link (
            campaign_id,
            audience_id,
            created_by
        )
        VALUES (
            _campaign_id,
            _audience_ids[i],
            _created_by
        );
    END LOOP;

    -- Handling Questionnaire Linking
    FOR i IN 1..array_length(_questionnaire_ids, 1)
    LOOP
        INSERT INTO campaign_questionnaire_link (
            campaign_id,
            questionnaire_id,
            created_by
        )
        VALUES (
            _campaign_id,
            _questionnaire_ids[i],
            _created_by
        );
    END LOOP;

    -- Return the campaign id
    RETURN _campaign_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END;
$$;
