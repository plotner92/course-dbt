with products as (

    select 
        product_id,
        name as product_name,
        price as product_price
    
    from {{ ref('stg_postgres__products') }}
),

order_items as (

    select 
        product_id,
        order_id,
        quantity as sold_quantity
    
    from {{ ref('stg_postgres__order_items') }}
),

orders as (

    select 
        order_id,
        date(created_at) as order_date
    
    from {{ ref('stg_postgres__orders') }}
)

select
    md5(order_items.product_id || order_items.order_id) as _key,
    order_items.product_id,
    order_items.order_id,
    products.product_name,
    orders.order_date,
    sum(order_items.sold_quantity) as sold_quantity,
    sum(order_items.sold_quantity) * products.product_price as sold_revenue_excl_promos

from order_items
left join products
    on order_items.product_id = products.product_id
left join orders
    on order_items.order_id = orders.order_id

group by 1, 2, 3, 4, 5, products.product_price