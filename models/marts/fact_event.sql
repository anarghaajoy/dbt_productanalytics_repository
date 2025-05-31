WITH fact_event AS (
    SELECT
        e.user_id,
        e.event_name,
        e.feature_name,
        e.session_id,
        e.timestamp,
        dut.utm_key
    FROM {{ ref('stg_feature_events') }} e
    LEFT JOIN {{ ref('dim_users') }} du
        ON e.user_id = du.user_id
    LEFT JOIN {{ ref('dim_utm') }} dut
        ON e.utm_source = dut.utm_source
        AND e.utm_medium = dut.utm_medium
        AND e.utm_campaign = dut.utm_campaign
        AND e.utm_term = dut.utm_term
        AND e.utm_content = dut.utm_content
)

SELECT
    row_number() over() AS event_id,
    user_id,
    utm_key,
    event_name,
    feature_name,
    session_id,
    timestamp
from fact_event