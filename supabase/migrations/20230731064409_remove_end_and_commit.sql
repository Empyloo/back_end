CREATE OR REPLACE FUNCTION insert_questions_and_link_to_questionnaire(
    questions JSONB,
    questionnaire_id UUID,
    created_by UUID,
    updated_by UUID
)
RETURNS VOID AS $$
DECLARE
    question JSONB;
    new_question_id UUID;
BEGIN

    -- Loop over the questions and insert them into the 'questions' table
    FOR question IN SELECT * FROM jsonb_array_elements(questions)
    LOOP
        INSERT INTO questions (question, description, data, comment, created_by, updated_by, company_id)
        VALUES (
            question ->> 'question',
            question ->> 'description',
            question -> 'data',
            question ->> 'comment',
            created_by,
            updated_by,
            (question ->> 'company_id')::UUID
        )
        RETURNING id INTO new_question_id; -- Get the ID of the newly inserted question

        -- Insert a new link into the 'question_questionnaire_link' table
        INSERT INTO question_questionnaire_link (question_id, questionnaire_id)
        VALUES (new_question_id, questionnaire_id);
    END LOOP;

END;
$$ LANGUAGE plpgsql SECURITY INVOKER;
