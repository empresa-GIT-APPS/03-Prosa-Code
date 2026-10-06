# 📚 Banco de Dados — Livraria (`livraria_db`)

Esta pasta reúne toda a **modelagem do banco de dados** do sistema de livraria, nas três etapas clássicas: **conceitual (DER)**, **lógica (DL)** e **física (scripts SQL)**.

---

## 🗂️ Estrutura da pasta

```
database/
├── DER/        → Diagrama Entidade-Relacionamento (modelo conceitual)
├── DL/         → Diagrama Lógico (tabelas, colunas, PKs, FKs)
└── scripts/    → Código SQL para criar o banco (modelo físico)
```

| Pasta | O que contém | Para que serve |
|-------|--------------|----------------|
| **DER** | Imagem do diagrama entidade-relacionamento | Visão de alto nível: entidades, atributos e relacionamentos |
| **DL** | Diagrama lógico do banco | Mostra tabelas, tipos de dados, chaves primárias (PK), estrangeiras (FK) e únicas (UK) |
| **scripts** | Arquivo(s) `.sql` | Cria o banco `livraria_db` e todas as tabelas |

---

## 🧠 1. Modelo Conceitual (DER)

O DER descreve **7 entidades** e seus relacionamentos:

| Entidade | Atributos |
|----------|-----------|
| **Categoria** | `id_categoria` (PK), `nome_categoria` |
| **Autor** | `id_autor` (PK), `nome_autor`, `bi` |
| **Livro** | `id_livro` (PK), `nome_livro`, `encadernacao`, `ano` |
| **Comprador** | `id_comprador` (PK), `nome`, `cpf_nif` (UK), `email`, `telefone`, `senha` |
| **Vendedor** | `id_vendedor` (PK), `nome`, `cpf_nif` (UK), `comissao`, `login` (UK), `senha` |
| **Venda** | `id_venda` (PK), `data_venda`, `valor_total` |

### 🔗 Relacionamentos

| Relacionamento | Entidades | Cardinalidade | Significado |
|----------------|-----------|:-------------:|-------------|
| **Classifica** | Categoria → Livro | 1 : N | Uma categoria classifica vários livros; cada livro tem uma categoria |
| **Escreve** | Autor ↔ Livro | N : M | Um autor escreve vários livros; um livro pode ter vários autores |
| **Realiza** | Comprador → Venda | 1 : N | Um comprador realiza várias vendas |
| **Registra** | Vendedor → Venda | 1 : N | Um vendedor registra várias vendas |
| **Contém** | Venda ↔ Livro | N : M | Uma venda contém vários livros; atributos do relacionamento: `quantidade` e `preco_unitario` |

---

## 🧱 2. Modelo Lógico (DL)

No modelo lógico, os relacionamentos **N:M** viram tabelas associativas, resultando em **8 tabelas**:

```
Categoria ──1:N──► Livro ◄──N:1── Livro_Autor ──N:1──► Autor
                     ▲
                     │ N:1
                Item_Venda ──N:1──► Venda ◄──N:1── Comprador
                                      ▲
                                      │ N:1
                                   Vendedor
```

### Tabelas associativas criadas

- **`Livro_Autor`** — resolve o N:M entre *Livro* e *Autor*. Chave primária composta: `(id_livro, id_autor)`.
- **`Item_Venda`** — resolve o N:M entre *Venda* e *Livro* (relacionamento "Contém"). Chave primária composta: `(id_venda, id_livro)`, e guarda `quantidade` e `preco_unitario`.

### Legenda das chaves

| Sigla | Significado |
|-------|-------------|
| **PK** | Primary Key — chave primária |
| **FK** | Foreign Key — chave estrangeira |
| **UK** | Unique Key — valor único (não repete) |

---

## 💾 3. Modelo Físico (scripts SQL)

O script cria o banco `livraria_db` e as tabelas **na ordem correta de dependência**:

| # | Tabela | Descrição | Principais restrições |
|:-:|--------|-----------|-----------------------|
| 1 | `Categoria` | Gêneros/categorias dos livros | PK auto-incremento |
| 2 | `Autor` | Autores cadastrados | PK auto-incremento |
| 3 | `Livro` | Catálogo de livros | FK → `Categoria` |
| 4 | `Livro_Autor` | Liga livros e autores | PK composta; FKs com `ON DELETE CASCADE` |
| 5 | `Comprador` | Clientes | `cpf_nif` único e obrigatório |
| 6 | `Vendedor` | Funcionários que vendem | `cpf_nif` e `login` únicos; `comissao` padrão `0.00` |
| 7 | `Venda` | Cabeçalho da venda | FKs → `Comprador` e `Vendedor`; `data_venda` padrão `CURRENT_TIMESTAMP` |
| 8 | `Item_Venda` | Itens de cada venda | PK composta; `quantidade` padrão `1`; FK → `Venda` com `ON DELETE CASCADE` |

### ▶️ Como executar

```bash
# Pelo terminal (MySQL / MariaDB)
mysql -u seu_usuario -p < scripts/nome_do_arquivo.sql
```

Ou abra o arquivo `.sql` no **MySQL Workbench**, **DBeaver** ou **phpMyAdmin** e execute o script completo.

> O script usa `CREATE ... IF NOT EXISTS`, então pode ser executado mais de uma vez sem erro.

---

## 🔄 Regras de integridade importantes

- 🗑️ Ao excluir um **livro** ou **autor**, os vínculos em `Livro_Autor` são removidos automaticamente (`ON DELETE CASCADE`).
- 🗑️ Ao excluir uma **venda**, seus itens em `Item_Venda` também são removidos.
- 🔒 Um **livro vendido** não pode ser excluído enquanto houver itens de venda referenciando-o.
- 🪪 `cpf_nif` não pode se repetir entre compradores (nem entre vendedores), e `login` do vendedor é único.
- 📚 Todo livro **precisa** de uma categoria (`id_categoria NOT NULL`).

---

## 💡 Sugestões de melhoria

1. **Senhas**: armazene sempre o *hash* (ex.: bcrypt), nunca a senha em texto puro. Considere `VARCHAR(255)` para comportar o hash.
2. **`valor_total`**: pode ser calculado a partir de `Item_Venda` (`SUM(quantidade * preco_unitario)`), via consulta ou *trigger*, evitando inconsistências.
3. **Estoque**: ainda não há controle de quantidade em estoque; uma coluna `estoque` em `Livro` seria útil.
4. **Índices**: crie índices em `Livro(nome_livro)` e `Venda(data_venda)` para acelerar buscas e relatórios.

---

## 🛠️ Tecnologias

- **SGBD:** MySQL
- **Linguagem:** SQL (DDL)
- **Modelagem:** DER + Diagrama Lógico

---

📌 *Este README documenta a estrutura do banco `livraria_db`. Ajuste os nomes dos arquivos conforme o conteúdo real das pastas.*
