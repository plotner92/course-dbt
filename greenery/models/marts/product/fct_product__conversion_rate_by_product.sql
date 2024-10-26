with events as (

    select * from {{ ref('stg_postgres__events') }}
),

sessions as (

    select * from {{ ref('int_product__unique_sessions') }}
)

select
    events.product_id,
    count(distinct events.session_id) as total_unique_sessions,
    count(distinct case when sessions.ct_checkouts >= 1 then events.session_id end) as unique_sessions_with_checkout,
    div0(unique_sessions_with_checkout, total_unique_sessions) as conversion_rate

from events
left join sessions
    on events.session_id = sessions.session_id

where events.product_id is not null

group by events.product_id