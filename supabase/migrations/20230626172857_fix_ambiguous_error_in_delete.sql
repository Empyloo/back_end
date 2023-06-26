-- If these procedures already exist, drop them
DROP FUNCTION IF EXISTS delete_question;
DROP FUNCTION IF EXISTS get_questions_and_buckets_by_user;

-- Create a stored procedure for deleting an existing question and its associations
CREATE OR REPLACE FUNCTION delete_question(
    in_question_id UUID
)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    -- First, delete the associations from the junction table
    DELETE FROM question_bucket_map WHERE question_id = in_question_id;

    -- Then delete the question itself
    DELETE FROM questions WHERE id = in_question_id;
END;
$$;

-- Create a stored procedure to get questions and buckets by user
CREATE OR REPLACE FUNCTION get_questions_and_buckets_by_user(
    in_user_id UUID
)
RETURNS SETOF questions_with_buckets
LANGUAGE plpgsql
AS $$
DECLARE
    user_company_id UUID;
    empylo_company_id UUID;
BEGIN
    -- Get the user's company_id
    SELECT company_id INTO user_company_id FROM users WHERE id = in_user_id;
    IF user_company_id IS NULL THEN
        RAISE EXCEPTION 'User with id % does not exist.', in_user_id;
    END IF;

    -- Get Empylo's company_id
    SELECT id INTO empylo_company_id FROM companies WHERE name = 'Empylo';
    IF empylo_company_id IS NULL THEN
        RAISE EXCEPTION 'Company with name "Empylo" does not exist.';
    END IF;

    RETURN QUERY SELECT * FROM questions_with_buckets WHERE company_id IN (empylo_company_id, user_company_id) AND approved;
END;
$$;
