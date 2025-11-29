CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE IF NOT EXISTS dw.DIM_Localizacao (
    nom_cidade VARCHAR(100),
    sig_estado CHAR(2),
    nom_endereco VARCHAR(255),
    nom_bairro VARCHAR(120),
    num_localizacao INT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS dw.Dim_Imovel (
    num_imovel VARCHAR(15) PRIMARY KEY,
    url_acesso VARCHAR(300),
    dsc VARCHAR(255),   
    nom_modalidade_venda VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dw.Dim_Movimentacao (
    dat_movimentacao TIMESTAMP,
    nom_tipo_movimentacao VARCHAR(100),
    dsc_de VARCHAR(500),
    dsc_para VARCHAR(500),
    num_movimentacao INT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS dw.Fato_VendaImovel (
    num_venda_imovel INT PRIMARY KEY,
    val_avaliacao DECIMAL(18,2),
    val_desconto DECIMAL(4,2),
    fk_num_localizacao INT REFERENCES dw.DIM_Localizacao(num_localizacao),
    fk_num_imovel VARCHAR(15) REFERENCES dw.Dim_Imovel(num_imovel),
    fk_num_movimentacao INT REFERENCES dw.Dim_Movimentacao(num_movimentacao)
);