# Projeto Final – triggo.ai | DataSUS + Snowflake + dbt

## Contexto e Objetivo
Este projeto visa construir uma pipeline completa para ingestão, transformação e modelagem dos dados públicos do DataSUS (Sistema Único de Saúde), com foco na otimização da análise em saúde pública.  
A solução utiliza Snowflake como data warehouse e dbt para a camada de transformação, organizando dados para análise e geração de insights estratégicos.

## Dados Utilizados
- Fonte: DataSUS – Autorizações de Internação Hospitalar (AIH)  
- Arquivos originais: Formato `.dbc` (compactado)  
- Período: Últimos anos disponíveis no portal oficial  
- Link oficial dos dados: [ftp.datasus.gov.br](ftp://ftp.datasus.gov.br/dissemin/publicos/SIHSUS/200801_/Dados/)

## 📁 Estrutura do Repositório
```
ProjetoFinal_triggo/
│
├── data/
│   ├── raw/
│   └── converted/
│
├── scripts/
│   ├── extract/
│   │   └── 1_convert_dbc_to_csv.py
│   ├── load/
│   └── transform/
│
├── sql/
|   ├── 01_create_warehouse_db_schema.sql
│   └── 02_create_and_populate_raw_table.sql
│
├── dbt/
│
├── docs/
│
├── .gitignore
└── README.md
```

## Passo a Passo Realizado

### 1. Ingestão e Preparação dos Dados
- Criado warehouse, database e schema dedicados no Snowflake para o projeto, garantindo isolamento e organização dos dados.
- Convertidos arquivos originais no formato `.dbc` para `.csv` via script Python (`scripts/extract/convert_dbc_to_csv.py`), visando compatibilidade com o Snowflake e o dbt.
- Armazenamento temporário realizado em um stage interno no Snowflake, simulando um data lake inicial.
- Criada tabela `raw_aih` com schema tipado (DATE, NUMBER, STRING) para preservar integridade e coerência dos dados brutos.
- Ingestão realizada com o comando `COPY INTO`, garantindo carregamento em lote e controle de erros.

Decisão técnica chave:
Manter as datas em formato texto (`YYYYMMDD`) na ingestão para evitar problemas de parsing inicial. Conversão para tipo DATE será feita nas camadas de transformação no dbt, assegurando rastreabilidade.

## 2. Transformação e Modelagem com dbt
- Estrutura de camadas adotada no dbt:
  - Staging (`stg_`): limpeza, padronização de nomes de colunas, conversão de formatos (ex.: datas), e mapeamento direto da `raw_aih`.
  - Intermediate (`int_`): junção e enriquecimento de dados, preparando chaves para dimensões.
  - Mart (`dim_` e `fct_`): modelagem dimensional (Star Schema) com:
    - `dim_tempo`
    - `dim_localidade`
    - `dim_doenca`
    - `dim_procedimento`
    - `fct_internacoes` (tabela fato principal)

- Materializações usadas:
  - Views para staging, visando leveza e flexibilidade.
  - Tables para dimensões e fato, visando performance em consultas analíticas.
- Implementados testes de qualidade de dados no dbt:
  - "not_null" e "unique" em IDs e chaves primárias.

3. Explicação da escolha do Design
- Snowflake foi escolhido como data warehouse pela performance, escalabilidade e facilidade de integração com dbt.
- Conversão para CSV simplifica ingestão e padroniza entrada, evitando dependência de formatos proprietários.
- Camadas no dbt permitem modularidade, facilitam manutenção e isolam lógicas de transformação.
- Testes dbt asseguram confiabilidade e documentam regras de negócio diretamente no código.
- Modelagem dimensional otimiza consumo em ferramentas de BI e permite análises rápidas sobre internações hospitalares.

