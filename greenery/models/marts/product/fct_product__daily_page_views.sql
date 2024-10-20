select 
    md5(product_name || date(event_date)) as _key,
    product_name,
    date(event_date) as date,
    count(*) as count_of_page_views
    
from {{ ref('int_product__page_views') }}

group by 1, 2, 3