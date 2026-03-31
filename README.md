# iRede EDU Manager - Modelagem de Dados (v5)

Este repositório centraliza a documentação técnica e a arquitetura de dados do sistema pedagógico desenvolvido pela **Irede**, em parceria com o **MCTI** e **Softex**.

## 🚀 O que há de novo na Versão 5?
Nesta atualização, focamos em preparar o sistema para o ambiente de produção e escala:
- **Normalização Estratégica:** Substituição de Enums por tabelas de referência, facilitando a gestão via Supabase Studio.
- **Preparado para BI:** Inclusão de padrões IBGE e tabelas de impacto para dashboards de métricas da diretoria.
- **Conformidade LGPD:** Estrutura de logs de auditoria e campos para fluxos de anonimização de dados.

## 📊 Visualização do Diagrama
Para conferir a arquitetura visual das tabelas e seus relacionamentos:
👉 [**Clique aqui para abrir o Diagrama Interativo (dbdiagram.io)**](https://dbdiagram.io/d/69caf1cb78c6c4bc7aa475ca)

---

## 🛠️ Como aplicar no Banco de Dados (Para Devs)
O esquema agora conta com um script SQL otimizado para o **PostgreSQL/Supabase**:

1. Copie o conteúdo do arquivo `schema_v5.sql` deste repositório.
2. Acesse o **SQL Editor** no seu painel do Supabase.
3. Cole e execute o script.

> **Nota:** As tabelas de usuários utilizam `UUID` como padrão para integração nativa com o Supabase Auth.

## 📂 Estrutura do Repositório
- `/schema_v5.sql`: Script de criação das tabelas (DDL).
- `/iRede_EDU_Manager_v5.dbml`: Documentação em formato DBML para edição.

---
Documentação em constante atualização para o desenvolvimento do MVP Operacional.