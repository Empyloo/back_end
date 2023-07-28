CREATE VIEW campaign_questions AS 
SELECT 
  campaign_questionnaire_link.campaign_id, 
  questions.*
FROM 
  campaign_questionnaire_link
INNER JOIN question_questionnaire_link 
  ON campaign_questionnaire_link.questionnaire_id = question_questionnaire_link.questionnaire_id
INNER JOIN questions 
  ON question_questionnaire_link.question_id = questions.id;
