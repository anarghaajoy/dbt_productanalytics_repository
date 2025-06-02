WITH usage_counts AS (
    SELECT
        user_id,
        feature_name,
        COUNT(*) AS usage_count
    FROM {{ ref('fact_event') }}
    WHERE event_name = 'feature_used'
    GROUP BY user_id, feature_name
),

stats AS (
    SELECT
        feature_name,
        COUNT(*) AS total_users,
        SUM(CASE WHEN usage_count = 1 THEN 1 ELSE 0 END) AS dropoff_users
    FROM usage_counts
    GROUP BY feature_name
)

SELECT
    feature_name,
    ROUND((dropoff_users * 1.0 / total_users)*100, 2) AS dropoff_rate
FROM stats
