with source as (

    select *
    from {{ source(
        'raw',
        'lombadas_2025_dezembro_quantitativo_das_vias_por_velocidade_media'
    ) }}

)

select

    equipamento,
    faixa,

    cast(data as date) as data_medicao,

    cast(hora as integer) as hora,

    cast(minutos_intervalo as integer) as minutos_intervalo,

    cast(qtd_0a10km as integer) as qtd_0_10_km,
    cast(qtd_11a20km as integer) as qtd_11_20_km,
    cast(qtd_21a30km as integer) as qtd_21_30_km,
    cast(qtd_31a40km as integer) as qtd_31_40_km,
    cast(qtd_41a50km as integer) as qtd_41_50_km,
    cast(qtd_51a60km as integer) as qtd_51_60_km,
    cast(qtd_61a70km as integer) as qtd_61_70_km,
    cast(qtd_71a80km as integer) as qtd_71_80_km,
    cast(qtd_81a90km as integer) as qtd_81_90_km,
    cast(qtd_91a100km as integer) as qtd_91_100_km,
    cast(qtd_acimade100km as integer) as qtd_acima_100_km,

    (

        cast(qtd_0a10km as integer) +
        cast(qtd_11a20km as integer) +
        cast(qtd_21a30km as integer) +
        cast(qtd_31a40km as integer) +
        cast(qtd_41a50km as integer) +
        cast(qtd_51a60km as integer) +
        cast(qtd_61a70km as integer) +
        cast(qtd_71a80km as integer) +
        cast(qtd_81a90km as integer) +
        cast(qtd_91a100km as integer) +
        cast(qtd_acimade100km as integer)

    ) as total_veiculos

from source