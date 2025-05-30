with stg_feature_events as (
    select
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
    from Events.feature_events
)

select * from stg_feature_events