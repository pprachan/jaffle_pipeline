with customer_orders as (

    select
        customer_id,
        min(ordered_at) as first_order_date,
        max(ordered_at) as most_recent_order_date,
        sum(order_total) as lifetime_value, 
        count(order_id) as number_of_orders
    from {{ ref('stg_orders') }}
    group by 1

),
customers as (

    select
        c.customer_id,
        c.first_name,
        c.last_name,
        co.first_order_date,
        co.most_recent_order_date,
        coalesce(co.lifetime_value,0) as lifetime_value,
        coalesce(co.number_of_orders, 0) as number_of_orders
    from {{ ref('stg_customers') }} as c
    left join customer_orders as co USING(customer_id)

)

select * from customers