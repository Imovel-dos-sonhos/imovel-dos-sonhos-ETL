-- Quantidade de descontos por modalidade de venda
SELECT
    DI.nom_modalidade_venda,
    COUNT(FV.num_venda_imovel) AS qtd_ofertas,
    AVG(FV.val_avaliacao) AS val_medio_avaliacao,
    AVG(FV.val_desconto) AS pct_medio_desconto 
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
GROUP BY
    DI.nom_modalidade_venda
ORDER BY
    pct_medio_desconto DESC;


-- Imóveis com Maior Potencial de Venda (Maiores Descontos)
SELECT
    DI.num_imovel,
    FV.val_avaliacao AS valor_avaliacao,
    FV.val_desconto AS pct_desconto,
    DL.nom_cidade,
    DL.sig_estado
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
INNER JOIN
    dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
ORDER BY
    FV.val_desconto DESC
LIMIT 10;

-- Distribuição de Ofertas por Estado
SELECT
    DL.sig_estado,
    COUNT(FV.num_venda_imovel) AS qtd_ofertas,
    SUM(FV.val_avaliacao) AS val_total_avaliacao
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
GROUP BY
    DL.sig_estado
ORDER BY
    val_total_avaliacao DESC;


-- Valor Médio por Bairro
SELECT
    DL.nom_cidade,
    DL.nom_bairro,
    COUNT(FV.num_venda_imovel) AS qtd_ofertas,
    AVG(FV.val_avaliacao) AS val_medio_avaliacao
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
GROUP BY
    DL.nom_cidade,
    DL.nom_bairro
HAVING
    COUNT(FV.num_venda_imovel) > 5 -- Filtra bairros com inventário significativo
ORDER BY
    AVG(FV.val_avaliacao) DESC;

-- Periodo com mais cadastro de imóveis a venda
SELECT
    TO_CHAR(DM.dat_movimentacao, 'YYYY-MM') AS mes_oferta_inicial,
    COUNT(FV.num_venda_imovel) AS qtd_novos_ativos
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.Dim_Movimentacao DM ON FV.fk_num_movimentacao = DM.num_movimentacao
WHERE
    DM.nom_tipo_movimentacao = 'CADASTRO'
GROUP BY
    mes_oferta_inicial
ORDER BY
    mes_oferta_inicial DESC;


-- Valor Total Avaliado por Cidade
SELECT
    DL.nom_cidade,
    DL.sig_estado,
    SUM(FV.val_avaliacao) AS val_total_avaliacao_cidade
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
GROUP BY
    DL.nom_cidade,
    DL.sig_estado
ORDER BY
    val_total_avaliacao_cidade DESC
LIMIT 15;



-- Imóveis Cujo Preço de Avaliação é Muito Superior à Média do Bairro

WITH BairroMedia AS (
    SELECT
        DL.nom_bairro,
        AVG(FV.val_avaliacao) AS media_avaliacao_bairro
    FROM
        dw.Fato_VendaImovel FV
    INNER JOIN
        dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
    GROUP BY
        DL.nom_bairro
)
SELECT
    DI.num_imovel,
    DL.nom_bairro,
    FV.val_avaliacao,
    BM.media_avaliacao_bairro,
    (FV.val_avaliacao / BM.media_avaliacao_bairro) AS fator_acima_media
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
INNER JOIN
    dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
INNER JOIN
    BairroMedia BM ON DL.nom_bairro = BM.nom_bairro
WHERE
    FV.val_avaliacao > (BM.media_avaliacao_bairro * 1.5) 
ORDER BY
    fator_acima_media DESC
LIMIT 10;


-- Análise de Atributos de Venda por Modalidade
SELECT
    DI.nom_modalidade_venda,
    DM.nom_tipo_movimentacao,
    DM.dsc_de AS status_anterior,
    DM.dsc_para AS status_atual,
    COUNT(FV.num_venda_imovel) AS qtd_movimentacoes
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
INNER JOIN
    dw.Dim_Movimentacao DM ON FV.fk_num_movimentacao = DM.num_movimentacao
WHERE
    DM.nom_tipo_movimentacao <> 'CADASTRO'
GROUP BY
    1, 2, 3, 4
ORDER BY
    qtd_movimentacoes DESC;


-- Valor Médio de Avaliação em Imóveis com Alta Descrição
SELECT
    CASE
        WHEN LENGTH(DI.dsc) > 200 THEN 'Descrição Longa'
        WHEN LENGTH(DI.dsc) > 100 THEN 'Descrição Média'
        ELSE 'Descrição Curta'
    END AS categoria_descricao,
    AVG(FV.val_avaliacao) AS val_medio_avaliacao,
    AVG(FV.val_desconto) AS pct_medio_desconto
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
GROUP BY
    categoria_descricao
ORDER BY
    val_medio_avaliacao DESC;


-- Listagem de Imóveis Mais Baratos por Estado
SELECT
    DL.sig_estado,
    DI.num_imovel,
    FV.val_avaliacao AS valor_avaliacao,
    FV.val_desconto AS pct_desconto,
    DL.nom_cidade
FROM
    dw.Fato_VendaImovel FV
INNER JOIN
    dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
INNER JOIN
    dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
ORDER BY
    DL.sig_estado, valor_avaliacao ASC
LIMIT 20;


--  Listagem de Imóveis com Maior Desconto por ESTADO
WITH RankeamentoEstado AS (
    SELECT
        DL.sig_estado,
        DI.num_imovel,
        FV.val_avaliacao,
        FV.val_desconto,
        DL.nom_cidade,
        DL.nom_endereco,
        ROW_NUMBER() OVER (
            PARTITION BY DL.sig_estado 
            ORDER BY FV.val_desconto DESC
        ) AS ranking_desconto_estado
    FROM
        dw.Fato_VendaImovel FV
    INNER JOIN
        dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
    INNER JOIN
        dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
)
SELECT
    sig_estado,
    num_imovel,
    val_avaliacao,
    val_desconto,
    nom_cidade,
    nom_endereco
FROM
    RankeamentoEstado
WHERE
    ranking_desconto_estado = 1
ORDER BY
    sig_estado, val_desconto DESC;



-- Listagem de Imóveis com Maior Desconto por CIDADE

WITH RankeamentoCidade AS (
    SELECT
        DL.nom_cidade,
        DL.sig_estado,
        DI.num_imovel,
        FV.val_avaliacao,
        FV.val_desconto,
        DL.nom_endereco,
        ROW_NUMBER() OVER (
            PARTITION BY DL.nom_cidade 
            ORDER BY FV.val_desconto DESC
        ) AS ranking_desconto_cidade
    FROM
        dw.Fato_VendaImovel FV
    INNER JOIN
        dw.DIM_Localizacao DL ON FV.fk_num_localizacao = DL.num_localizacao
    INNER JOIN
        dw.Dim_Imovel DI ON FV.fk_num_imovel = DI.num_imovel
)
SELECT
    nom_cidade,
    sig_estado,
    num_imovel,
    val_avaliacao,
    val_desconto,
    nom_endereco
FROM
    RankeamentoCidade
WHERE
    ranking_desconto_cidade = 1
ORDER BY
    nom_cidade, val_desconto DESC;