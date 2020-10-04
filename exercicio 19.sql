-- Ellian Abe 00098381
--exercicio 19
CREATE OR ALTER PROC sp_estoque_baixo(
    @quantidade bigint -- recebe a quantidade como parametro
)
AS
BEGIN
    declare @msg varchar(100); -- mensagem de erro

    IF not exists (select produto.* from produto where produto.qtd_estoque <= @quantidade) -- se não existe produto com estoque menor que a quantidade
        BEGIN
        set @msg = CONCAT('Não existe produto com estoque menor ou igual a ', @quantidade) -- seta a mensagem
        RAISERROR(@msg, 1, 1) -- avisa que não foi encontrado produto com estoque <= que o parametro
        END
    else
        -- senão, exibe dados do produto que atenda a condição qtd_estoque <= @quantidade
        select  p.id_produto, p.nome_produto, p.qtd_estoque, f.nome_fornecedor
        from    produto p left join fornecedor_produto fp on p.id_produto = fp.id_produto
                           join fornecedor f on fp.id_fornecedor = f.id_fornecedor
        WHERE   p.qtd_estoque <= @quantidade
        
END
