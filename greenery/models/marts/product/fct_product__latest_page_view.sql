with page_views as (
    
    select * from {{ ref('fct_product__daily_page_views') }}
)

select *

from page_views

-- The ROW_NUMBER() window function in the QUALIFY clause filters for the latest record
qualify {{ get_latest_record('product_name', 'date') }}
