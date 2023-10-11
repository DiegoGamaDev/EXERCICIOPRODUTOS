-- INICIO DA CRIAÇAO DA TABELA E INSERCAO DE DADOS

CREATE TABLE marcas(
mrc_id int auto_increment primary key,
mrc_nome varchar(50) not null,
mrc_nacionalidade varchar(50)
);

INSERT INTO marcas(mrc_nome,mrc_nacionalidade) VALUES ('Seara','Brasil');
INSERT INTO marcas(mrc_nome,mrc_nacionalidade) VALUES ('Sadia','Brasil');
INSERT INTO marcas(mrc_nome,mrc_nacionalidade) VALUES ('Perdigao','Brasil');


CREATE TABLE produtos(
prd_id int auto_increment primary key,
prd_nome varchar(50) not null,
prd_qtd_estoque int not null default 0,
prd_qtd_estoque_min int not null default 0,
prd_data_fabricacao timestamp default now(),
prd_perecivel boolean,
prd_valor decimal(10,2),
prd_marca_id int,
constraint fk_marcas foreign key (prd_marca_id) references marcas(mrc_id)
);

INSERT INTO produtos VALUES (1,'Mortadela',10,3,'2023-01-01',true,8.99,1,'2023-05-30');
INSERT INTO produtos VALUES (2,'Presunto',10,3,'2023-01-01',true,7.99,1,'2023-05-30');
INSERT INTO produtos VALUES (3,'Peito de Peru',10,3,'2023-01-01',true,12.99,1,'2023-05-30');

CREATE TABLE fornecedores( 
frn_id int auto_increment primary key,
frn_nome varchar(50) not null,
frn_email varchar(50)
);

INSERT INTO fornecedores (frn_nome,frn_email) VALUES ('Facens Frios', 'fcns@facens.br');
INSERT INTO fornecedores (frn_nome,frn_email) VALUES ('UNIP Frios', 'unpfrios@unipfrios.br');
INSERT INTO fornecedores (frn_nome,frn_email) VALUES ('Facens Frios', 'fcns@facens.br');


CREATE TABLE produto_fornecedor(
pf_prod_id int references produtos (prd_id),
pf_forn_id int references fornecedores (frn_id),
primary key (pf_prod_id, pf_forn_id)
);

-- FINAL DA CRIAÇAO DE TABELAS E INSERCAO DE DADOS

-- Criacao de uma view que mostra todos os produtos e suas respectivas marcas
CREATE VIEW Produtos_Marcas as
SELECT produtos.prd_nome 'Produto' , mrc_nome 'Marca'
FROM produtos
JOIN marcas on produtos.prd_marca_id = marcas.mrc_id;


-- Criacao de uma view que mostra todos os produtos e seus respectivos fornecedores
CREATE VIEW Produtos_Fornecedores as
SELECT produtos.prd_id 'ID' , produtos.prd_nome 'Produto', fornecedores.frn_nome 'Fornecedor'
FROM produtos
JOIN produto_fornecedor ON produtos.prd_id = produto_fornecedor.pf_prod_id
JOIN fornecedores ON produto_fornecedor.pf_forn_id = fornecedores.frn_id;


-- Criacao de uma view que mostra todos os produtos e seus respectivos fornecedores e marcas
CREATE VIEW Produtos_Fornecedores_Marcas as
SELECT produtos.prd_id 'ID', produtos.prd_nome 'Produto', fornecedores.frn_nome 'Fornecedor', marcas.mrc_nome 'Marca'
FROM produtos
JOIN produto_fornecedor ON produtos.prd_id = produto_fornecedor.pf_prod_id
JOIN fornecedores ON produto_fornecedor.pf_forn_id = fornecedores.frn_id
JOIN marcas ON produtos.prd_marca_id = marcas.mrc_id;


-- Criacao de uma view que mostra todos os produtos com estoque abaixo do mínimo
CREATE VIEW Produtos_Estoque_Abaixo_Do_Minimo as
SELECT prd_id 'ID' , prd_nome 'Nome' , prd_qtd_estoque'Estoque'
FROM produtos
WHERE prd_qtd_estoque < prd_qtd_estoque_min;


-- Criacao de um campo data de validade e insercao de novos dados
ALTER TABLE produtos ADD COLUMN prd_validade date; 
INSERT INTO produtos VALUES (4,'Rosbife',10,3,'2023-01-01',true,9.99,1,'2023-05-30');


-- Criacao de uma view que mostra todos os produtos e suas respectivas marcas com validade vencida
CREATE VIEW ProdutosComValidadeVencida AS
SELECT produtos.prd_nome AS Produto, marcas.mrc_nome AS Marca, produtos.prd_validade AS Data_Validade
FROM produtos
JOIN marcas ON produtos.prd_marca_id = marcas.mrc_id
WHERE produtos.prd_validade < '2023-10-11';


-- Selecionar os produtos com preço acima da média.
SELECT prd_nome, prd_valor FROM produtos WHERE prd_valor > (SELECT AVG(prd_valor) FROM produtos);


