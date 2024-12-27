CREATE DATABASE doceria
USE doceria


CREATE TABLE tb_cliente (
    pk_cpf_cliente CHAR PRIMARY KEY,
    nome_cliente VARCHAR
);



CREATE TABLE tb_contato (
    whatsapp CHAR,
    telefone CHAR,
    pk_email VARCHAR PRIMARY KEY,
    fk_cpf_cliente CHAR,
    FOREIGN KEY (fk_cpf_cliente) REFERENCES tb_cliente(pk_cpf_cliente)
);


CREATE TABLE tb_endereco (
    rua VARCHAR,
    pk_cep VARCHAR PRIMARY KEY,
    numero NUMERIC,
    complemento  VARCHAR,
    bairro VARCHAR,
    cidade VARCHAR,
    fk_cpf_cliente CHAR,
    FOREIGN KEY (fk_cpf_cliente) REFERENCES tb_cliente(pk_cpf_cliente)
);

CREATE TABLE tb_produto (
    pk_id_produto NUMERIC PRIMARY KEY,
    nome_produto VARCHAR,
    valor_produto FLOAT,
    qntd_estoque_produto NUMERIC,
    descricao_produto VARCHAR
);

CREATE TABLE tb_itens_pedidos_pedido_produto (
    pk_itens_pedidos VARCHAR PRIMARY KEY,
    fk_cpf_cliente CHAR,
    fk_id_produto NUMERIC,
    fk_id_pedido NUMERIC,
    subtotal_itens_pedidos FLOAT,
    data_hora TIME,
    FOREIGN KEY (fk_cpf_cliente) REFERENCES tb_cliente(pk_cpf_cliente),
    FOREIGN KEY (fk_id_produto) REFERENCES tb_produto(pk_id_produto),
    FOREIGN KEY (fk_id_pedido) REFERENCES tb_pedido(pk_id_pedido)
);

CREATE TABLE tb_nota_fiscal_tb_doceria_tb_endereco_doceria (
    pk_nota_fiscal VARCHAR PRIMARY KEY,
    fk_itens_pedidos VARCHAR,
    fk_cnpj VARCHAR,
    cpf_cliente VARCHAR
    FOREIGN KEY (fk_itens_pedidos) REFERENCES tb_itens_pedidos_pedido_produto(pk_itens_pedidos),
    FOREIGN KEY(fk_cnpj) REFERENCES tb_doceria(pk_cnpj)
);

CREATE TABLE tb_funcionarios (
    pk_id_funcionario NUMERIC PRIMARY KEY,
    fk_cnpj VARCHAR,
    nome VARCHAR,
    funcao VARCHAR,
    FOREIGN KEY (fk_cnpj) REFERENCES tb_doceria(pk_cnpj)
);

CREATE TABLE tb_doceria (
    nome VARCHAR,
    pk_cnpj VARCHAR PRIMARY KEY
);

CREATE TABLE tb_endereço_doceria (
    rua VARCHAR,
    pk_cep VARCHAR PRIMARY KEY,
    bairro VARCHAR,
    numero NUMERIC,
    complemento VARCHAR,
    cidade VARCHAR,
    fk_cnpj VARCHAR,
    FOREIGN KEY(fk_cnpj) REFERENCES tb_doceria(pk_cnpj)
);

CREATE TABLE tb_pedido (
    pk_id_pedido NUMERIC PRIMARY KEY,
    fk_cpf_cliente CHAR,
    FOREIGN KEY (fk_cpf_cliente) REFERENCES tb_cliente(pk_cpf_cliente),
    fk_cnpj VARCHAR,
    FOREIGN KEY(fk_cnpj) REFERENCES tb_doceria(pk_cnpj)
);

select * from tb_cliente 

