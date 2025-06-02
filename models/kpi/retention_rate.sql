WITH user_first_use AS(
    SELECT
        user_id,
        feature_name,
        MIN(DATE(event_time)) AS first_used
    FROM {{ ref('fact_event')}}
    WHERE event_name = 'feature_used'
    GROUP BY user_id, feature_name
),
subsequent_uses AS (
    SELECT
        f.user_id,
        f.feature_name,
        DATE_TRUNC(DATE(f.event_time), MONTH) AS usage_month,
        EXTRACT(MONTH FROM u.first_used) AS cohort_month
    FROM {{ ref('fact_event') }} f
    JOIN user_first_use u
      ON f.user_id = u.user_id AND f.feature_name = u.feature_name
    WHERE f.event_name = 'feature_used'
),
retention_rate AS(
    SELECT
        feature_name,
        cohort_month,
        ROUND((COUNT(DISTINCT user_id)/(SELECT COUNT(*) FROM {{ ref('dim_users')}}))*100, 2) AS retention_rate
        FROM subsequent_uses
        GROUP BY feature_name, cohort_month
)

SELECT * FROM retention_rate