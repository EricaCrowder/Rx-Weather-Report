-- Order failures for a specific business_id for today (UTC date)
-- Business ID: 12915
-- Run in Snowflake; adjust business_id or date as needed.

SELECT
  fpo.delivery_uuid,
  fpo.external_id,
  fpo.store_id AS dd_store_id,
  ds.business_id,
  ds.business_name,
  ds.name AS store_name,
  fpo.location_id,
  fpo.provider_type,
  fpo.created_at AS created_at_utc,
  fpo.created_at_local,
  fpo.order_status,
  fpo.failure_reason,
  fpo.failure_reason_decoded,
  'https://admin-gateway.doordash.com/support/customer/delivery/' || fpo.delivery_uuid AS dispatch_link
FROM
  static.pos_provider_classification ppc
  JOIN proddb.public.fact_pos_orders fpo
    ON ppc.provider_type = fpo.provider_type
  JOIN edw.merchant.dimension_store ds
    ON ds.store_id = fpo.store_id
WHERE
  ds.business_id = 12915
  AND fpo.order_status ILIKE '%fail%'
  AND fpo.created_at >= DATE_TRUNC('day', CURRENT_TIMESTAMP())
  AND fpo.created_at < DATE_TRUNC('day', CURRENT_TIMESTAMP()) + INTERVAL '1 day'
ORDER BY
  fpo.created_at DESC;
