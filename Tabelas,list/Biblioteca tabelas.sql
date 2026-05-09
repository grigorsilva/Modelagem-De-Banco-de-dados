DROP DATABASE IF EXISTS Sistema_biblioteca;
CREATE DATABASE Sistema_biblioteca;
USE Sistema_biblioteca;

-- tabela 1 autor
CREATE TABLE AUTOR (
    ID_Autor INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Nacionalidade VARCHAR(50)
);

-- Tabela 2: LIVRO
CREATE TABLE LIVRO (
    ISBN VARCHAR(20) PRIMARY KEY,
    Titulo VARCHAR(255) NOT NULL,
    Ano_Publicacao INT,
    Editora VARCHAR(100)
);

-- Tabela 3: EXEMPLAR (Pode ser tratada como a cópia física do LIVRO)
CREATE TABLE EXEMPLAR (
    ID_Exemplar INT PRIMARY KEY AUTO_INCREMENT,
    ISBN_Livro VARCHAR(20),
    Status_Exemplar ENUM('Disponível', 'Emprestado', 'Reservado', 'Manutenção') NOT NULL DEFAULT 'Disponível',
    FOREIGN KEY (ISBN_Livro) REFERENCES LIVRO(ISBN)
);

-- Tabela 4: AUTOR_LIVRO (Tabela associativa para relacionamento N:M)
CREATE TABLE AUTOR_LIVRO (
    ID_Autor INT,
    ISBN_Livro VARCHAR(20),
    PRIMARY KEY (ID_Autor, ISBN_Livro),
    FOREIGN KEY (ID_Autor) REFERENCES AUTOR(ID_Autor),
    FOREIGN KEY (ISBN_Livro) REFERENCES LIVRO(ISBN)
);

-- Tabela 5: LEITOR
CREATE TABLE LEITOR (
    ID_Leitor INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(14) UNIQUE NOT NULL,
    Email VARCHAR(100),
    Data_Nascimento DATE
);

-- Tabela 6: EMPRESTIMO
CREATE TABLE EMPRESTIMO (
    ID_Emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    ID_Leitor INT,
    ID_Exemplar INT,
    Data_Emprestimo DATE NOT NULL,
    Data_Prevista_Devolucao DATE NOT NULL,
    Data_Devolucao DATE, -- Nullable
    FOREIGN KEY (ID_Leitor) REFERENCES LEITOR(ID_Leitor),
    FOREIGN KEY (ID_Exemplar) REFERENCES EXEMPLAR(ID_Exemplar)
);



