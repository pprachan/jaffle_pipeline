-- select 
--     o.order_id
--     ,o.customer_id
--     ,c.first_name
--     ,c.last_name
-- from {{ ref('stg_customers') }} as c
-- join {{ ref('stg_orders') }} o on o.customer_id = c.customer_id


----
with 

-- customers as (

--     select
--         id as customer_id,
--         name
--     from jaffle_shop.raw.raw_customers

-- ),

-- orders as (

--     select
--         id as order_id,
--         customer as customer_id,
--         ordered_at
--     from jaffle_shop.raw.raw_orders

-- ),

customer_orders as (

    select
        customer_id,
        min(ordered_at) as first_order_date,
        max(ordered_at) as most_recent_order_date,
        count(id) as number_of_orders
    from {{ ref('stg_orders') }}
    group by 1

),
customers as (

    select
        c.id,
        c.first_name,
        c.last_name,
        co.first_order_date,
        co.most_recent_order_date,
        coalesce(co.number_of_orders, 0) as number_of_orders
    from {{ ref('stg_customers') }} as c
    left join customer_orders as co on co.customer_id = c.id 

)

select * from customers