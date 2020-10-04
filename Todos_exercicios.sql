use laboratorio_banco_de_dados;
--Ellian Abe 00098381
--exercicio 12
CREATE OR ALTER VIEW produtos_por_venda
AS
SELECT  pd.nome_produto, v.dt_venda
FROM    venda v join itens_pedido ip on v.id_pedido = ip.id_pedido
                join produto pd on ip.id_produto = pd.id_produto;

--exercicio 13
CREATE OR ALTER VIEW venda_nf
AS
SELECT  V.id_venda, V.dt_venda, V.total_liquido, nf.dt_emissao, nf.numero_nota -- define os campos
FROM    VENDA V LEFT JOIN nota_fiscal NF ON V.id_venda = NF.id_venda; -- faz um left join para trazer todos os registros da tabela a esquerda e as correspondencias na tabela a direita

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

--exercicio 20
CREATE OR ALTER PROC sp_upsert_funcionario(
-- recebe os parametros para carregar as tabelas de pessoa e funcionario, fazendo update ou insert.
    @nome_pessoa varchar(100),
	@cpf varchar(10),
	@endereco varchar(300),
	@telefone_principal varchar(15),
	@dt_admissao date,
	@comissionado bit
)
AS 
BEGIN

    -- variavel auxiliar para guardar o id gerado no insert ou o id encontrado(caso exista a pessoa cadastrada)
    DECLARE @output TABLE(
        id_pessoa int
    )

    -- variavel que recebe o valor do id propriamente dito.
    DECLARE @id_pessoa int;

    -- se não existe o cpf no cadastro de pessoas
    IF NOT EXISTS(
    SELECT pessoa.id_pessoa FROM pessoa
    WHERE pessoa.cpf = @cpf)
    BEGIN
            -- insere a pessoa no banco de dados e salva o id gerado na tabela @output.
            INSERT INTO pessoa
            OUTPUT INSERTED.id_pessoa into @output
            VALUES (@nome_pessoa, @cpf, @endereco, @telefone_principal)
    END
    ELSE
    -- se existe
    BEGIN
        -- insere na tabela output o id da pessoa da tabela pessoa.
        INSERT INTO @output
        SELECT pessoa.id_pessoa FROM pessoa WHERE pessoa.cpf = @cpf;
    END

    -- salva o id na variavel @id_pessoa
    select @id_pessoa = id_pessoa from @output;

    -- faz um 'upsert'
    -- faz update no banco de dados.
    UPDATE funcionario SET dt_admissao=@dt_admissao, comissionado = @comissionado
    WHERE id_pessoa=@id_pessoa;

    -- se não fez update de nenhuma linha, insere a informação
    IF @@ROWCOUNT = 0
        INSERT INTO funcionario VALUES (@id_pessoa, @dt_admissao, @comissionado)
END

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
