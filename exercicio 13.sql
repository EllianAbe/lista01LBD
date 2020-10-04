
--exercicio 13
CREATE OR ALTER VIEW venda_nf
AS
SELECT  V.id_venda, V.dt_venda, V.total_liquido, nf.dt_emissao, nf.numero_nota -- define os campos
FROM    VENDA V LEFT JOIN nota_fiscal NF ON V.id_venda = NF.id_venda; -- faz um left join para trazer todos os registros da tabela a esquerda e as correspondencias na tabela a direita
