# Part One
## What is our repeat user rate?
### Answer: 79.8%
```
with orders_per_user as(

    select
        user_id,
        count(order_id) as ct_orders

    from stg_postgres__orders

    group by 1
),

repeat_users as(

    select 
        count(case when ct_orders = 1 then 1 end) as non_repeat_customers,
        count(case when ct_orders >= 2 then 1 end) as repeat_customers,
        div0(repeat_customers, count(*)) as repeat_customer_rate
    
    from orders_per_user
)

select * from repeat_users;

```

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
### Answer:
I would look at factors like:
- What products are they purchasing?
- Do they encounter any bugs/failures during their session?
- What's their NPS score?
- What are their demographics (e.g., income level, geography, etc)?

## Explain the product mart models you added. Why did you organize the models in the way you did?
### Answer:
The two example fct tables I created are `fct_product__daily_page_views` and `fct_product__daily_product_performance`. I wanted to be able to summarize, by product, which products are getting the most "hits" and how each product is selling. There are a number of analyses you can do with this information.

I created my fct tables as daily summaries, meaning one row per product per day. Because there could be multiple orders per product per day, and multiple page views per product per day, I leveraged the intermediate layer to capture the data at an order and page view grain.

My dag:
![image](https://github.com/user-attachments/assets/2c9427c1-7776-49f7-884e-37e818050667)


# Part Two
## What assumptions are you making about each model? (i.e. why are you adding each test?). Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
### Answer:
I used tests primarily to validate primary keys using `not_null` and `unique`. In stg/dim models, oftentimes each record is representing a unique thing (a customer, an order, a product, etc). Those tables should only have a single row per thing, and these tests check for that. 

As I was building out my int and fct tables, I realized that row id's were not unique in all cases which meant they couldn't be used as keys. To resolve the issue, I concatenated combinations of columns like product and date that should provide a unique key for a given daily entry.

I was having trouble implementing custom tests, so I'll explore that further. Different staging models have some implicit rules to apply. For example with order items, you would expect if an order item is listed that the quantity is > 0. For orders, you would expect that the created_at date is <= delivered_at date. 

# Part Three
## Which products had their inventory change from week 1 to week 2? 
### Answer: 
My snapshot table isn't building in Snowflake so need to investigate that.
