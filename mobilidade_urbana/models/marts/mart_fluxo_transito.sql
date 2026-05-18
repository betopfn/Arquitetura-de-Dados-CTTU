with fluxo as (

    select *
    from {{ ref('int_fluxo_transito') }}

),

tempo as (

    select *
    from {{ ref('dim_tempo') }}

)

select

    md5(

        concat(
            cast(fluxo.equipamento as string),
            cast(fluxo.data_medicao as string),
            cast(fluxo.hora as string),
            fluxo.faixa_velocidade,
            fluxo.tipo_equipamento
        )

    ) as id_fluxo,

    fluxo.tipo_equipamento,
    fluxo.equipamento,
    fluxo.faixa,

    fluxo.data_medicao,
    fluxo.hora,

    tempo.ano,
    tempo.mes,
    tempo.nome_mes,
    tempo.dia_semana,
    tempo.fim_de_semana,

    fluxo.faixa_velocidade,
    fluxo.quantidade,
    fluxo.total_veiculos

from fluxo

left join tempo
    on fluxo.data_medicao = tempo.data