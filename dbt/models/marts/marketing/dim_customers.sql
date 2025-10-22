with orders_customers as (

    select
        o.customer_id,
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date,
        sum(p.amount) as lifetime_value, 
        count(o.order_id) as number_of_orders
    from {{ ref('stg_orders') }} as o
    left join {{ ref ('stg_payments')}} as p 
        on p.order_id = o.order_id
    group by 1

),
customers as (

    select
        c.customer_id,
        c.first_name,
        c.last_name,
        oc.first_order_date,
        oc.last_order_date,
        coalesce(oc.lifetime_value,0) as lifetime_value,
        coalesce(oc.number_of_orders, 0) as number_of_orders
    from {{ ref('stg_customers') }} as c
    left join orders_customers as oc USING(customer_id)

)

select * from customers