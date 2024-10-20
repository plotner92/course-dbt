select
    events.event_id,
    events.product_id,
    products.name as product_name,
    created_at as event_date

from {{ ref('stg_postgres__events') }} as events
left join {{ ref('stg_postgres__products') }} as products
    on events.product_id = products.product_id

where events.event_type = 'page_view'