CREATE SCHEMA IF NOT EXISTS silver;

CREATE TABLE IF NOT EXISTS  silver.ImovelCaixa (
    NumeroImovel VARCHAR(15) PRIMARY KEY,
    UF CHAR(2),
    Cidade VARCHAR(100),
    Bairro VARCHAR(120),
    Endereco VARCHAR(255),
    Preco DECIMAL(18, 2),
    LinkDeAcesso VARCHAR(300),
    Descricao VARCHAR(500),
    Desconto DECIMAL(4,2),
    ValorAvaliacao DECIMAL(18, 2),
    ModalidadeDeVenda VARCHAR(50),
    DataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao TIMESTAMP
);