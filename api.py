import requests

links: {
    "https://dados.recife.pe.gov.br/dataset/305b21b8-e1e0-4b8d-bdc6-62b4f8c58b70/resource/81629a21-09cd-40d2-9ce0-f88f804f8215/download/dicionario-de-dados-do-registro-de-chamados.json",
    "https://dados.recife.pe.gov.br/dataset/fbe0c549-cd14-4146-886c-38bc0859cd2f/resource/63141148-d71a-4de6-a4a8-282f205c1e8f/download/dicionario-de-dados-das-infracoes-de-transito.json",
    "https://dados.recife.pe.gov.br/dataset/d7d21a36-7d16-4d37-8580-82bc78b79815/resource/7f62be15-aff2-4348-9793-1433f9b0e59e/download/dicionario-de-dados-velocidade-das-vias.json",
    "https://dados.recife.pe.gov.br/dataset/289c2371-31f4-49ed-9226-059de68d2bae/resource/195dd8e0-a78e-436b-a862-b057834b9884/download/dicionario-de-dados-dos-semaforos.json",#Semáforos
    "https://dados.recife.pe.gov.br/dataset/289c2371-31f4-49ed-9226-059de68d2bae/resource/b9c9a3f6-de71-499e-94a5-4b8818a0f584/download/dicionario-de-dados-dos-semaforos-equipados-para-deficientes-visuais.json",#Semáforos para deficientes
    "https://dados.recife.pe.gov.br/dataset/efb69ead-5989-41fc-9399-efa9e7ad4cef/resource/5841b996-92a4-494a-b845-6977fc7466f0/download/metadados-fluxo-de-veiculo-por-hora.json"
}


# 2. O 'for' vai  passar por cada link da lista, um por vez
for url in links_recife:
    print(f"Buscando dados em: {url}")
    
    try:
        resposta = requests.get(url)

        if resposta.status_code == 200:
            dados = resposta.json()
            
            # O CKAN sempre devolve o conteúdo principal 
            # dentro de uma chave chamada "result"
            resultado = dados.get('result', [])
            
            print(f"✅ Sucesso! A API retornou {len(resultado)} itens.")
            print("-" * 40) # Uma linha para separar visualmente os resultados
            
        else:
            print(f"❌ Erro na requisição. Código: {resposta.status_code}")
            print("-" * 40)

    except requests.exceptions.RequestException as e:
        print(f"⚠️ Ocorreu um erro de conexão: {e}")
        print("-" * 40)