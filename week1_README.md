# Week 1 Answers

## How many users do we have?
### 130
```
select count(distinct user_id) from stg_postgres__users;
```

## On average, how many orders do we receive per hour?
### 7.5
```
--on average, how many orders do we receive per hour? 7.5
with orders_per_hour as(

    select 
        date(created_at) || '-' || hour(created_at) as created_date_hour, 
        count(order_id) as ct_orders
        
    from stg_postgres__orders 
    
    group by 1
)

select avg(ct_orders) as avg_orders_per_hour from orders_per_hour;
```

## On average, how long does an order take from being placed to being delivered?
### 3.9 days
```
--on average, how long does an order take from being placed to being delivered? 3.9 days
with days_to_deliver as(

    select
        timestampdiff(day, created_at, delivered_at) as days_to_deliver

    from stg_postgres__orders
)

select avg(days_to_deliver) as avg_days_to_deliver from days_to_deliver;
```

## How many users have only made one purchase? Two purchases? Three+ purchases?
### 1 order: 25
### 2 orders: 28
### 3 orders: 71
```
--how many users have only made one purchase? two purchases? three+ purchases? 25; 28; 71
with orders_per_user as(

    select
        user_id,
        count(order_id) as ct_orders

    from stg_postgres__orders

    group by 1
)

select 
    case 
        when ct_orders = 1 then '1 order'
        when ct_orders = 2 then '2 orders'
        when ct_orders >= 3 then '3+ orders'
    end as order_category,
    count(user_id) as user_count

from orders_per_user

group by 1

order by order_category;
```

## On average, how many unique sessions do we have per hour?
### 11.8
```
--on average, how many unique sessions do we have per hour? 11.8
with sessions as (

    select
        distinct session_id,
        min(created_at) as session_start

    from stg_postgres__events

    group by 1
),

sessions_per_hour as (

    select
        date(session_start) || '-' || hour(session_start),
        count(session_id) as ct_sessions

    from sessions

    group by 1
)

select avg(ct_sessions) as avg_sessions_per_hour from sessions_per_hour;
```
