{{ config(materialized='table') }}


with datas as (

    select distinct
        data_medicao as data
    from {{ ref('int_fluxo_transito') }}

)

select

    data,

    extract(year from data) as ano,
    extract(month from data) as mes,
    extract(day from data) as dia,

    case extract(month from data)

        when 1 then 'Janeiro'
        when 2 then 'Fevereiro'
        when 3 then 'Março'
        when 4 then 'Abril'
        when 5 then 'Maio'
        when 6 then 'Junho'
        when 7 then 'Julho'
        when 8 then 'Agosto'
        when 9 then 'Setembro'
        when 10 then 'Outubro'
        when 11 then 'Novembro'
        when 12 then 'Dezembro'

    end as nome_mes,

    extract(dayofweek from data) as dia_semana,

    case
        when extract(dayofweek from data) in (1, 7)
        then true
        else false
    end as fim_de_semana

from datas