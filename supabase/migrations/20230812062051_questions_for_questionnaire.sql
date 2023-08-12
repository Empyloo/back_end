CREATE OR REPLACE FUNCTION get_questions_for_questionnaire(questionnaire_id UUID)
RETURNS TABLE (
    id UUID,
    question TEXT,
    description TEXT,
    data JSONB,
    comment TEXT,
    created_by UUID,
    updated_by UUID,
    company_id UUID
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        q.id, 
        q.question, 
        q.description, 
        q.data, 
        q.comment, 
        q.created_by, 
        q.updated_by, 
        q.company_id 
    FROM 
        questions q 
    JOIN 
        question_questionnaire_link qql ON q.id = qql.question_id
    WHERE 
        qql.questionnaire_id = get_questions_for_questionnaire.questionnaire_id;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;
