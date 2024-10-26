with events as (

    select * from {{ ref('stg_postgres__events') }}
)

select 
    session_id,
    sum(case when event_type = 'page_view' then 1 end) as ct_page_views,
    sum(case when event_type = 'add_to_cart' then 1 end) as ct_add_to_carts,
    sum(case when event_type = 'checkout' then 1 end) as ct_checkouts,
    sum(case when event_type = 'package_shipped' then 1 end) as ct_package_shippeds

from events

group by session_id