-- Ellian Abe 00098381
--exercicio 23
CREATE OR ALTER FUNCTION fn_classificacao_cliente(
    @id_cliente INT
)
RETURNS VARCHAR(18)
AS
BEGIN
    DECLARE @classificacao VARCHAR(18) -- variavel que armazenara a classificação
    DECLARE @vendas INT -- quantidade de compras do cliente
    SET @vendas = (
        SELECT COUNT(*)
        FROM VENDA V INNER JOIN PEDIDO P
        ON V.id_pedido = P.id_pedido
        WHERE P.id_cliente = @id_cliente)

    -- faz um if pra assinalar o valor correto da classificação do cliente
    IF @vendas < 2
        SET @classificacao = 'Cliente esporádico'
    ELSE IF @vendas >= 2 AND @vendas <= 10
        SET @classificacao = 'recorrente'
    ELSE
        SET @classificacao = 'Fidelizado'
        
    RETURN @classificacao -- retorna o valor setado no if acima

END