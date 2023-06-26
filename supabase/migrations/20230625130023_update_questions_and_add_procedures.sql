-- Add an approved column to the questions table
ALTER TABLE questions 
ADD COLUMN approved BOOLEAN DEFAULT false;

COMMENT ON COLUMN questions.approved IS 'This indicates if a question is approved or not';

-- Add a company_id column to the questions table
ALTER TABLE questions 
ADD COLUMN company_id UUID NOT NULL, 
ADD FOREIGN KEY (company_id) REFERENCES companies (id);

-- Rename the question_question_buckets table to question_bucket_map
ALTER TABLE question_question_buckets 
RENAME TO question_bucket_map;


-- Create an index on company_id for performance improvement
CREATE INDEX idx_questions_company_id ON questions (company_id);
-- Create a VIEW for easy querying
CREATE VIEW questions_with_buckets AS
SELECT q.id, q.question, q.description, q.data, q.comment, q.created_by, q.updated_by, q.company_id, q.approved, qb.id AS bucket_id, qb.name AS bucket_name, qb.description AS bucket_description
FROM questions q
JOIN question_bucket_map qbm ON q.id = qbm.question_id
JOIN question_buckets qb ON qbm.question_bucket_id = qb.id;

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
AS $$
BEGIN
    RETURN QUERY SELECT * FROM questions_with_buckets WHERE id = question_id;
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

-- Create a stored procedure for updating an existing question
CREATE OR REPLACE FUNCTION update_question(
    question_id UUID,
    question TEXT,
    description TEXT,
    data JSONB,
    comment TEXT,
    updated_by UUID,
    company_id UUID,
    approved BOOLEAN
)
RETURNS SETOF questions_with_buckets
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE questions
    SET question = question,
        description = description,
        data = data,
        comment = comment,
        updated_by = updated_by,
        company_id = company_id,
        approved = approved
    WHERE id = question_id;
    
    RETURN QUERY SELECT * FROM get_question_bucket_info(question_id);
END;
$$;

-- Create a stored procedure for deleting an existing question and its associations
CREATE OR REPLACE FUNCTION delete_question(
    question_id UUID
)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    -- First, delete the associations from the junction table
    DELETE FROM question_bucket_map WHERE question_id = question_id;

    -- Then delete the question itself
    DELETE FROM questions WHERE id = question_id;
END;
$$;


-- Create a stored procedure to get questions and buckets by user
CREATE OR REPLACE FUNCTION get_questions_and_buckets_by_user(
    empylo_company_id UUID,
    user_company_id UUID
)
RETURNS SETOF questions_with_buckets
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT * FROM questions_with_buckets WHERE company_id IN (empylo_company_id, user_company_id) AND approved;
END;
$$;
