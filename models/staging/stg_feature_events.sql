WITH stg_feature_events AS (
    select
        row_number() over() as event_id,
        user_id,
        event_name,
        feature_name,
        user_type,
        session_id,
        timestamp,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_term,
        utm_content
    FROM event.feature_events
)

SELECT * FROM stg_feature_events