CREATE OR REPLACE FUNCTION insert_questions_and_links(
    questions JSONB,
    questionnaire_id UUID,
    user_id UUID
) RETURNS VOID AS $$
DECLARE
    question RECORD;
    new_question_id UUID; -- Variable to hold the ID of the newly inserted question
BEGIN   
    -- Loop over the questions and insert them into the 'questions' table
    FOR question IN SELECT * FROM jsonb_array_elements(questions)
    LOOP
        INSERT INTO questions (question, description, data, comment, created_by, updated_by, company_id)
        VALUES (
            question ->> 'question',
            question ->> 'description',
            question ->> 'data',
            question ->> 'comment',
            user_id,
            user_id,
            question ->> 'company_id'
        )
        RETURNING id INTO new_question_id; -- Get the ID of the newly inserted question
        
        -- Insert a new link into the 'question_questionnaire_link' table
        INSERT INTO question_questionnaire_link (question_id, questionnaire_id)
        VALUES (new_question_id, questionnaire_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;
