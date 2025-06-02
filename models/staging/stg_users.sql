WITH stg_users AS (
    SELECT
        user_id,
        user_type,
        min(event_time) AS signed_up_at
    FROM {{ ref('stg_feature_events') }}
    WHERE event_name = 'signed_up'
    GROUP BY user_id, user_type
),
stg_users1 AS (
    SELECT
        user_id,
        user_type,
        min(event_time) AS first_seen,
        max(event_time) AS last_seen
    FROM {{ ref('stg_feature_events') }}
    WHERE event_name = 'feature_viewed'
    GROUP BY user_id, user_type
),
stg_users2 AS (
    SELECT
        user_id,
        user_type,
        min(event_time) AS first_used,
        max(event_time) AS last_used
    FROM {{ ref('stg_feature_events') }}
    WHERE event_name = 'feature_used'
    GROUP BY user_id, user_type
)

SELECT
    stg_users.user_id,
    stg_users.user_type,
    signed_up_at,
    first_seen,
    last_seen,
    first_used,
    last_used
FROM stg_users LEFT JOIN stg_users1
ON stg_users.user_id = stg_users1.user_id
LEFT JOIN stg_users2
ON stg_users.user_id = stg_users2.user_id