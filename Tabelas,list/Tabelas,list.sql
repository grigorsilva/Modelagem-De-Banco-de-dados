USE Sistema_biblioteca;
-- Inserção na tabela AUTOR
INSERT INTO AUTOR (Nome, Nacionalidade) VALUES
('Gabriel Garcia Marquez', 'Colombiano'),
('Machado de Assis', 'Brasileiro'),
('Jane Austen', 'Britânica'),
('George Orwell', 'Britânico'),
('Yuval Noah Harari', 'Israelense');

-- Inserção na tabela LIVRO
INSERT INTO LIVRO (ISBN, Titulo, Ano_Publicacao, Editora) VALUES
('978-8535914849', 'Cem Anos de Solidão', 2007, 'Companhia das Letras'),
('978-8580571344', 'Dom Casmurro', 2010, 'Penguin-Companhia'),
('978-8532510342', 'Orgulho e Preconceito', 2000, 'Rocco'),
('978-8535914443', '1984', 2009, 'Companhia das Letras'),
('978-8535928174', 'Sapiens: Uma Breve História da Humanidade', 2015, 'Companhia das Letras');

-- Inserção na tabela AUTOR_LIVRO
INSERT INTO AUTOR_LIVRO (ID_Autor, ISBN_Livro) VALUES
(1, '978-8535914849'), -- Marquez - Cem Anos
(2, '978-8580571344'), -- Machado - Dom Casmurro
(3, '978-8532510342'), -- Austen - Orgulho e Preconceito
(4, '978-8535914443'), -- Orwell - 1984
(5, '978-8535928174'); -- Harari - Sapiens

-- Inserção na tabela EXEMPLAR (Cria várias cópias)
INSERT INTO EXEMPLAR (ISBN_Livro, Status_Exemplar) VALUES
('978-8535914849', 'Disponível'), -- Cem Anos - Cópia 1
('978-8535914849', 'Emprestado'), -- Cem Anos - Cópia 2
('978-8580571344', 'Disponível'), -- Dom Casmurro - Cópia 1
('978-8532510342', 'Reservado'),  -- Orgulho e Preconceito - Cópia 1
('978-8535914443', 'Disponível'); -- 1984 - Cópia 1

-- Inserção na tabela LEITOR
INSERT INTO LEITOR (Nome, CPF, Email, Data_Nascimento) VALUES
('Ana Clara Silva', '111.222.333-44', 'ana.clara@email.com', '1995-10-20'),
('Bruno Felipe Santos', '555.666.777-88', 'bruno.santos@email.com', '1988-05-15'),
('Carla Souza', '999.000.111-22', 'carla.souza@email.com', '2001-12-01');

-- Inserção na tabela EMPRESTIMO
INSERT INTO EMPRESTIMO (ID_Leitor, ID_Exemplar, Data_Emprestimo, Data_Prevista_Devolucao, Data_Devolucao) VALUES
(1, 2, '2025-11-20', '2025-12-05', NULL), -- Ana pegou 'Cem Anos' (ID_Exemplar 2). Ainda não devolveu.
(2, 4, '2025-11-10', '2025-11-25', '2025-11-24'), -- Bruno pegou 'Orgulho...' e devolveu
(3, 5, '2025-10-01', '2025-10-15', '2025-10-20'); -- Carla pegou '1984' e devolveu com atraso



-- 1. Consulta com WHERE e ORDER BY: Listar todos os livros de autores Britânicos, ordenados por título.
SELECT L.Titulo, L.Ano_Publicacao, A.Nome AS Autor
FROM LIVRO L
JOIN AUTOR_LIVRO AL ON L.ISBN = AL.ISBN_Livro
JOIN AUTOR A ON AL.ID_Autor = A.ID_Autor
WHERE A.Nacionalidade = 'Britânica' OR A.Nacionalidade = 'Britânico'
ORDER BY L.Titulo ASC;

-- 2. Consulta com JOIN e COUNT: Contar quantos exemplares estão "Disponíveis" para cada título.
SELECT 
    L.Titulo, 
    COUNT(E.ID_Exemplar) AS Total_Disponivel
FROM LIVRO L
JOIN EXEMPLAR E ON L.ISBN = E.ISBN_Livro
WHERE E.Status_Exemplar = 'Disponível'
GROUP BY L.Titulo
ORDER BY Total_Disponivel DESC;

-- 3. Consulta com WHERE, JOIN e LIKE: Encontrar leitores cujo nome começa com 'A' e ver os empréstimos ativos (não devolvidos).
SELECT 
    LE.Nome AS Leitor, 
    L.Titulo AS Livro_Emprestado,
    E.Data_Emprestimo
FROM LEITOR LE
JOIN EMPRESTIMO E ON LE.ID_Leitor = E.ID_Leitor
JOIN EXEMPLAR EX ON E.ID_Exemplar = EX.ID_Exemplar
JOIN LIVRO L ON EX.ISBN_Livro = L.ISBN
WHERE LE.Nome LIKE 'A%' 
AND E.Data_Devolucao IS NULL;

-- 4. Consulta com WHERE e LIMIT: Listar os 3 empréstimos mais recentes.
SELECT 
    LE.Nome AS Leitor, 
    L.Titulo AS Livro, 
    E.Data_Emprestimo
FROM EMPRESTIMO E
JOIN LEITOR LE ON E.ID_Leitor = LE.ID_Leitor
JOIN EXEMPLAR EX ON E.ID_Exemplar = EX.ID_Exemplar
JOIN LIVRO L ON EX.ISBN_Livro = L.ISBN
ORDER BY E.Data_Emprestimo DESC
LIMIT 3;



-- 1. UPDATE: Atualizar o status de um exemplar que estava em 'Reservado' para 'Disponível'.
-- (Usando o ID_Exemplar 4)
UPDATE EXEMPLAR
SET Status_Exemplar = 'Disponível'
WHERE ID_Exemplar = 4;

-- 2. UPDATE: Corrigir a editora de um livro específico (exemplo: '1984').
UPDATE LIVRO
SET Editora = 'HarperCollins Brasil'
WHERE ISBN = '978-8535914443';

-- 3. UPDATE: Mudar o email de um leitor específico.
UPDATE LEITOR
SET Email = 'ana.clara.nova@exemplo.com'
WHERE Nome = 'Ana Clara Silva';

-- 4. UPDATE Adicional (Obrigatório em sistemas reais): Registrar a devolução de um livro que estava em atraso (ID_Emprestimo 1).
UPDATE EMPRESTIMO
SET Data_Devolucao = '2025-12-10' -- Data posterior à prevista (2025-12-05)
WHERE ID_Emprestimo = 1;




DELETE FROM AUTOR_LIVRO WHERE ID_Autor = 5;

-- Agora o DELETE no autor funciona
DELETE FROM AUTOR
WHERE ID_Autor = 5; -- Remove Yuval Noah Harari

-- 2. DELETE: Remover um leitor que nunca fez empréstimos ou cujos empréstimos foram resolvidos.
-- (Assumindo que o Leitor 3 já resolveu seus empréstimos)
-- Se a FK não permitir, este leitor precisa ser excluído. Se você não puder, crie um novo para testes.
INSERT INTO LEITOR (Nome, CPF, Email, Data_Nascimento) VALUES
('Leitor de Teste', '000.000.000-00', 'teste@delete.com', '1990-01-01');

DELETE FROM LEITOR
WHERE Nome = 'Leitor de Teste';

-- 3. DELETE: Excluir um exemplar que foi perdido ou danificado, desde que não esteja em empréstimo ativo.
-- (Exemplar 1, que estava disponível)
DELETE FROM EXEMPLAR
WHERE ID_Exemplar = 1 AND Status_Exemplar = 'Disponível';