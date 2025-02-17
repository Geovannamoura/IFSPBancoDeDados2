CREATE DATABASE docesdagio;
USE docesdagio;

-- Criando a tabela tb_doceria primeiro
CREATE TABLE tb_doceria (
    pk_cnpj VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(60)
);

-- Criando a tabela de endereço da doceria
CREATE TABLE tb_endereco_doceria (
    pk_cep VARCHAR(10) PRIMARY KEY,
    rua VARCHAR(100),
    bairro VARCHAR(60),
    numero NUMERIC,
    complemento VARCHAR(100),
    cidade VARCHAR(60),
    fk_cnpj VARCHAR(20),
    FOREIGN KEY (fk_cnpj) REFERENCES tb_doceria(pk_cnpj)
);

-- Criando a tabela tb_users
CREATE TABLE tb_users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    cpf CHAR(13) UNIQUE,
    nome VARCHAR(60),
    email VARCHAR(60),
    senha VARCHAR(12),
    telefone VARCHAR(15),
    endereco VARCHAR(100)
);

-- Criando a tabela de contato
CREATE TABLE tb_contato (
    telefone VARCHAR(15),
    email VARCHAR(60),
    fk_id_user INT,
    FOREIGN KEY (fk_id_user) REFERENCES tb_users(id_user)
);

-- Criando a tabela de endereço
CREATE TABLE tb_endereco (
    endereco VARCHAR(100),
    fk_id_user INT,
    FOREIGN KEY (fk_id_user) REFERENCES tb_users(id_user)
);

-- Criando a tabela de funcionários
CREATE TABLE tb_funcionarios (
    pk_id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60),
    funcao VARCHAR(60),
    fk_cnpj VARCHAR(20),
    FOREIGN KEY (fk_cnpj) REFERENCES tb_doceria(pk_cnpj)
);

-- Criando a tabela de produtos
CREATE TABLE tb_produto (
    pk_id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(60),
    valor_produto FLOAT,
    qntd_estoque_produto NUMERIC,
    descricao_produto VARCHAR(200)
);

-- Criando a tabela de pedidos
CREATE TABLE tb_pedido (
    pk_id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fk_id_user INT,
    fk_cnpj VARCHAR(20),
    FOREIGN KEY (fk_id_user) REFERENCES tb_users(id_user),
    FOREIGN KEY (fk_cnpj) REFERENCES tb_doceria(pk_cnpj)
);

-- Criando a tabela de itens do pedido
CREATE TABLE tb_itens_pedidos (
    pk_itens_pedidos INT AUTO_INCREMENT PRIMARY KEY,
    fk_id_user INT,
    fk_id_produto INT,
    fk_id_pedido INT,
    subtotal_itens_pedidos FLOAT,
    data_hora DATETIME,
    FOREIGN KEY (fk_id_user) REFERENCES tb_users(id_user),
    FOREIGN KEY (fk_id_produto) REFERENCES tb_produto(pk_id_produto),
    FOREIGN KEY (fk_id_pedido) REFERENCES tb_pedido(pk_id_pedido)
);

-- Criando a tabela de nota fiscal
CREATE TABLE tb_nota_fiscal (
    pk_nota_fiscal INT AUTO_INCREMENT PRIMARY KEY,
    fk_itens_pedidos INT,
    fk_cnpj VARCHAR(20),
    fk_id_user INT,
    FOREIGN KEY (fk_itens_pedidos) REFERENCES tb_itens_pedidos(pk_itens_pedidos),
    FOREIGN KEY (fk_cnpj) REFERENCES tb_doceria(pk_cnpj),
    FOREIGN KEY (fk_id_user) REFERENCES tb_users(id_user)
);

DELIMITER $$

-- Função para calcular o total do pedido
CREATE FUNCTION calcularTotalPedido(pedido_id INT) 
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total FLOAT DEFAULT 0;

    SELECT SUM(ip.subtotal_itens_pedidos) INTO total
    FROM tb_itens_pedidos ip
    WHERE ip.fk_id_pedido = pedido_id;

    RETURN total;
END$$

-- Trigger para atualizar o estoque após inserção de um pedido
CREATE TRIGGER atualizarEstoquePedido
AFTER INSERT ON tb_itens_pedidos
FOR EACH ROW
BEGIN
    UPDATE tb_produto 
    SET qntd_estoque_produto = qntd_estoque_produto - NEW.subtotal_itens_pedidos
    WHERE pk_id_produto = NEW.fk_id_produto;
END$$

-- Procedures
CREATE PROCEDURE AlterarParaAdmin (IN userId INT)   
BEGIN
    UPDATE tb_users
    SET tipo = 'admin'
    WHERE id_user = userId;
END$$

CREATE PROCEDURE ObterContato (IN id_user INT)   
BEGIN
    SELECT * FROM tb_contato WHERE fk_id_user = id_user;
END$$

CREATE PROCEDURE ObterEndereco (IN id_user INT)   
BEGIN
    SELECT * FROM tb_endereco WHERE fk_id_user = id_user;
END$$

CREATE PROCEDURE PreencherContato ()   
BEGIN
    INSERT INTO tb_contato (telefone, email, fk_id_user)
    SELECT telefone, email, id_user
    FROM tb_users
    WHERE id_user NOT IN (SELECT fk_id_user FROM tb_contato);
END$$

CREATE PROCEDURE PreencherEndereco ()   
BEGIN
    INSERT INTO tb_endereco (endereco, fk_id_user)
    SELECT endereco, id_user
    FROM tb_users
    WHERE id_user NOT IN (SELECT fk_id_user FROM tb_endereco);
END$$

DELIMITER ;
