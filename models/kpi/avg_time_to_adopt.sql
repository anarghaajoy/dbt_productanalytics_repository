WITH adoption_rate AS(
    SELECT
        fe.user_id,
        fe.feature_name,
        du.first_seen,
        du.first_used,
        TIMESTAMP_DIFF(du.first_used, du.first_seen, HOUR) AS time_to_adopt_hr
    FROM {{ref('fact_event')}} fe
    JOIN {{ref('dim_users')}} du
    ON fe.user_id = du.user_id
    WHERE fe.feature_name = 'Feature X'
)

SELECT 
    feature_name, 
    ROUND(AVG(time_to_adopt_hr)/24,2) AS avg_time_to_adopt_days
FROM adoption_rate
GROUP BY feature_name