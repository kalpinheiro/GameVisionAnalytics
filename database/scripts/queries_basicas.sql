/*
    Como a base possui anos incompletos após 2015,
    as análises temporais não retratam a realidade.

    O principal objetivo aqui é aprendizado de consultas com o SQL,
    sendo um pequeno complemento aos códigos executados com Pandas.
*/

-- Queries básicas
SELECT COUNT(DISTINCT Name) AS Total_Jogos
FROM Games;

SELECT COUNT(DISTINCT Publisher) AS Total_Publishers
FROM Games;

SELECT COUNT(DISTINCT Platform) AS Total_Plataformas
FROM Games;

SELECT MIN(Year) AS Primeiro_Ano, MAX(Year) AS Ultimo_Ano
FROM Games;

SELECT SUM(Global_Sales) AS Total_Vendas
FROM Games;

SELECT Genre, SUM(Global_Sales) AS Total_Vendas
FROM Games
GROUP BY Genre
ORDER BY Total_Vendas DESC;

SELECT Platform, SUM(Global_Sales) AS Total_Vendas
FROM Games
GROUP BY Platform
ORDER BY Total_Vendas DESC;

SELECT Publisher, SUM(Global_Sales) AS Total_Vendas
FROM Games
GROUP BY Publisher
ORDER BY Total_Vendas DESC;

SELECT TOP 10 Name, SUM(Global_Sales) AS Total_Vendas
FROM Games
GROUP BY Name
ORDER BY Total_Vendas DESC;

-- Consultas mais interessantes
SELECT TOP 10 Publisher, COUNT(*) AS Quantidade
FROM Games
GROUP BY Publisher
ORDER BY Quantidade DESC;

SELECT Genre, AVG(Global_Sales) AS Media_Vendas
FROM Games
GROUP BY Genre
ORDER BY Media_Vendas Desc;

SELECT Year, COUNT(*) AS Qtd_Anual
FROM Games
GROUP BY Year
ORDER BY Year;

SELECT Platform, COUNT(*) AS Quantidade
FROM Games
GROUP BY Platform
ORDER BY Quantidade DESC;

-- Queries intermediárias
--Filtrar jogos lançados em 2010.
SELECT *
FROM Games
WHERE Year = 2010;

--Filtrar jogos com vendas globais acima de 10 milhões.
SELECT Name,Global_Sales
FROM Games
WHERE Global_Sales > 10
ORDER BY Global_Sales DESC;

--Jogos lançados entre 2005 e 2010.
SELECT Name, Year
FROM Games
WHERE Year BETWEEN 2005 AND 2010
ORDER BY Year;

--Jogos das plataformas PlayStation.
SELECT Name, Platform
FROM Games
WHERE Platform IN ('PS2', 'PS3', 'PS4');

--Todos os jogos que possuem "Mario" no nome.
SELECT Name
FROM Games
WHERE Name LIKE '%Mario%';

--Publishers com mais de 100 milhões de vendas globais.
SELECT Publisher, SUM(Global_Sales) AS Total_Vendas
FROM Games
GROUP BY Publisher
HAVING SUM(Global_Sales) > 100
ORDER BY Total_Vendas DESC;

/*
WHERE filtra linhas antes da agregação.
HAVING filtra grupos depois da agregação.
*/

-- Classificar jogos por faixa de vendas.
SELECT Name,Global_Sales,
CASE
    WHEN Global_Sales >= 10 THEN 'Grande sucesso'
    WHEN Global_Sales >= 1 THEN 'Sucesso'
    ELSE 'Baixa venda'
    END AS Categoria
FROM Games
ORDER BY Global_Sales DESC;

--Mostrar todos os jogos da Nintendo com vendas globais maiores que 5 milhões.
SELECT Name, Global_Sales
FROM Games
WHERE Publisher = 'Nintendo' AND Global_Sales > 5

--Mostrar apenas jogos de RPG lançados entre 2000 e 2015, ordenados pelas maiores vendas.
SELECT Name, Genre, Global_Sales
FROM Games
WHERE Genre = 'Role-Playing' AND Year BETWEEN 2000 AND 2010
ORDER BY Global_Sales DESC;

-- Subquery e CTEs
-- Listando os jogos que venderam acima da média global.
SELECT Name, Global_Sales
FROM Games
WHERE Global_Sales > (
    SELECT AVG(Global_Sales)
    FROM Games)
ORDER BY Global_Sales DESC;

-- Ao invés de consultas gigantes, pode-se criar tabela temporária
WITH VendasGenero AS
(
    SELECT Genre,SUM(Global_Sales) AS Total_Vendas
    FROM Games
    GROUP BY Genre
)
SELECT *
FROM VendasGenero
ORDER BY Total_Vendas DESC;

-- Plataformas com mais de 500 milhões de vendas
WITH Total_Vendas AS (
    SELECT PLATFORM, SUM(Global_Sales) AS TOTAL
    FROM Games
    GROUP BY Platform
)
SELECT *
FROM Total_Vendas
WHERE Total > 500
ORDER BY TOTAL DESC;

-- 20 jogos mais vendidos com ROW_NUMBER
SELECT TOP 20 Name, Global_Sales,
    ROW_NUMBER() OVER (ORDER BY Global_Sales DESC) AS POSICAO
FROM Games
ORDER BY Global_Sales DESC;