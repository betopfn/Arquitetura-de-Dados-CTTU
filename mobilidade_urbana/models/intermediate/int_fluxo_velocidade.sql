with fotossensores as (

    select *
    from {{ ref('stg_fotossensores') }}

),

velocidades as (

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '0-10 km/h' as faixa_velocidade,
        qtd_0_10_km as quantidade

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '11-20 km/h',
        qtd_11_20_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '21-30 km/h',
        qtd_21_30_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '31-40 km/h',
        qtd_31_40_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '41-50 km/h',
        qtd_41_50_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '51-60 km/h',
        qtd_51_60_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '61-70 km/h',
        qtd_61_70_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '71-80 km/h',
        qtd_71_80_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '81-90 km/h',
        qtd_81_90_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        '91-100 km/h',
        qtd_91_100_km

    from fotossensores

    union all

    select
        equipamento,
        faixa,
        data_medicao,
        hora,
        minutos_intervalo,
        total_veiculos,

        'Acima de 100 km/h',
        qtd_acima_100_km

    from fotossensores

)

select *
from velocidades
where quantidade > 0