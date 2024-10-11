with addresses as (

    select * from {{ source('postgres', 'addresses') }}
)

select
    address
    , address_id
    , country
    , state
    , zipcode

from addresses