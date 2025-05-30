WITH stg_users AS (
    SELECT
        user_id,
        user_type,
        min(timestamp) AS signed_up_at
    FROM {{ ref('stg_feature_events') }}
    WHERE event_name = 'signed_up'
    GROUP BY user_id, user_type
),
stg_users1 AS (
    SELECT
        user_id,
        user_type,
        min(timestamp) AS first_seen
    FROM {{ ref('stg_feature_events') }}
    WHERE event_name = 'feature_viewed'
    GROUP BY user_id, user_type
),
stg_users2 AS (
    SELECT
        user_id,
        user_type,
        min(timestamp) AS first_used
    FROM {{ ref('stg_feature_events') }}
    WHERE event_name = 'feature_used'
    GROUP BY user_id, user_type
)

SELECT
    stg_users.user_id,
    stg_users.user_type,
    signed_up_at,
    first_seen,
    first_used
FROM stg_users JOIN stg_users1
ON stg_users.user_id = stg_users1.user_id
JOIN stg_users2
ON stg_users.user_id = stg_users2.user_id