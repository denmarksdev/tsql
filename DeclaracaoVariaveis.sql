--Declara��o de vari�veis

DECLARE @Idade INT; 
DECLARE @Nome VARCHAR(200); 
DECLARE @Data Date; 

SET @Idade = 10;
SET @Nome = 'Denis';

print @Idade ;
Print @Nome

SET @Data = '20180517'
print @data

DECLARE @CPF VARCHAR(12)
SET @CPF = '2600586709'
--SELECT NOME, [DATA DE NASCIMENTO], IDADE  FROM [TABELA DE CLIENTES]
--WHERE  CPF = @CPF


DECLARE @Nome2 VARCHAR(200); 
DECLARE @Data2 Date; 

SELECT @Nome2 = Nome , @Data2 = [DATA DE NASCIMENTO] from [TABELA DE CLIENTES]
WHERE  CPF = @CPF

print @Nome2
print @Data2

--Exemplos

DECLARE @NUMNOTAS INT
SELECT @NUMNOTAS = COUNT(*) FROM [NOTAS FISCAIS] 
    WHERE DATA = '20170101'
PRINT @NUMNOTAS



