WITH used_events AS (
    SELECT
        user_id,
        feature_name,
        date(timestamp) as usage_date
    from {{ ref('fact_event') }}
    where event_name = 'feature_used'
),
usage_counts AS (
    SELECT
        u.user_id,
        u.feature_name,
        count(*) AS total_uses,
        TIMESTAMP_DIFF(du.first_used, du.first_seen, DAY) + 1 AS active_days
    FROM used_events u
    JOIN {{ref('dim_users')}} du
    ON u.user_id = du.user_id
    GROUP BY u.user_id, u.feature_name, du.first_used, du.first_seen
)

SELECT
    feature_name,
    avg(total_uses * 1.0 / active_days) AS avg_daily_frequency
FROM usage_counts
GROUP BY feature_name
