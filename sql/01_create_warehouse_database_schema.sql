-- Script para criação do warehouse, database e schema no Snowflake
-- Projeto: Desafio final triggo.ai - Health Insights Brasil
-- Autor: Davi Cruvel
-- Data: 2025-08-08

-- Cria um warehouse chamado triggo_wh
CREATE WAREHOUSE IF NOT EXISTS triggo_wh
  WITH WAREHOUSE_SIZE = 'XSMALL'  -- Tamanho mínimo para economizar créditos
  AUTO_SUSPEND = 60               -- Suspende automaticamente após 60 segundos de inatividade
  AUTO_RESUME = TRUE              -- Retoma automaticamente quando houver query
  INITIALLY_SUSPENDED = TRUE;     -- Cria já suspenso

-- Cria um database para o projeto
CREATE DATABASE IF NOT EXISTS triggo_db
    COMMENT = 'Database para o desafio final da triggo.ai com dados do DataSUS';

-- Cria um schema para a camada raw
CREATE SCHEMA IF NOT EXISTS triggo_db.raw
    COMMENT = 'Schema com dados brutos do DataSUS';

USE WAREHOUSE triggo_wh;
USE DATABASE triggo_db;
USE SCHEMA raw;

CREATE OR REPLACE STAGE triggo_stage
  FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1 NULL_IF=('','NULL'))
  COMMENT = 'Stage interno com dados brutos convertidos de .dbc para CSV';
