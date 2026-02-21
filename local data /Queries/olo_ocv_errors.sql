WITH error_summary AS (
  SELECT
    ocv.cart_id,
    ocv.store_id,
    ds.business_id,
    ds.business_name,
    ocv.external_cart_id,
    ocv.created_at,
    ocv.client_error_message,
    CONVERT_TIMEZONE('UTC', COALESCE(ds.timezone, 'UTC'), ocv.created_at) AS created_at_local,
    TRY_PARSE_JSON(ocv.raw_error):"num"::STRING AS error_code,
    ocv.raw_error
  FROM MX_INTEGRATIONS_PROD.PUBLIC.ORDER_VALIDATION ocv
  LEFT JOIN EDW.MERCHANT.DIMENSION_STORE ds
    ON ds.location_id = ocv.store_id
  WHERE ocv.provider_type = 'olo_rails'
    AND ds.pos_provider = 'olo_rails'
    AND ocv.created_at >= DATEADD(day, -7, CURRENT_DATE)
    AND ocv.raw_error IS NOT NULL
)
SELECT *
FROM error_summary
WHERE raw_error <> '';
