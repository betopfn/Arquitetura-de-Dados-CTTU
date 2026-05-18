with fotossensores as (

    select

        'fotossensor' as tipo_equipamento,

        cast(equipamento as string) as equipamento,
        cast(faixa as string) as faixa,

        data_medicao,

        cast(hora as int64) as hora,
        cast(minutos_intervalo as int64) as minutos_intervalo,

        cast(total_veiculos as int64) as total_veiculos,

        faixa_velocidade,

        cast(quantidade as int64) as quantidade

    from {{ ref('int_fluxo_velocidade') }}

),

lombadas as (

    select

        'lombada' as tipo_equipamento,

        cast(equipamento as string) as equipamento,
        cast(faixa as string) as faixa,

        data_medicao,

        cast(hora as int64) as hora,
        cast(minutos_intervalo as int64) as minutos_intervalo,

        cast(total_veiculos as int64) as total_veiculos,

        faixa_velocidade,

        cast(quantidade as int64) as quantidade

    from {{ ref('int_lombadas_velocidade') }}

)

select *
from fotossensores

union all

select *
from lombadas