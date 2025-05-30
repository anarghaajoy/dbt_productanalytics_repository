WITH dim_utm AS (
    SELECT DISTINCT
        utm_source,
        utm_medium,
        utm_campaign,
        utm_term,
        utm_content
    FROM {{ ref('stg_feature_events') }}
)

SELECT
    row_number() over() AS utm_key,
    utm_source,
    utm_medium,
    utm_campaign,
    utm_term,
    utm_content
FROM dim_utm