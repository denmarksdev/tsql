DECLARE @NOME AS VARCHAR(200)
DECLARE CURSOR1  CURSOR FOR SELECT TOP 4 NOME FROM [TABELA DE CLIENTES]
OPEN CURSOR1
FETCH NEXT FROM CURSOR1 INTO @NOME

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @NOME
	FETCH NEXT FROM CURSOR1 INTO @NOME
END 

CLOSE CURSOR1
DEALLOCATE CURSOR1

-- Achando o valor total do cr�dito

DECLARE @LIMITE_CREDITO FLOAT,
		@LIMITE_CREDITO_TOTAL FLOAT;

SET @LIMITE_CREDITO_TOTAL = 0;

DECLARE CURSOR_CLIENTE CURSOR FOR SELECT [LIMITE DE CREDITO] FROM [TABELA DE CLIENTES]
OPEN CURSOR_CLIENTE
FETCH NEXT FROM CURSOR_CLIENTE INTO @LIMITE_CREDITO

WHILE @@FETCH_STATUS = 0
BEGIN 
    SET	@LIMITE_CREDITO_TOTAL += @LIMITE_CREDITO 
	FETCH NEXT FROM CURSOR_CLIENTE  INTO @LIMITE_CREDITO
END

CLOSE CURSOR_CLIENTE
DEALLOCATE CURSOR_CLIENTE

SELECT @LIMITE_CREDITO_TOTAL AS TOTAL

-- Mais de um campo

DECLARE @NOME  VARCHAR(200)
DECLARE @ENDERECO VARCHAR(MAX)
DECLARE CURSOR1 CURSOR FOR 
	SELECT NOME, ([ENDERECO 1] + ' - ' + BAIRRO + ' - ' + CIDADE + ' - ' + ESTADO + ' - ' + CEP ) ENDCOMPLETO
	FROM [TABELA DE CLIENTES]	

	OPEN CURSOR1 
	FETCH NEXT FROM CURSOR1 INTO @NOME, @ENDERECO
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT @NOME + ' Endere�o ' + @Endereco
		FETCH NEXT FROM CURSOR1 INTO @NOME, @ENDERECO
	END
CLOSE CURSOR1
DEALLOCATE CURSOR1

-- fATURAMENTO POR M�S

DECLARE	
	@QUANTIDADE INT,
	@PRECO FLOAT,
	@FATURAMENTO FLOAT

SET @FATURAMENTO = 0

DECLARE CURSOR1 CURSOR FOR SELECT INF.QUANTIDADE, INF.PRE�O FROM [ITENS NOTAS FISCAIS] INF
  INNER JOIN [NOTAS FISCAIS] NF ON NF.NUMERO = INF.NUMERO
  WHERE MONTH(NF.DATA) = 1 AND YEAR(NF.DATA) = 2017  

OPEN CURSOR1
FETCH FROM CURSOR1 INTO @QUANTIDADE, @PRECO
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @FATURAMENTO +=  @QUANTIDADE * @PRECO
	FETCH NEXT FROM CURSOR1 INTO @QUANTIDADE, @PRECO
END

CLOSE CURSOR1
DEALLOCATE CURSOR1

PRINT @FATURAMENTO

-- N�meros aleat�rios

SELECT RAND()

SELECT  ROUND( ((500 - 100 - 1) * (SELECT * FROM VW_ALEATORIO) + 100) ,0)

DROP FUNCTION NumeroAleatorio
CREATE FUNCTION NumeroAleatorio(@VAL_INIC INT, @VAL_FINAL INT ) RETURNS INT
AS
BEGIN
	DECLARE @ALEATORIO INT
	SET @ALEATORIO = ROUND( ((@VAL_FINAL - @VAL_INIC - 1) * (SELECT * FROM VW_ALEATORIO) + @VAL_INIC) ,0)
	RETURN @ALEATORIO
END

   exec  [dbo].[NumeroAleatorio] 1,10











		

