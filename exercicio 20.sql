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
