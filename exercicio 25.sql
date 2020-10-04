-- Ellian Abe 00098381
--exercicio 25
CREATE OR ALTER FUNCTION fn_valor_imposto(
    @valor_produto float,
    @taxa_imposto FLOAT
)
RETURNS FLOAT
BEGIN
    DECLARE @valor_imposto FLOAT
    SET @valor_imposto = (@valor_produto * @taxa_imposto) / 100 -- calculo simples de porcentagem sobre um determinado valor
    RETURN @valor_imposto -- retorna o valor definido acima.
END