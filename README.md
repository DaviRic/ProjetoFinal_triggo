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

## 🚀 Passo a Passo Realizado

### 1. Preparação e Ingestão dos Dados

- Criado warehouse, database e schema no Snowflake para o projeto.  
- Convertidos os arquivos `.dbc` originais para `.csv` utilizando script Python (`scripts/extract/convert_dbc_to_csv.py`).  
- Criado stage interno no Snowflake e carregados os arquivos CSV convertidos para o stage.  
- Criada tabela `raw_aih` com schema tipado no Snowflake para receber os dados brutos.  
- Utilizado comando `COPY INTO` para ingerir os dados do stage para a tabela `raw_aih`.

## 📒 Decisões Técnicas

- Optou-se por converter arquivos `.dbc` para CSV, pela simplicidade e garantia de compatibilidade com Snowflake e dbt.  
- Os dados foram carregados com tipos apropriados e específicos para cada coluna, como DATE para datas, NUMBER com precisão
  para valores numéricos e STRING para códigos e textos, garantindo integridade e facilitando as transformações posteriores.
- Datas foram mantidas em formato texto `YYYYMMDD` e serão convertidas no dbt conforme necessidade.  

