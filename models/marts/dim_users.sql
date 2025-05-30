WITH dim_users AS(
    SELECT
        user_id,
        user_type,
        signed_up_at,
        first_seen,
        last_seen,
        first_used,
        last_used
    FROM {{ ref('stg_users')}}
)

SELECT * FROM dim_users