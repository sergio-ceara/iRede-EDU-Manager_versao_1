-- #############################################################
-- IREDE EDU MANAGER - SCHEMA SQL (VERSÃO 5)
-- Foco: Normalização, BI (MCTI/Irede) e LGPD
-- #############################################################

-- 1. TABELAS DE CONTROLADORIA E ACESSO
CREATE TABLE papel_usuario (
  id SERIAL PRIMARY KEY,
  nome VARCHAR UNIQUE NOT NULL, -- 'ADMINISTRADOR', 'GESTOR', 'PROFESSOR', 'ANALISTA'
  descricao TEXT
);

CREATE TABLE local_trabalho_usuario (
  id SERIAL PRIMARY KEY,
  descricao TEXT,
  logradouro VARCHAR,
  numero VARCHAR,
  complemento VARCHAR,
  bairro VARCHAR,
  cep VARCHAR(9),
  cidade_ibge VARCHAR(10),
  cidade_nome VARCHAR,
  estado_ibge VARCHAR(2),
  estado_nome VARCHAR,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  atualizado_em TIMESTAMP WITH TIME ZONE
);

CREATE TABLE usuario (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Padrão Supabase Auth
  nome VARCHAR NOT NULL,
  email VARCHAR UNIQUE NOT NULL,
  senha_hash VARCHAR,
  senha_validade DATE,
  papel_id INT REFERENCES papel_usuario(id),
  local_trabalho_id INT REFERENCES local_trabalho_usuario(id),
  ativo BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  atualizado_em TIMESTAMP WITH TIME ZONE
);

CREATE TABLE log_auditoria (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id UUID REFERENCES usuario(id),
  acao VARCHAR NOT NULL,
  entidade VARCHAR NOT NULL,
  registro_id VARCHAR,
  campos JSONB,
  origem_ip VARCHAR,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. TABELAS DE ALUNO E ENTIDADES
CREATE TABLE entidade_ensino (
  id SERIAL PRIMARY KEY,
  descricao VARCHAR NOT NULL,
  logradouro VARCHAR,
  numero VARCHAR,
  cep VARCHAR(9),
  cidade_nome VARCHAR,
  estado_nome VARCHAR,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE anonimizacao_situacao (
  id SERIAL PRIMARY KEY,
  descricao VARCHAR NOT NULL, -- 'ATIVO', 'EXPIRADO', 'CONCLUÍDO', 'RETIDO'
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE aluno (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entidade_ensino_id INT REFERENCES entidade_ensino(id),
  cpf VARCHAR(14) UNIQUE NOT NULL,
  nome_completo VARCHAR NOT NULL,
  email VARCHAR,
  data_nascimento DATE,
  genero VARCHAR,
  cor_raca VARCHAR,
  formacao_previa VARCHAR,
  anonimizacao_situacao_id INT REFERENCES anonimizacao_situacao(id),
  anonimizacao_prevista_data DATE,
  anonimizacao_executada_data TIMESTAMP WITH TIME ZONE,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  atualizado_em TIMESTAMP WITH TIME ZONE
);

CREATE TABLE endereco (
  id SERIAL PRIMARY KEY,
  aluno_id UUID REFERENCES aluno(id) ON DELETE CASCADE,
  descricao VARCHAR,
  logradouro VARCHAR,
  bairro VARCHAR,
  cep VARCHAR(9),
  cidade_ibge VARCHAR(10),
  cidade_nome VARCHAR,
  estado_nome VARCHAR,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. CURSOS E MATRÍCULAS
CREATE TABLE curso (
  id SERIAL PRIMARY KEY,
  nome VARCHAR NOT NULL,
  programa VARCHAR,
  projeto VARCHAR,
  tecnologia VARCHAR,
  carga_horaria INT,
  ativo BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE oferta_turma (
  id SERIAL PRIMARY KEY,
  curso_id INT REFERENCES curso(id),
  codigo_turma VARCHAR UNIQUE,
  ciclo VARCHAR,
  ano INT,
  semestre INT,
  ativa BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE status_matricula (
  id SERIAL PRIMARY KEY,
  nome VARCHAR UNIQUE NOT NULL, -- 'INSCRITO', 'MATRICULADO', 'ATIVO', 'EVADIDO', 'CONCLUIDO'
  descricao TEXT
);

CREATE TABLE matricula (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aluno_id UUID REFERENCES aluno(id),
  oferta_turma_id INT REFERENCES oferta_turma(id),
  status_id INT REFERENCES status_matricula(id),
  nota_final NUMERIC(5,2),
  frequencia_final NUMERIC(5,2),
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(aluno_id, oferta_turma_id)
);

-- 4. EGRESSOS E IMPACTO (BI)
CREATE TABLE situacao_egresso (
  id SERIAL PRIMARY KEY,
  nome VARCHAR UNIQUE NOT NULL,
  descricao TEXT
);

CREATE TABLE egresso (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aluno_id UUID UNIQUE REFERENCES aluno(id),
  situacao_id INT REFERENCES situacao_egresso(id),
  ultima_review TIMESTAMP WITH TIME ZONE,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE evidencia_impacto (
  id SERIAL PRIMARY KEY,
  egresso_id UUID REFERENCES egresso(id) ON DELETE CASCADE,
  tipo VARCHAR,
  titulo VARCHAR,
  descricao TEXT,
  link_publico VARCHAR,
  data_ocorrencia TIMESTAMP WITH TIME ZONE,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);