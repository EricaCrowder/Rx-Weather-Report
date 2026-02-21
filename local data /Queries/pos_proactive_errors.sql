-- Query to pull POS proactive errors in the last 28 days
-- Filter by provider in the WHERE clause (e.g., 'revel_prod', 'olo_rails', etc.)
SELECT 
  pfo.*,
  fpo.delivery_uuid,
  fpo.external_id,
  fpo.store_id AS dd_store_id,
  fpo.location_id,
  fpo.provider_type,
  fpo.created_at AS created_at_utc,
  fpo.created_at_local,
  fpo.order_status,
  fpo.failure_reason,
  fpo.failure_reason_decoded
FROM PRODDB.PUBLIC.pos_failed_orders pfo
INNER JOIN PRODDB.PUBLIC.DIMENSION_DELIVERIES dd
  ON TRY_TO_NUMERIC(pfo.delivery_id) = TRY_TO_NUMERIC(dd.delivery_id)
INNER JOIN static.pos_provider_classification ppc
  ON ppc.provider_type = pfo.provider
INNER JOIN proddb.public.fact_pos_orders fpo
  ON fpo.delivery_uuid = dd.delivery_uuid
WHERE LOWER(pfo.provider) = 'revel_prod'
  AND dd.created_at >= DATEADD(day, -28, CURRENT_TIMESTAMP());