-- Query to pull POS Errors for Olo
-- Adjust date range, business/store filters, and error criteria as needed

WITH olo_orders AS (
    -- Identify Olo orders - adjust business_id/store_id filter based on your data
    SELECT DISTINCT
        dd.delivery_id,
        dd.order_id,
        dd.order_cart_id,
        dd.business_id,
        dd.store_id,
        dd.active_date,
        dd.consumer_id
    FROM proddb.public.dimension_deliveries dd
    -- TODO: Add filter to identify Olo stores/businesses
    -- Option 1: Filter by business_id if you know Olo business IDs
    -- WHERE dd.business_id IN (12345, 67890)  -- Replace with actual Olo business IDs
    
    -- Option 2: Filter by business group if Olo has a business group
    -- INNER JOIN edw.merchant.dimension_business_group_link dbgl 
    --     ON dd.business_id = dbgl.business_id
    -- WHERE dbgl.business_group_id = XXX  -- Replace with Olo business group ID
    
    -- Option 3: Filter by store properties if Olo stores have specific tags
    -- INNER JOIN edw.merchant.dimension_store_properties dsp
    --     ON dd.store_id = dsp.store_id
    -- WHERE dsp.pos_system = 'olo'  -- Adjust column name as needed
    
    WHERE dd.active_date >= CURRENT_DATE - 30  -- Last 30 days, adjust as needed
        AND dd.is_filtered_core = TRUE
        AND dd.is_test = FALSE
        AND dd.country_id = 1  -- US, adjust if needed
),

-- Option A: Check order lifecycle events for POS errors
order_lifecycle_errors AS (
    SELECT 
        oo.delivery_id,
        oo.order_id,
        oo.order_cart_id,
        oo.business_id,
        oo.store_id,
        oo.active_date,
        olc.event_type,
        olc.order_operation_code,
        olc.event_status,
        olc.error_message,
        olc.error_code,
        olc.iguazu_sent_at,
        olc.order_uuid
    FROM order_data.public.flink_ingest_order_lifecycle olc
    INNER JOIN olo_orders oo 
        ON olc.order_uuid = oo.order_cart_id
    WHERE olc.iguazu_sent_at >= CURRENT_DATE - 30
        -- Filter for error events - adjust based on actual error indicators
        AND (
            olc.event_status = 'FAIL'
            OR olc.event_status = 'ERROR'
            OR olc.error_message IS NOT NULL
            OR LOWER(olc.error_message) LIKE '%pos%'
            OR LOWER(olc.error_message) LIKE '%olo%'
            OR LOWER(olc.error_message) LIKE '%integration%'
        )
),

-- Option B: Check Iguazu events for POS/checkout errors
iguazu_pos_errors AS (
    SELECT 
        oo.delivery_id,
        oo.order_id,
        oo.order_cart_id,
        oo.business_id,
        oo.store_id,
        oo.active_date,
        ev.event_group,
        ev.event_name,
        ev.event_status,
        ev.iguazu_custom_attributes,
        ev.iguazu_sent_at,
        ev.delivery_uuid
    FROM iguazu.server_events_production.cng_tracking_retail_lifecycle_event ev
    INNER JOIN olo_orders oo 
        ON ev.delivery_uuid = oo.delivery_id
    WHERE ev.iguazu_sent_at >= CURRENT_DATE - 30
        AND (
            ev.event_status = 'FAIL'
            OR ev.event_status = 'ERROR'
            OR (ev.event_group = 'CHECKOUT_LIFECYCLE' AND ev.event_status != 'SUCCESS')
            OR (ev.event_name LIKE '%POS%' OR ev.event_name LIKE '%OLO%')
        )
),

-- Combine results
combined_errors AS (
    SELECT 
        'order_lifecycle' AS error_source,
        delivery_id,
        order_id,
        order_cart_id,
        business_id,
        store_id,
        active_date,
        event_type,
        order_operation_code AS event_detail,
        event_status,
        error_message,
        error_code,
        iguazu_sent_at AS error_timestamp
    FROM order_lifecycle_errors
    
    UNION ALL
    
    SELECT 
        'iguazu_event' AS error_source,
        delivery_id,
        order_id,
        order_cart_id,
        business_id,
        store_id,
        active_date,
        event_group AS event_type,
        event_name AS event_detail,
        event_status,
        iguazu_custom_attributes['error']::STRING AS error_message,
        iguazu_custom_attributes['error_code']::STRING AS error_code,
        iguazu_sent_at AS error_timestamp
    FROM iguazu_pos_errors
)

-- Final output
SELECT 
    error_source,
    active_date,
    business_id,
    store_id,
    COUNT(DISTINCT delivery_id) AS error_deliveries,
    COUNT(DISTINCT order_id) AS error_orders,
    COUNT(*) AS total_errors,
    event_status,
    event_type,
    event_detail,
    error_code,
    error_message,
    MIN(error_timestamp) AS first_error_time,
    MAX(error_timestamp) AS last_error_time
FROM combined_errors
GROUP BY 
    error_source,
    active_date,
    business_id,
    store_id,
    event_status,
    event_type,
    event_detail,
    error_code,
    error_message
ORDER BY 
    active_date DESC,
    error_deliveries DESC;

-- Alternative: Detailed view of individual errors
-- Uncomment to see individual error records instead of aggregated view
/*
SELECT 
    ce.*,
    dd.consumer_id,
    dd.store_name,
    dd.business_name
FROM combined_errors ce
LEFT JOIN proddb.public.dimension_deliveries dd
    ON ce.delivery_id = dd.delivery_id
ORDER BY ce.error_timestamp DESC
LIMIT 1000;
*/
