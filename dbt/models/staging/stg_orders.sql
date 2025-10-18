    SELECT
        id
        ,customer as customer_id
        ,ordered_at
        ,store_id
        ,subtotal
        ,tax_paid
        ,order_total
    FROM {{ source('raw', 'raw_orders') }}