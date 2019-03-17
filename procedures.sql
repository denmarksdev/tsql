-- Primeiro procedure

CREATE PROCEDURE BuscaPorEntidade @ENTIDADE AS VARCHAR(10)
AS 
BEGIN
IF ( @ENTIDADE = 'CLIENTES' )
	SELECT [CPF] AS INDENTIFICADOR, [NOME] AS DESCRITOR, [BAIRRO] FROM [TABELA DE CLIENTES]
ELSE IF @ENTIDADE =  'VENDEDORES'
	SELECT [MATRICULA] AS INDENTIFICADOR, [NOME] AS DESCRITOR,
	[BAIRRO] FROM [TABELA DE VENDEDORES]
END

exec dbo.BuscaPorEntidadesCompleta @ENTIDADE = ''

-- Segunda procedure

CREATE PROCEDURE BuscaPorEntidadesCompleta @ENTIDADE AS VARCHAR(10)
AS 
BEGIN
	IF ( @ENTIDADE = 'CLIENTES' )
		SELECT [CPF] AS INDENTIFICADOR, [NOME] AS DESCRITOR
		FROM [TABELA DE CLIENTES]
	ELSE IF @ENTIDADE =  'VENDEDORES'
		SELECT [MATRICULA] AS INDENTIFICADOR, [NOME] AS DESCRITOR
		FROM [TABELA DE VENDEDORES]
	ELSE IF @ENTIDADE = 'PRODUTOS'
		SELECT [CODIGO DO PRODUTO] AS INDENTIFICADOR, [NOME DO PRODUTO] AS DESCRITOR 
	    FROM DBO.[TABELA DE PRODUTOS]
END

exec dbo.BuscaPorEntidadesCompleta @ENTIDADE = 'PRODUTOS'


CREATE PROCEDURE CalculaIdade
AS
BEGIN 
	UPDATE [TABELA DE CLIENTES] SET IDADE = DATEDIFF(YEAR, [DATA DE NASCIMENTO], GETDATE())
END
select * from [TABELA DE CLIENTES]

exec dbo.CalculaIdade 

-- ATUALIZAC�O DO IMPOSTO

CREATE PROCEDURE AtualizaImposto @MES AS INT, @ANO AS INT, @ALIQUOTA AS FLOAT , @TIPO_PRODUTO AS VARCHAR(10)
AS
BEGIN
	UPDATE [NOTAS FISCAIS] SET IMPOSTO = @ALIQUOTA  WHERE NUMERO IN ( 
		SELECT [NOT].NUMERO FROM [NOTAS FISCAIS] [NOT]
		INNER JOIN [ITENS NOTAS FISCAIS] ITE ON [NOT].NUMERO = ITE.NUMERO
		INNER JOIN [TABELA DE PRODUTOS] PRO ON PRO.[CODIGO DO PRODUTO] = ITE.[CODIGO DO PRODUTO]
		WHERE  MONTH(DATA) = @MES AND YEAR(DATA) = @ANO AND PRO.EMBALAGEM = @TIPO_PRODUTO
		GROUP BY [NOT].NUMERO
	)
END

exec dbo.AtualizaImposto  @MES = 1, @ANO = 2018 ,@ALIQUOTA = 0.5 , @TIPO_PRODUTO = 'PET'
SELECT * FROM  [NOTAS FISCAIS] WHERE IMPOSTO = 0.5
SELECT * FROM  [TABELA DE PRODUTOS]

-- SYSTEM STORE PROCEDURES

EXEC sp_columns @table_name = 'TABELA DE CLIENTES', @Table_owner = 'dbo'
EXEC sp_tables @table_name = 'TAB%',   @Table_owner=  'dbo', @table_qualifier  = 'SUCOS_VENDAS'


-- ENTRADA SCALAR

CREATE PROCEDURE BuscaNotasCliente
@CPF AS VARCHAR(12),
@DATA_INICIAL AS DATETIME = '20160101',
@DATA_FINAL AS DATETIME  =  '20161231'
AS BEGIN
	SELECT * FROM [NOTAS FISCAIS] WHERE CPF = @CPF AND [DATA] >= @DATA_INICIAL AND DATA <= @DATA_FINAL
END

EXEC dbo.BuscaNotasCliente @CPF = '19290992743'
EXEC dbo.BuscaNotasCliente @CPF = '19290992743', @DATA_INICIAL = '20161201'
EXEC BuscaNotasCliente '19290992743', DEFAULT , '20160201'

-- ENTRADA TABELA

SELECT A.CPF , A.NOME, SUM(C.QUANTIDADE * C.PRE�O) AS FATURAMENTO FROM [TABELA DE CLIENTES] AS A
INNER JOIN [NOTAS FISCAIS] AS B
ON A.CPF = B.CPF AND YEAR(B.DATA) = 2016
INNER JOIN [ITENS NOTAS FISCAIS] AS C ON B.NUMERO = C.NUMERO
GROUP BY A.CPF, A.NOME

CREATE TYPE ListaClientes AS TABLE
(CPF VARCHAR(12) NOT NULL)

DECLARE @Lista AS ListaClientes
INSERT INTO @Lista (CPF) VALUES ('1471156710'),('19290992743'),('2600586709')
SELECT * FROM @Lista

SELECT * FROM [TABELA DE CLIENTES]


DECLARE @Lista AS ListaClientes
INSERT INTO @Lista (CPF) VALUES ('1471156710'),('19290992743'),('2600586709')

SELECT A.CPF , A.NOME, SUM(C.QUANTIDADE * C.PRE�O) AS FATURAMENTO FROM [TABELA DE CLIENTES] AS A
INNER JOIN [NOTAS FISCAIS] AS B
ON A.CPF = B.CPF AND YEAR(B.DATA) = 2016
INNER JOIN [ITENS NOTAS FISCAIS] AS C ON B.NUMERO = C.NUMERO
INNER JOIN @Lista D ON A.CPF = D.CPF
GROUP BY A.CPF, A.NOME

CREATE PROCEDURE FaturamentoClientes2016
@Lista as ListaClientes READONLY
AS
BEGIN
	SELECT A.CPF , A.NOME, SUM(C.QUANTIDADE * C.PRE�O) AS FATURAMENTO FROM [TABELA DE CLIENTES] AS A
	INNER JOIN [NOTAS FISCAIS] AS B
	ON A.CPF = B.CPF AND YEAR(B.DATA) = 2016
	INNER JOIN [ITENS NOTAS FISCAIS] AS C ON B.NUMERO = C.NUMERO
	INNER JOIN @Lista D ON A.CPF = D.CPF
	GROUP BY A.CPF, A.NOME
END

DECLARE @Lista AS ListaClientes
INSERT INTO @Lista (CPF) VALUES ('1471156710'),('19290992743'),('2600586709')
exec dbo.FaturamentoClientes2016 @Lista

select * from [TABELA DE CLIENTES]

-- Lista de n�meros

SELECT DATA, COUNT(*) AS NUMERO FROM [NOTAS FISCAIS]
WHERE DATA IN (SELECT DATANOTA FROM @ListaDatas)
GROUP BY DATA

CREATE TYPE ListaDatas AS TABLE ([DATA] DATETIME)

CREATE PROCEDURE ListNumeroNotas
 @Datas AS ListaDatas READONLY 
 AS
 SELECT DATA, COUNT(*) AS NUMERO FROM [NOTAS FISCAIS]
 WHERE DATA IN (SELECT DATA FROM @Datas)
 GROUP BY DATA

DECLARE @ListaDatas AS ListaDatas
INSERT INTO @ListaDatas ([DATA]) 
VALUES ('20180101'), ('20180102'), ('20180103')
exec dbo.ListNumeroNotas @ListaDatas

-- SPs com par�metros de sa�da
SELECT * FROM [TABELA DE CLIENTES]

SELECT COUNT(*) 
FROM [NOTAS FISCAIS] 
WHERE CPF = '19290992743'
AND YEAR([DATA]) = 2016

SELECT SUM (QUANTIDADE * PRE�O) FROM [ITENS NOTAS FISCAIS] B
INNER JOIN [NOTAS FISCAIS] A ON A.NUMERO = B.NUMERO
WHERE CPF = '19290992743'
AND YEAR([DATA])  = 2016

DROP PROCEDURE RetornaValores 
CREATE PROCEDURE RetornaValores 
@CPF AS VARCHAR(12),
@ANO AS INT,
@NUM_NOTAS AS INT OUTPUT,
@FATURAMENTO AS FLOAT OUTPUT
AS 
BEGIN
   	SELECT @NUM_NOTAS = COUNT(*) 
	FROM [NOTAS FISCAIS] 
	WHERE CPF = @CPF
	AND YEAR([DATA]) = @ANO

	SELECT @FATURAMENTO = SUM (QUANTIDADE * PRE�O) FROM [ITENS NOTAS FISCAIS] B
	INNER JOIN [NOTAS FISCAIS] A ON A.NUMERO = B.NUMERO
	WHERE CPF = @CPF
	AND YEAR([DATA])  = @ANO
END


DECLARE @NUMERO_NOTAS INT,
		@FATURAMENTO FLOAT,
		@CPF VARCHAR(12),
		@ANO INT

SET @CPF =	'19290992743'
SET @ANO  = 2016

exec dbo.RetornaValores @CPF= @CPF, @ANO = @ANO , @NUM_NOTAS = @NUMERO_NOTAS OUTPUT , @FATURAMENTO = @FATURAMENTO OUTPUT
SELECT @NUMERO_NOTAS, @FATURAMENTO

SELECT COUNT(*) FROM [NOTAS FISCAIS] WHERE [DATA] = '20170101'

DROP PROCEDURE NumNotasSP
CREATE PROCEDURE NumNotasSP @DATA AS DATE, @NUMNOTAS AS INT OUTPUT
AS
BEGIN
	DECLARE @NUMERO_NOTAS_LOCAL INT
	SELECT @NUMERO_NOTAS_LOCAL = COUNT(*) 
	FROM [NOTAS FISCAIS] 
	WHERE [DATA] = @DATA

	SET @NUMNOTAS = @NUMERO_NOTAS_LOCAL + @NUMNOTAS
	
END	

DECLARE @DATA DATE,
		@NOTAS INT

SET @NOTAS = 0
		
SET @DATA = '20170101'
exec dbo.NumNotasSP @DATA,  @NOTAS OUTPUT 

SET @DATA = '20170201'
exec dbo.NumNotasSP @DATA,  @NOTAS OUTPUT

SELECT (@NOTAS) AS NOTAS










