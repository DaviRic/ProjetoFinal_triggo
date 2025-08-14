# Projeto Final – triggo.ai | DataSUS + Snowflake + dbt

## Como rodar o projeto

⚠️ **Pré-requisitos:**  
Você precisa de uma conta **Snowflake**. Use a role `ACCOUNTADMIN` para ter permissões completas.

---

## **Setup inicial**
1. Crie um ambiente virtual (venv) na **raiz** do projeto (`ProjetoFinal_triggo/`):
   ```bash
   python -m venv nome_do_seu_venv
   ```

2. Ative o ambiente virtual:
   - **Linux/Mac**:
     ```bash
     source nome_do_seu_venv/bin/activate
     ```
   - **Windows**:
     ```bash
     nome_do_seu_venv\Scripts\activate
     ```

3. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```

---

### **1. Criar estruturas no Snowflake**
- Crie o **warehouse** `triggo_wh`, o **database** `triggo_db`, o **schema** `raw` e uma **stage** dentro de `raw`.
- Copie o conteúdo do arquivo:
  ```
  ProjetoFinal_triggo/sql/01_create_warehouse_database_schema.sql
  ```
- No **Snowflake Web UI**, abra uma worksheet, cole a consulta e rode.

---

### **2. Converter arquivos `.dbc` para `.csv`**
- Os dados estão em:
  ```
  ProjetoFinal_triggo/data/raw
  ```
- Execute:
  ```bash
  python ProjetoFinal_triggo/scripts/extract/1_convert_dbc_to_csv.py
  ```
- O script criará:
  ```
  ProjetoFinal_triggo/data/converted/*.csv
  ```

---

### **3. Carregar arquivos `.csv` para a stage**
- No **Snowflake Web UI**, acesse a stage `TRIGGO_STAGE` criada no passo 1.
- Clique em **+ Files** e envie os 12 arquivos `.csv`.

---

### **4. Criar e popular tabela RAW**
- Rode a consulta:
  ```
  ProjetoFinal_triggo/sql/02_create_and_populate_raw_table.sql
  ```
- Isso irá carregar os dados da **stage** para a tabela no banco de dados.

---

### **5. Configurar o dbt com o Snowflake**

### Criar o arquivo `profiles.yml`
Salve em:
```
~/.dbt/profiles.yml
```
Conteúdo (edite com suas credenciais):
```yaml
projeto_triggo:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <seu_account>
      user: <seu_usuario>
      password: <sua_senha>
      role: ACCOUNTADMIN
      warehouse: TRIGGO_WH
      database: TRIGGO_DB
      schema: RAW
      threads: 4
      client_session_keep_alive: true
```

**Descrição dos campos:**
- **account** -> ID da sua conta Snowflake  
- **user** -> Usuário Snowflake  
- **password** -> Senha Snowflake  
- **role** -> `ACCOUNTADMIN`  
- **warehouse** -> `TRIGGO_WH`  
- **database** -> `TRIGGO_DB`  
- **schema** -> `RAW`  
- **threads** -> `4`  
- **client_session_keep_alive** -> `true`  

---

### **6. Testar conexão do dbt**
```bash
dbt debug
```
Se aparecer `All checks passed!`, está pronto.

---

### **7. Instalar pacotes do dbt**
Verifique se existe `packages.yml` na raiz do projeto e rode:
```bash
dbt deps
```

---

### **8. Executar e testar o projeto**
```bash
dbt run
dbt test
```

---

### **9. Gerar documentação e visualizar**
```bash
dbt docs generate
dbt docs serve
```
---

## Arquitetura da Solução

A pipeline de dados foi desenvolvida seguindo uma **arquitetura em camadas**, o que garante **organização**, **qualidade** e **confiabilidade** dos dados em cada etapa do processo.

---

### **1. Camada de Ingestão (RAW)**
- **Origem dos dados:** DataSUS.
- **Processo:** Os dados brutos são carregados diretamente em uma **tabela de stage** no Snowflake (`RAW.TRIGGO_STAGE`), **sem qualquer transformação**.
- **Objetivo:** Servir como **fonte primária** e imutável de dados para a pipeline.

---

### **2. Camada de Staging (`models/staging`)**
- **Ferramenta:** dbt.
- **Modelo principal:** `stg_aih`.
- **Transformações realizadas:**
  - Padronização de nomes de colunas.
  - Definição e ajuste de tipos de dados.
  - Remoção de registros duplicados.

---

### **3. Camada de Modelagem (Dimensional)**
A partir dos modelos de *staging*, são criadas as estruturas dimensionais:

- **Dimensões (`models/dimensions`):**
  - `dim_doenca` — Contém atributos descritivos das doenças.
  - `dim_localidade` — Contém atributos geográficos e regionais.
  - `dim_tempo` — Contém atributos de datas e períodos.

- **Tabela Fato (`models/facts`):**
  - `fato_internacao` — Armazena as métricas de internações, vinculadas por **chaves estrangeiras** às tabelas de dimensão.

---

### **4. Camada de Consumo (`models/mart`)**
- **Objetivo:** Criar modelos otimizados para **análises de negócio** e consumo por ferramentas de BI.
- **Modelo principal:** `mrt_internacoes_mensal`.
- **Funções:**
  - Agregar dados das tabelas fato e dimensões.
  - Fornecer métricas consolidadas sobre internações, óbitos e gastos.
  - Otimizar consultas e visualizações no BI.

---

## Decisões de Design e Justificativas
Nesta seção são apresentadas as principais decisões tomadas durante o desenvolvimento da solução, bem como as justificativas para cada escolha.

### 1. Arquitetura em Camadas (Staging, Dimensions, Facts, Mart)

- **Decisão:** Adotar a arquitetura em camadas para a pipeline.  
- **Justificativa:** Essa abordagem melhora a organização do código, a reusabilidade (os modelos `stg_` podem ser usados por outras dimensões e fatos) e a manutenção. A separação clara entre a limpeza de dados (staging), a modelagem (dimensions e facts) e a agregação para consumo (mart) torna a pipeline mais robusta e fácil de auditar.

### 2. Modelagem Dimensional (Star Schema)

- **Decisão:** Utilizar o Star Schema para a modelagem dos dados de internação.  
- **Justificativa:** O Star Schema, com a tabela fato `fato_internacao` no centro e as dimensões em volta, é ideal para a análise de negócio. Ele simplifica a escrita de consultas (o que foi demonstrado na camada mart), melhora o desempenho e facilita o entendimento dos dados por parte dos analistas de negócio.

### 3. Materialização de Modelos (view vs. table)

- **Decisão:** Materializar modelos `stg_` como views e os modelos `dim_*`, `fato_*` e `mrt_*` como tables.  
- **Justificativa:** A materialização como view para staging economiza recursos, pois não é uma tabela persistente. Já a materialização como table para as camadas intermediárias e de consumo otimiza o desmepenho das consultas. Ao pré-calcular os modelos mais pesados, garantimos que as consultas de BI sejam rápidas e eficientes.

### 4. Uso de `generate_surrogate_key`

- **Decisão:** Utilizar a macro `dbt_utils.generate_surrogate_key` para criar chaves primárias nas tabelas de dimensão.  
- **Justificativa:** Isso garante que a chave primária seja um identificador consistente e único para cada registro, independentemente dos dados de origem, evitando problemas com chaves compostas e facilitando os `JOINs`.

### 5. Orquestração e Automação

- **Decisão:** Propor a orquestração da pipeline com **Snowflake Tasks**.  
- **Justificativa:** Esta escolha foi baseada na eficiência e na simplicidade da arquitetura, eliminando a necessidade de ferramentas de orquestração externas. A abordagem nativa do Snowflake reduz a complexidade e o custo de manutenção da pipeline.

---

## Resultados e Insights Obtidos

A pipeline de dados construída com dbt modelou os dados brutos de internações, permitindo uma análise clara e direta sobre a saúde pública no estado do Amazonas. O modelo `mrt_internacoes_mensal` serve como uma fonte única de verdade para consultas de negócio, possibilitando insights como estes:

1. Análise de Óbitos por Doença
- Utilizando o modelo `mrt_internacoes_mensal`, é possível identificar as doenças com maior número de óbitos em um período específico. A consulta abaixo revela as 5 principais causas de morte em 2024, permitindo que as autoridades de saúde priorizem ações e recursos para o combate dessas doenças.
```sql
SELECT
    cid_principal,
    SUM(numero_obitos) AS total_obitos
FROM triggo_db.raw.mrt_internacoes_mensal
WHERE
    estado = 'AM' AND ano = 2024
GROUP BY
    cid_principal
ORDER BY
    total_obitos DESC
LIMIT 5;
```
##
2. Análise de Gasto Total por Doença
- A mesma camada mart permite uma análise financeira. A consulta a seguir identifica as 5 doenças que geraram os maiores gastos com internações no Amazonas. Este insight é fundamental para a gestão orçamentária da saúde pública, ajudando a entender onde o dinheiro está sendo mais investido.
```sql
SELECT
    cid_principal,
    SUM(valor_total_internacoes) AS gasto_total
FROM {{ ref('mrt_internacoes_mensal') }}
WHERE estado = 'AM'
GROUP BY 1
ORDER BY gasto_total DESC
LIMIT 5;
```

3. Evolução Mensal de Internações
- Esta análise de série temporal mostra a evolução do número total de internações ao longo dos anos e meses. É uma excelente ferramenta para identificar tendências, sazonalidade e picos de demanda inesperados, que podem ser indicadores de surtos epidêmicos ou mudanças na saúde da população.
```sql
SELECT
    ano,
    mes_nome,
    SUM(numero_internacoes) AS total_internacoes
FROM {{ ref('mrt_internacoes_mensal') }}
GROUP BY 1, 2
ORDER BY ano, mes_nome;
```

---
## Invação e Diferenciação: Alerta Epidemiológico Básico
Para demonstrar algo de diferente, resolvi propor uma solução para detecção de picos incomuns de internações.
- Problema: a detecção manual de surtos epidemiológicos pode ser lenta e reativa.
- Solução Proposta: um mecanismo de alerta proativo, que utiliza os dados já modelados na pipeline para identificar anomalias.
- Como funciona: após a execução do `dbt run`, um `dbt test` customizado seria acionado para comparar o número de internações de uma doença específica na última semana com a média das semanas anteriores. Caso o aumento ultrapasse um limite pré-definido (20% por exemplo), um alerta seria enviado automaticamente.
- Valor para o Negócio: esse sistema de alerta permite que as autoridades de saúde sejam notificadas sobre possíveis surtos em estágio inicial, possibilitando uma resposa mais rápida e eficiente. Isso transforma a pipeline de dados de uma ferramente de análise passiva em um sistema de vigilância de saúde proativo.
