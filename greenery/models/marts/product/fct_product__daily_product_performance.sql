select
    md5(product_name || order_date) as _key,
    product_name,
    order_date,
    count(*) as count_of_orders,
    sum(sold_quantity) as sold_quantity,
    sum(sold_revenue_excl_promos) as sold_revenue_excl_promos
    

from {{ ref('int_product__product_performance') }}

group by 1, 2, 3