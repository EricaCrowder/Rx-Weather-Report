-- Snowflake version: last 30 days static query
-- Query to find failed POS orders from fact_pos_orders
SELECT
  fpo.delivery_uuid,
  fpo.external_id,
  fpo.store_id AS dd_store_id,
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
WHERE
  fpo.created_at >= DATEADD(day, -30, CURRENT_TIMESTAMP())
  AND fpo.order_status ILIKE '%fail%'
ORDER BY
  fpo.created_at DESC;
