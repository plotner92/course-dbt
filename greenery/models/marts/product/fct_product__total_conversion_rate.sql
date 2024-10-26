select 
    sum(case when ct_checkouts >= 1 then 1 end) as unique_sessions_with_checkout,
    count(*) as total_unique_sessions,
    div0(unique_sessions_with_checkout, total_unique_sessions) as conversion_rate

from {{ ref('int_product__unique_sessions') }}