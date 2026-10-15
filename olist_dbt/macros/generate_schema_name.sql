-- {# Use the custom schema name exactly (e.g. "staging", "marts") instead of
--    dbt's default of prefixing it with the target schema (staging_marts). #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}