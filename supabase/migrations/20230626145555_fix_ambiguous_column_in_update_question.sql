-- DROP function first if it already exists
DROP FUNCTION IF EXISTS update_question;

-- Create a stored procedure for updating an existing question
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
