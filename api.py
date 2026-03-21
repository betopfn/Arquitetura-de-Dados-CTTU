import os
import requests
from google.cloud import bigquery
from dotenv import load_dotenv

load_dotenv()

# Conecta no BigQuery UMA ÚNICA VEZ antes de começar o trabalho
client = bigquery.Client()
# Lista dos URL's
links_recife = [
    "https://dados.recife.pe.gov.br/dataset/305b21b8-e1e0-4b8d-bdc6-62b4f8c58b70/resource/81629a21-09cd-40d2-9ce0-f88f804f8215/download/dicionario-de-dados-do-registro-de-chamados.json",
    "https://dados.recife.pe.gov.br/dataset/fbe0c549-cd14-4146-886c-38bc0859cd2f/resource/63141148-d71a-4de6-a4a8-282f205c1e8f/download/dicionario-de-dados-das-infracoes-de-transito.json",
    "https://dados.recife.pe.gov.br/dataset/d7d21a36-7d16-4d37-8580-82bc78b79815/resource/7f62be15-aff2-4348-9793-1433f9b0e59e/download/dicionario-de-dados-velocidade-das-vias.json",
    "https://dados.recife.pe.gov.br/dataset/289c2371-31f4-49ed-9226-059de68d2bae/resource/195dd8e0-a78e-436b-a862-b057834b9884/download/dicionario-de-dados-dos-semaforos.json",#Semáforos
    "https://dados.recife.pe.gov.br/dataset/289c2371-31f4-49ed-9226-059de68d2bae/resource/b9c9a3f6-de71-499e-94a5-4b8818a0f584/download/dicionario-de-dados-dos-semaforos-equipados-para-deficientes-visuais.json",#Semáforos para deficientes
    "https://dados.recife.pe.gov.br/dataset/efb69ead-5989-41fc-9399-efa9e7ad4cef/resource/5841b996-92a4-494a-b845-6977fc7466f0/download/metadados-fluxo-de-veiculo-por-hora.json"
]


# O Loop de Extração e Carga
for url in links_recife:
    # Pegamos o final do link para usar como nome da tabela (limpando traços e .json)
    nome_tabela_dinamica = url.split('/')[-1].replace('.json', '').replace('-', '_')
    
    print(f"\n🔍 Buscando dados em: {nome_tabela_dinamica}")
    
    try:
        # --- PASSO A: EXTRAÇÃO (Extract) ---
        resposta = requests.get(url)

        if resposta.status_code == 200:
            dados = resposta.json()
            
            
            # Se vier um dicionário solto, colocamos numa lista.
            dados_para_enviar = [dados] if isinstance(dados, dict) else dados
            
            print(f"✅ Download concluído! Preparando para enviar {len(dados_para_enviar)} itens...")

            # --- PASSO B: CARGA (Load) ---
            # Montamos o nome da tabela no padrão: projeto.dataset.tabela
            table_id = f"projeto-dados-cttu.raw_cttu.{nome_tabela_dinamica}"
            
            # Pede pro BigQuery descobrir as colunas sozinho (autodetect)
            # e substitui a tabela se ela já existir (WRITE_TRUNCATE) para não duplicar dados.
            job_config = bigquery.LoadJobConfig(
                autodetect=True,
                write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE
            )

            # Enviamos a variável com os dados em JSON.
            job = client.load_table_from_json(dados_para_enviar, table_id, job_config=job_config)
            
            # Espera o Google BigQuery processar e responder
            job.result()
            
            print(f"🚀 Sucesso! Foram carregadas {job.output_rows} linhas na tabela: {nome_tabela_dinamica}")
            
        else:
            print(f"❌ Erro na requisição. Código: {resposta.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"⚠️ Erro de conexão com a API: {e}")
    except Exception as e:
        print(f"⚠️ Erro ao enviar para o BigQuery: {e}")

print("\n🎉 Processo finalizado com sucesso!")