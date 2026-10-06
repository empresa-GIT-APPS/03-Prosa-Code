 CREATE DATABASE IF NOT EXISTS livraria_db;

USE livraria_db;


-- 1. Tabela Categoria

CREATE TABLE IF NOT EXISTS Categoria (

    id_categoria INT AUTO_INCREMENT PRIMARY KEY,

    nome_categoria VARCHAR(100) NOT NULL

);


-- 2. Tabela Autor

CREATE TABLE IF NOT EXISTS Autor (

    id_autor INT AUTO_INCREMENT PRIMARY KEY,

    nome_autor VARCHAR(100) NOT NULL,

    bi VARCHAR(50)

);


-- 3. Tabela Livro

CREATE TABLE IF NOT EXISTS Livro (

    id_livro INT AUTO_INCREMENT PRIMARY KEY,

    nome_livro VARCHAR(150) NOT NULL,

    encadernacao VARCHAR(50),

    ano INT,

    id_categoria INT NOT NULL,

    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)

);


-- 4. Tabela Relacional Livro_Autor (N:M)

CREATE TABLE IF NOT EXISTS Livro_Autor (

    id_livro INT NOT NULL,

    id_autor INT NOT NULL,

    PRIMARY KEY (id_livro, id_autor),

    FOREIGN KEY (id_livro) REFERENCES Livro(id_livro) ON DELETE CASCADE,

    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor) ON DELETE CASCADE

);


-- 5. Tabela Comprador

CREATE TABLE IF NOT EXISTS Comprador (

    id_comprador INT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(100) NOT NULL,

    cpf_nif VARCHAR(20) UNIQUE NOT NULL,

    email VARCHAR(100),

    telefone VARCHAR(20),

    senha VARCHAR(100) NOT NULL

);


-- 6. Tabela Vendedor

CREATE TABLE IF NOT EXISTS Vendedor (

    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(100) NOT NULL,

    cpf_nif VARCHAR(20) UNIQUE NOT NULL,

    comissao DECIMAL(5,2) DEFAULT 0.00,

    login VARCHAR(50) UNIQUE NOT NULL,

    senha VARCHAR(100) NOT NULL

);


-- 7. Tabela Venda

CREATE TABLE IF NOT EXISTS Venda (

    id_venda INT AUTO_INCREMENT PRIMARY KEY,

    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,

    valor_total DECIMAL(10,2) DEFAULT 0.00,

    id_comprador INT NOT NULL,

    id_vendedor INT NOT NULL,

    FOREIGN KEY (id_comprador) REFERENCES Comprador(id_comprador),

    FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)

);


-- 8. Tabela Item_Venda

CREATE TABLE IF NOT EXISTS Item_Venda (

    id_venda INT NOT NULL,

    id_livro INT NOT NULL,

    quantidade INT NOT NULL DEFAULT 1,

    preco_unitario DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_venda, id_livro),

    FOREIGN KEY (id_venda) REFERENCES Venda(id_venda) ON DELETE CASCADE,

    FOREIGN KEY (id_livro) REFERENCES Livro(id_livro)

);
