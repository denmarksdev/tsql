-- EXEMPLO 1 

IF OBJECT_ID('TABELA_TESTE', 'U') IS NOT NULL 	DROP TABLE TABELA_TESTE 
IF OBJECT_ID('TABELA_TESTE', 'U') IS  NULL CREATE TABLE TABELA_TESTE (ID VARCHAR(10));

SELECT GETDATE()
SELECT DATENAME(WEEKDAY, DATEADD(DAY,4, GETDATE()))


DECLARE @DIA_SEMANA VARCHAR(20)
DECLARE @NUMERO_DIAS INT

SET @NUMERO_DIAS = 0
SET @DIA_SEMANA = DATENAME(WEEKDAY, DATEADD(DAY,@NUMERO_DIAS, GETDATE()))
IF ( @DIA_SEMANA = 'Sunday' OR @DIA_SEMANA = 'Saturday' )
	PRINT 'Este dia � fim de semana'
ELSE
	PRINT 'Este dia � dia de semana'

-- EXEMPLO 2
 
DECLARE @DATANOTA DATE
DECLARE @NUMNOTAS INT
SET @DATANOTA = '20170102'

SELECT @NUMNOTAS = COUNT(*) FROM [NOTAS FISCAIS]

IF @NUMNOTAS > 70
	PRINT 'Muita nota'
ELSE 
	PRINT 'Pouca nota'
PRINT @NUMNOTAS


-- EXEMPLO 3
DECLARE @LIMITE_MAXIMO FLOAT, @LIMITE_ATUAL FLOAT
DECLARE @BAIRRO VARCHAR(20);

SET @BAIRRO = 'Jardins';
SET @LIMITE_MAXIMO = 300000;
SELECT @LIMITE_ATUAL = SUM([LIMITE DE CREDITO]) FROM [TABELA DE CLIENTES] WHERE BAIRRO = @BAIRRO

PRINT @LIMITE_MAXIMO




IF  @LIMITE_MAXIMO <= (SELECT SUM([LIMITE DE CREDITO]) FROM [TABELA DE CLIENTES] WHERE BAIRRO =@BAIRRO)
	BEGIN
		PRINT 'VALOR EXTOROU. N�O � POSS�VEL ABRIR NOVOS CR�DITOS'
	END
ELSE 
	BEGIN
		PRINT 'VALOR N�O ESTOROU. � POSS�VEL ABRIR NOVOS CR�DITOS'
	 END 


DECLARE @DATANOTA DATE
SET @DATANOTA = '20170102'
IF (SELECT COUNT(*) FROM [NOTAS FISCAIS] 
        WHERE DATA = @DATANOTA) > 70
    PRINT 'Muita nota'
ELSE
    PRINT 'Pouca nota'