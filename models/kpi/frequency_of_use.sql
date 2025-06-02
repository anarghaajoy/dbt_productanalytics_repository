WITH used_events AS (
    SELECT
        user_id,
        feature_name,
        date(event_time) as usage_date
    from {{ ref('fact_event') }}
    where event_name = 'feature_used'
),
usage_counts AS (
    SELECT
        u.user_id,
        u.feature_name,
        EXTRACT(MONTH FROM usage_date) AS usage_month,
        COUNT(*) AS total_uses,
        --DATE_DIFF(MAX(usage_date), MIN(usage_date), DAY) + 1 AS active_days
    FROM used_events u
    JOIN {{ref('dim_users')}} du
    ON u.user_id = du.user_id
    GROUP BY u.user_id, u.feature_name, usage_month
)

SELECT
    feature_name,
    usage_month,
    ROUND(AVG(total_uses),2) AS avg_monthly_frequency
FROM usage_counts
GROUP BY feature_name, usage_month
