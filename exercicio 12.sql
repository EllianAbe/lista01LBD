--exercicio 12
CREATE OR ALTER VIEW produtos_por_venda
AS
SELECT  pd.nome_produto, v.dt_venda
FROM    venda v join itens_pedido ip on v.id_pedido = ip.id_pedido
                join produto pd on ip.id_produto = pd.id_produto;
