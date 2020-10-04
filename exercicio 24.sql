-- exercicio 24
CREATE OR ALTER FUNCTION fn_quantidade_vendas_cliente(
    @id_cliente INT
)
RETURNS BIGINT
BEGIN
    DECLARE @vendas BIGINT

    set @vendas =
       (SELECT COUNT(*)
        FROM VENDA V INNER JOIN PEDIDO P -- o inner join é feito para podermos selecionar pelo id do cliente
        ON V.id_pedido = P.id_pedido
        WHERE P.id_cliente = @id_cliente) -- faz um count simples das vendas onde o id do cliente é igual ao parametro.

    RETURN @vendas
END