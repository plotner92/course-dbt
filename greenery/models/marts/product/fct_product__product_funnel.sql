with funnel_numbers as (
    select
        count(*) as total_sessions,
        sum(iff(ct_page_views > 0, 1, 0)) as sessions_with_page_view,
        sum(iff(ct_add_to_carts > 0, 1, 0)) as sessions_with_add_to_cart,
        sum(iff(ct_checkouts > 0, 1, 0)) as sessions_with_checkout
    
    from {{ ref('int_product__unique_sessions') }}
)

select
    *,
    sessions_with_add_to_cart / total_sessions as add_to_cart_rate,
    sessions_with_checkout / total_sessions as checkout_rate

from funnel_numbers