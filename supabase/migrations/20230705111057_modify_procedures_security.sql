-- If these procedures already exist, drop them
DROP PROCEDURE IF EXISTS create_question;
DROP PROCEDURE IF EXISTS update_question;
DROP PROCEDURE IF EXISTS delete_question;
DROP PROCEDURE IF EXISTS get_questions_and_buckets_by_user;

-- if these functions already exist, drop them
DROP FUNCTION IF EXISTS get_question_bucket_info;
DROP FUNCTION IF EXISTS create_question;
DROP FUNCTION IF EXISTS update_question;
DROP FUNCTION IF EXISTS delete_question;
DROP FUNCTION IF EXISTS get_questions_and_buckets_by_user;

-- -- if these views already exist, drop them
-- DROP VIEW IF EXISTS questions_with_buckets;

-- -- Create a VIEW for easy querying
-- CREATE VIEW questions_with_buckets AS
-- SELECT q.id, q.question, q.description, q.data, q.comment, q.created_by, q.updated_by, q.company_id, q.approved, qb.id AS bucket_id, CAST(qb.name AS TEXT) AS bucket_name, qb.description AS bucket_description
-- FROM questions q
-- JOIN question_bucket_map qbm ON q.id = qbm.question_id
-- JOIN question_buckets qb ON qbm.question_bucket_id = qb.id;

-- Create a helper function
CREATE OR REPLACE FUNCTION get_question_bucket_info(question_id UUID)
RETURNS TABLE(
    id UUID,
    question TEXT,
    description TEXT,
    data JSONB,
    comment TEXT,
    created_by UUID,
    updated_by UUID,
    company_id UUID,
    approved BOOLEAN,
    bucket_id UUID,
    bucket_name TEXT,
    bucket_description TEXT
)
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
BEGIN
    RETURN QUERY SELECT q.* FROM questions_with_buckets q WHERE q.id = question_id;
END;
$$;

-- Create a stored procedure for creating a new question and associating it with a bucket atomically
CREATE OR REPLACE FUNCTION create_question(
    question TEXT,
    description TEXT,
    data JSONB,
    comment TEXT,
    created_by UUID,
    updated_by UUID,
    company_id UUID,
    approved BOOLEAN,
    question_bucket_id UUID
)
RETURNS SETOF questions_with_buckets
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
DECLARE
    new_question_id UUID;
BEGIN
    INSERT INTO questions (question, description, data, comment, created_by, updated_by, company_id, approved)
    VALUES (question, description, data, comment, created_by, updated_by, company_id, approved)
    RETURNING id INTO new_question_id;

    INSERT INTO question_bucket_map (question_id, question_bucket_id, created_by)
    VALUES (new_question_id, question_bucket_id, created_by);

    RETURN QUERY SELECT * FROM get_question_bucket_info(new_question_id);
END;
$$;

CREATE OR REPLACE FUNCTION update_question(
    _question_id UUID,
    _question TEXT,
    _description TEXT,
    _data JSONB,
    _comment TEXT,
    _updated_by UUID,
    _company_id UUID,
    _approved BOOLEAN
)
RETURNS SETOF questions_with_buckets
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
BEGIN
    UPDATE questions
    SET question = _question,
        description = _description,
        data = _data,
        comment = _comment,
        updated_by = _updated_by,
        company_id = _company_id,
        approved = _approved
    WHERE id = _question_id;
    
    RETURN QUERY SELECT * FROM get_question_bucket_info(_question_id);
END;
$$;

CREATE OR REPLACE FUNCTION delete_question(
    in_question_id UUID
)
RETURNS void
LANGUAGE plpgsql
SECURITY INVOKER
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
SECURITY INVOKER
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