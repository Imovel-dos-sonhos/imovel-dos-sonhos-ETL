CREATE TABLE IF NOT EXISTS ImoveisCaixa(
    NumeroDoImovel      VARCHAR(14) PRIMARY KEY,
    UF                  CHAR(2),
    Cidade              VARCHAR(100),
    Bairro              VARCHAR(120),
    Endereco            VARCHAR(255),
    Preco               DECIMAL(18, 2),
    ValorAvaliacao      DECIMAL(18, 2),
    Desconto            DECIMAL(3, 2),
    Descricao           VARCHAR(500),
    LinkDeAcesso        VARCHAR(120)
);
