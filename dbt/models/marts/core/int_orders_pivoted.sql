with 
completed as (
    select
        p.order_id
        ,p.payment_method
        ,p.amount
    from {{ref('stg_payments')}} as p 
    left join {{ref('stg_orders')}} as o using (order_id)
    where status ='completed'
),
pivoted as (
    select
        order_id,
        {%- set payment_method = ['bank_transfer','credit_card','coupon','gift_card'] -%}
        {% for payment in payment_method %}
            sum(case when payment_method = '{{payment}}' then amount else 0 end) as {{payment}}_amount
            {%- if not loop.last -%}
                ,
            {%- endif -%}
        {% endfor %}
    from completed
    group by 1
)
select 
    *
from pivoted