-- Query to pull POS Proactive Cancels for Revel by Category
-- Adjust date range and filters as needed

WITH revel_stores AS (
    -- Identify Revel stores
    SELECT DISTINCT
        ds.store_id,
        ds.business_id,
        ds.business_name,
        ds.name AS store_name,
        ds.pos_provider
    FROM edw.merchant.dimension_store ds
    WHERE LOWER(ds.pos_provider) = 'revel'
        AND ds.nv_business_line IS NULL  -- Restaurant stores only
),

revel_orders AS (
    -- Get Revel orders
    SELECT DISTINCT
        dd.delivery_id,
        dd.order_cart_id,
        dd.business_id,
        dd.store_id,
        dd.active_date,
        dd.created_at,
        dd.cancelled_at,
        dd.creator_id AS consumer_id,
        rs.business_name,
        rs.store_name
    FROM proddb.public.dimension_deliveries dd
    INNER JOIN revel_stores rs
        ON dd.store_id = rs.store_id
    WHERE dd.active_date >= CURRENT_DATE - 30  -- Last 30 days, adjust as needed
        AND dd.is_filtered_core = TRUE
        AND dd.is_test = FALSE
        AND dd.cancelled_at IS NOT NULL  -- Only cancelled orders
),

-- Get cancellation reasons and categories
cancellation_details AS (
    SELECT 
        ro.*,
        cr.cancellation_event_name,
        cr.cancellation_reason_category,
        cr.reasons AS cancellation_reasons,
        cr.cxl_workflow_reason,
        -- Determine if it's a proactive cancel (POS-initiated)
        CASE 
            WHEN LOWER(cr.cancellation_reason_category) LIKE '%pos%' 
                OR LOWER(cr.cancellation_reason_category) LIKE '%merchant%'
                OR LOWER(cr.cxl_workflow_reason) LIKE '%pos%'
                OR LOWER(cr.cxl_workflow_reason) LIKE '%merchant%'
                OR LOWER(cr.cancellation_event_name) LIKE '%pos%'
                OR LOWER(cr.cancellation_event_name) LIKE '%merchant%'
            THEN 1 
            ELSE 0 
        END AS is_proactive_cancel
    FROM revel_orders ro
    LEFT JOIN proddb.public.dimension_cancellation_reasons cr
        ON ro.delivery_id = cr.delivery_id
),

-- Combine cancellation sources
combined_cancels AS (
    SELECT 
        cd.delivery_id,
        cd.order_cart_id,
        cd.business_id,
        cd.store_id,
        cd.business_name,
        cd.store_name,
        cd.active_date,
        cd.created_at,
        cd.cancelled_at,
        cd.cancellation_event_name,
        cd.cancellation_reason_category,
        cd.cxl_workflow_reason,
        cd.is_proactive_cancel,
        -- Get category from order items if available
        COALESCE(
            FIRST_VALUE(oi.menu_category_name) OVER (PARTITION BY cd.delivery_id ORDER BY oi.order_item_id),
            'Unknown'
        ) AS primary_category
    FROM cancellation_details cd
    LEFT JOIN edw.merchant.fact_merchant_order_items oi
        ON cd.delivery_id = oi.delivery_id
    WHERE cd.is_proactive_cancel = 1  -- Only proactive cancels
)

-- Final output: Proactive cancels by category
SELECT 
    active_date,
    business_id,
    business_name,
    store_id,
    store_name,
    primary_category AS category,
    cancellation_reason_category,
    cxl_workflow_reason,
    COUNT(DISTINCT delivery_id) AS proactive_cancel_deliveries,
    COUNT(DISTINCT order_cart_id) AS proactive_cancel_orders,
    COUNT(*) AS total_cancel_events,
    MIN(created_at) AS first_order_time,
    MAX(cancelled_at) AS last_cancel_time
FROM combined_cancels
GROUP BY 
    active_date,
    business_id,
    business_name,
    store_id,
    store_name,
    primary_category,
    cancellation_reason_category,
    cxl_workflow_reason
ORDER BY 
    active_date DESC,
    proactive_cancel_deliveries DESC;

-- Alternative: Summary by category only (simpler view)
/*
SELECT 
    primary_category AS category,
    cancellation_reason_category,
    COUNT(DISTINCT delivery_id) AS proactive_cancel_deliveries,
    COUNT(DISTINCT order_cart_id) AS proactive_cancel_orders,
    COUNT(DISTINCT business_id) AS affected_businesses,
    COUNT(DISTINCT store_id) AS affected_stores,
    MIN(active_date) AS first_occurrence,
    MAX(active_date) AS last_occurrence
FROM combined_cancels
GROUP BY 
    primary_category,
    cancellation_reason_category
ORDER BY proactive_cancel_deliveries DESC;
*/
