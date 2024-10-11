{% snapshot inventory_snapshot %}

{{
  config(
    target_database = 'dev_db',
    target_schema = 'dev_ianplotnergmailcom',
    strategy='check',
    unique_key='product_id',
    check_cols=['inventory'],
   )
}}

select * from {{ source('postgres', 'products') }}

{% endsnapshot %}