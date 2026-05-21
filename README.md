# 🚦 Pipeline ELT — Mobilidade Urbana do Recife (CTTU)
 
> Pipeline de dados end-to-end sobre mobilidade urbana da cidade do Recife, utilizando dados abertos da CTTU, Google BigQuery e dbt.
 
---
 
## 📋 Visão Geral
 
Este projeto constrói um pipeline **ELT (Extract, Load, Transform)** completo com dados públicos de mobilidade urbana disponibilizados pela **CTTU (Autarquia de Trânsito e Transporte Urbano do Recife)**. O objetivo é centralizar, transformar e disponibilizar esses dados para análise e visualização em dashboard.
 
### Fluxo do Pipeline
 
```
Portal Dados Abertos (CTTU)
        ↓
   [api.py] Extração via Python
        ↓                        ← GitHub Actions (pipeline.yml)
   Google BigQuery (raw_cttu)       agenda execução diária às 3h
        ↓                           valida código com flake8
   dbt (Staging → Intermediate → Marts)
        ↓
   Dashboard (em desenvolvimento)
```
 
---
 
## 📂 Estrutura do Projeto
 
```
.
├── api.py                        # Script de extração e ingestão dos dados
├── dbt_project.yml               # Configuração do projeto dbt
├── models/
│   ├── staging/
│   │   ├── transito/             # Modelos de staging para dados de trânsito
│   │   ├── stg_fotossensores.sql # Staging de fotossensores
│   │   └── sources.yml           # Declaração das fontes raw
│   ├── intermediate/
│   │   ├── int_fluxo_transito.sql
│   │   ├── int_fluxo_velocidade.sql
│   │   └── int_lombadas_velocidade.sql
│   └── marts/
│       ├── dim_tempo.sql
│       └── mart_fluxo_transito.sql
├── powerbi/                      # Arquivos do Dashboard em Power BI
│   ├── dashboard_cttu.Report/    # Front-end (Visuais e Páginas)
│   ├── dashboard_cttu.SemanticModel/ # Back-end (Dados e DAX)
│   └── dashboard_cttu.pbip       # Arquivo de Projeto Power BI
├── analyses/
├── macros/
├── seeds/
├── snapshots/
├── tests/
├── .github/
│   ├── workflows/
│   │   └── pipeline.yml          # CI/CD: execução agendada + validação de PRs
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md         # Template para reporte de bugs
│       ├── feature_request.md    # Template para sugestão de features
│       └── config.yml            # Configuração dos templates
│   └── PULL_REQUEST_TEMPLATE.md  # Template padrão para Pull Requests
└── README.md
```
 
---
 
## 🗄️ Datasets no BigQuery
 
### `raw_cttu` — Dados Brutos
 
| Tabela | Descrição |
|--------|-----------|
| `fotossensores_2025_dezembro_quantitativo_das_vias_por_velocidade_media` | Dados de fotossensores com velocidade média por via |
| `lombadas_2025_dezembro_quantitativo_das_vias_por_velocidade_media` | Velocidade média nas vias com lombadas |
| `metadados_fluxo_de_veiculo_por_hora` | Metadados de fluxo veicular por hora |
| `registro_das_infracoes_de_transito_2025` | Registro de infrações de trânsito em 2025 |
| `registro_de_chamados_atendidos_pela_cttu_2015` | Chamados atendidos pela CTTU desde 2015 |
| `semaforos_do_recife` | Cadastro de semáforos da cidade |
 
### `analytics` — Dados Transformados (dbt)
 
| Camada | Tabelas |
|--------|---------|
| **Staging** | `stg_fotossensores`, tabelas de trânsito |
| **Intermediate** | `int_fluxo_transito`, `int_fluxo_velocidade`, `int_lombadas_velocidade` |
| **Marts** | `dim_tempo`, `mart_fluxo_transito` |
 
---
 
## 🛠️ Tecnologias Utilizadas
 
| Tecnologia | Função |
|------------|--------|
| **Python** | Extração dos dados via API e ingestão no BigQuery |
| **Google BigQuery** | Data warehouse em nuvem |
| **dbt (Data Build Tool)** | Transformação e modelagem dos dados |
| **GitHub Actions** | CI/CD — agendamento, validação e execução automatizada |
| **Power BI** | Visualização dos dados |
 
---
 
## ⚙️ Como Reproduzir
 
### Pré-requisitos
 
- Python 3.8+
- Conta no Google Cloud com acesso ao BigQuery
- dbt instalado (`pip install dbt-bigquery`)
- Credenciais GCP configuradas
### 1. Extração e Carga (EL)
 
```bash
# Instale as dependências
pip install -r requirements.txt
 
# Execute o script de ingestão
python api.py
```
 
O script `api.py` realiza:
1. Requisições aos endpoints de dados abertos da CTTU
2. Tratamento básico dos dados
3. Ingestão direta no dataset `raw_cttu` no BigQuery
### 2. Transformação (T)
 
```bash
# Configure o perfil dbt para o BigQuery
dbt debug
 
# Execute os modelos
dbt run
 
# Execute os testes
dbt test
```
 
### 3. Documentação dbt
 
```bash
dbt docs generate
dbt docs serve
```
 
---
 
## 🤖 CI/CD com GitHub Actions
 
O arquivo `.github/workflows/pipeline.yml` automatiza a execução e validação do pipeline.
 
### Gatilhos
 
| Evento | Detalhe |
|--------|---------|
| **Agendamento** | Todo dia às **3h da manhã** (cron: `0 3 * * *`) |
| **Pull Request** | A cada PR aberto contra `main` ou `development` |
 
### Etapas do Workflow
 
```
1. Checkout do repositório
        ↓
2. Setup Python 3.10
        ↓
3. Instala dependências (requests, google-cloud-bigquery, flake8)
        ↓
4. Lint com flake8 (máx. 120 chars por linha)
        ↓
5. Cria chave GCP temporária → roda api.py
        ↓
6. Remove chave temporária (sempre, mesmo em falha)
```
 
### Segredos Necessários
 
Configure o seguinte secret no repositório em **Settings → Secrets → Actions**:
 
| Secret | Descrição |
|--------|-----------|
| `GCP_CREDENTIALS` | JSON completo da Service Account do Google Cloud |
 
> ⚠️ A chave é criada em arquivo temporário apenas durante a execução e removida ao final — inclusive se o pipeline falhar (`if: always()`).
 
### Templates de Colaboração
 
O projeto conta com templates padronizados para contribuição:
 
- **Bug Report** — `.github/ISSUE_TEMPLATE/bug_report.md`
- **Feature Request** — `.github/ISSUE_TEMPLATE/feature_request.md`
- **Pull Request** — `.github/PULL_REQUEST_TEMPLATE.md`
---
 
## 📊 Dashboard
 
O dashboard foi desenvolvido no Power BI utilizando o formato .pbip (Power BI Project), permitindo o versionamento eficiente de código no Git. O painel consome diretamente os marts gerados pelo dbt (dim_tempo e mart_fluxo_transito) para fornecer insights estratégicos sobre a mobilidade urbana.

O relatório está estruturado em 3 páginas analíticas focadas em tomada de decisão:

Visão Geral: KPIs de volume total de tráfego, média diária e proporção geral de infrações. Apresenta tendências temporais e o ranking geral dos equipamentos mais acionados.

Comportamento e Risco: Foco em segurança viária. Destaca um mapa de calor com os horários e dias críticos de trânsito (picos urbanos) e uma matriz de eficiência comparando o comportamento dos motoristas em Lombadas Eletrônicas versus Fotossensores.

Ranking de Criticidade (Plano de Ação): Ferramenta prescritiva com uma Matriz de Risco (Gráfico de Dispersão) que cruza Volume de Tráfego vs. Taxa de Infração, isolando os equipamentos críticos que demandam fiscalização imediata, acompanhado de uma tabela de detalhamento gerencial.
 
---
 
## 🌐 Fontes de Dados
 
Os dados são provenientes do **Portal de Dados Abertos da Prefeitura do Recife**:
 
- [dados.recife.pe.gov.br](https://dados.recife.pe.gov.br)
- Categoria: Mobilidade Urbana / CTTU
---
 
## 👥 Contribuidores
 
| Papel | Responsabilidade |
|-------|-----------------|
| Engenharia de Dados | Extração, API Python e ingestão no BigQuery |
| Transformação | Modelagem dbt (Staging, Intermediate, Marts) |
| Visualização | Desenvolvimento de Dashboard e DAX (Power BI) |
 
---
 
## 📄 Licença
 
Os dados utilizados são públicos e disponibilizados sob a política de dados abertos da Prefeitura do Recife. Consulte os termos de uso no portal oficial.
