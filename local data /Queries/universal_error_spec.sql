-- Universal error spec query
-- Shows how to join pos_failed_orders with maindb_order and dimension_deliveries
SELECT *
FROM pos_failed_orders po
JOIN DOORDASH_POINTOFSALE.PUBLIC.MAINDB_ORDER oo 
  ON TRY_TO_NUMERIC(oo.order_id) = po.delivery_id
JOIN PRODDB.PUBLIC.DIMENSION_DELIVERIES dd
  ON TRY_TO_NUMERIC(oo.order_id) = TRY_TO_NUMERIC(dd.delivery_id)
  AND TRY_TO_NUMERIC(po.delivery_id) = TRY_TO_NUMERIC(dd.delivery_id)
WHERE oo.created_at > CURRENT_DATE - 7
  AND oo.provider_type = 'checkmate';
