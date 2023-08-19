-- Create a view to aggregate audience and questionnaire IDs for each campaign.
CREATE VIEW campaign_with_links AS
SELECT 
    c.id, 
    c.name,
    c.count,
    c.threshold,
    c.status,
    c.company_id as companyId,
    c.created_by as createdBy,
    c.next_run_time as nextRunTime,
    c.type,
    c.duration,
    c.end_date as endDate,
    c.frequency,
    c.time_of_day as timeOfDay,
    c.description,
    array_agg(DISTINCT cal.audience_id) FILTER (WHERE cal.audience_id IS NOT NULL) as audienceIds,
    array_agg(DISTINCT cql.questionnaire_id) FILTER (WHERE cql.questionnaire_id IS NOT NULL) as questionnaireIds,
    c.cloud_task_id as cloudTaskId
FROM 
    campaigns c
LEFT JOIN 
    campaign_audience_link cal ON c.id = cal.campaign_id
LEFT JOIN 
    campaign_questionnaire_link cql ON c.id = cql.campaign_id
GROUP BY 
    c.id, 
    c.name,
    c.count,
    c.threshold,
    c.status,
    c.company_id,
    c.created_by,
    c.next_run_time,
    c.type,
    c.duration,
    c.end_date,
    c.frequency,
    c.time_of_day,
    c.description,
    c.cloud_task_id;
