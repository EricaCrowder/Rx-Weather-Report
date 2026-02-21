WITH orders_recent AS (
  SELECT
    o.order_id,
    o.provider_type,
    DATE(o.created_at) AS order_date,
    ds.store_id,
    b.business_id,
    COALESCE(b.management_type, 'Unknown') AS management_type
  FROM edw.merchant.mx_integrations_orders o
  LEFT JOIN edw.finance.dimension_local_deliveries dld
    ON TRY_TO_NUMBER(o.order_id) = dld.delivery_id
  LEFT JOIN edw.merchant.dimension_store ds
    ON ds.store_id = dld.store_id
  LEFT JOIN edw.merchant.dimension_business b
    ON b.business_id = ds.business_id
  WHERE o.provider_type IN (
      'olo_rails',
      'toast',
      'clover',
      'chowly',
      'checkmate',
      'deliverect',
      'otter_production',
      'square_v2_production'
  )
    AND DATE(o.created_at) >= DATEADD(day, -28, CURRENT_DATE)
    AND DATE(o.created_at) < CURRENT_DATE
    AND LOWER(o.provider_type) NOT LIKE '%staging%'
    AND LOWER(o.provider_type) NOT LIKE '%sandbox%'
    AND COALESCE(ds.is_restaurant, 0) = 1
    AND COALESCE(ds.is_active, 0) = 1
    AND COALESCE(ds.is_test, 0) = 0
    AND COALESCE(dld.is_test, FALSE) = FALSE
),

store_order_volumes AS (
  SELECT
    provider_type,
    management_type,
    business_id,
    store_id,
    COUNT(DISTINCT order_id) AS orders_28d
  FROM orders_recent
  WHERE store_id IS NOT NULL
  GROUP BY 1,2,3,4
),

provider_mgmt_rollup AS (
  SELECT
    provider_type,
    management_type,
    COUNT(DISTINCT store_id)      AS stores_count,
    COUNT(DISTINCT business_id)   AS merchants_count,
    SUM(orders_28d)               AS orders_28d
  FROM store_order_volumes
  GROUP BY 1,2
)

SELECT
  provider_type,
  management_type,
  merchants_count,
  stores_count,
  orders_28d,
  ROUND(
    stores_count 
    / NULLIF(SUM(stores_count) OVER (PARTITION BY provider_type),0)::FLOAT,
    4
  ) AS pct_stores_of_provider,
  ROUND(
    orders_28d 
    / NULLIF(SUM(orders_28d) OVER (PARTITION BY provider_type),0)::FLOAT,
    4
  ) AS pct_orders_of_provider
FROM provider_mgmt_rollup
ORDER BY provider_type, pct_orders_of_provider DESC;
