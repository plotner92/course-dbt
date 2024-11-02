# Part One
To answer these questions, I created three new models:
- `int_product__unique_sessions`
- `fct_product__total_conversion_rate`
- `fct_product__conversion_rate_by_product`

## What is our overall conversion rate?
### Answer: 62.5% 
```
select 
    sum(case when ct_checkouts >= 1 then 1 end) as unique_sessions_with_checkout,
    count(*) as total_unique_sessions,
    div0(unique_sessions_with_checkout, total_unique_sessions) as conversion_rate

from fct_product__unique_sessions
;
```

## What is our conversion rate by product?
### Answer: Avg. conversion rate = 77.5%
```
select avg(conversion_rate) from fct_product__conversion_rate_by_product
;

--To see conversion rate by product:
select * from fct_product__conversion_rate_by_product
;
```

# Part Two: Macros
I created a macro to return the latest record from any table that holds timestamped records:
```
{% macro get_latest_record(entity_id_column, timestamp_column) %}
   
    row_number() over (
        partition by {{ entity_id_column }}
        order by {{ timestamp_column }} desc
    ) = 1

{% endmacro %}
```

I used the macro in a new model `fct_product__latest_page_view.sql`
```
with page_views as (
    
    select * from {{ ref('fct_product__daily_page_views') }}
)

select *

from page_views

-- The ROW_NUMBER() window function in the QUALIFY clause filters for the latest record
qualify {{ get_latest_record('product_name', 'date') }}
```

Probably not good practice to build my fct table from a fct table. I should probably update it to build from stg and int eventually.

# Part Three: Hooks
I added the `grant` macro and added the post-hook to my dbt project yml. The grants ran in snowflake.

# Part Four: Packages
I installed `dbt_utils` and leveraged the `unique_combination_of_columns` macro as a pseudo-primary key test in my `_product.yml`:
```
  - name: fct_product__daily_page_views
    description: Daily page views by product
    data_tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
            - product_name
            - date

  - name: fct_product__daily_product_performance
    description: Daily order summary statistics by product
    data_tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
            - product_name
            - order_date
```

I had originally created my own primary key fields using concatenation, but this macro enabled me to remove those fields and test for uniqueness via combination of columns.

# Part Five: DAG
![image](https://github.com/user-attachments/assets/7d82e0ac-87b6-4a06-80db-c9124d21186f)

My DAG hasn't changed much, but as mentioned above I was able to simplify some of my models with macros and packages. You can also see in the DAG that I have a fct table that's child to another fct table, which I should clean up in the future so that fct tables are all in the same layer and their parents are either stg or int.
