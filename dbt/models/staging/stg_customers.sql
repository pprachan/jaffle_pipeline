SELECT
    id as customer_id
    ,split_part(name,' ',1) as first_name
    ,split_part(name,' ',2) as last_name
FROM {{ source('jaffle_shop', 'raw_customers') }}