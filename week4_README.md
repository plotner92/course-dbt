# Product funnel
Link to model: [product_funnel](https://github.com/plotner92/course-dbt/blob/dbt-project-setup/greenery/models/marts/product/fct_product__product_funnel.sql)  
Link to yaml exposure: [_product.yml](https://github.com/plotner92/course-dbt/blob/dbt-project-setup/greenery/models/marts/product/_product.yml)

## How are our users moving through the product funnel?
### Answer:
| Funnel Step    | Count of Sessions | Conversion Rate |
|----------------|-------------------|-----------------|
| Total Sessions | 578               | -               |
| Page Views     | 578               | 100%            |
| Add to carts   | 467               | 81%             |
| Checkouts      | 361               | 62%             |

## Which steps in the funnel have largest drop off points?
### Answer:
'Add to carts' sees a 19% drop from total sessions. 'Checkouts' sees another 19% drop from 'Add to carts'.  
I would encourage engineering/product to focus on the checkout UX to try an convert more of the Add to carts to purchases.

# Reflection
## If your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?
My organization does use dbt. It is fairly well structured, including keeping a clean dag, leveraging exposures to document which models are dependencies in downstream Power BI models.  
One thing I will encourage is to build more macros. For example, we have some fairly complex "weekend exclusion" logic that accounts for different regions of the world considering different days as "weekend".  
Right now, we embed the logic in any model that needs to exclude weekends, say from KPI measures. This would be a prime candidate for creating a macro that can be easily reused across models.
