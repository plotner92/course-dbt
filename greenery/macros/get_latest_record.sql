{% macro get_latest_record(entity_id_column, timestamp_column) %}
   
    row_number() over (
        partition by {{ entity_id_column }}
        order by {{ timestamp_column }} desc
    ) = 1

{% endmacro %}
