DROP DATABASE Fornecedores;
CREATE DATABASE Fornecedores;
USE Fornecedores;

CREATE TABLE `Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `empresa` VARCHAR(70) NULL,
  `endereco` VARCHAR(130) NULL,
  `cep` CHAR(8) NULL,
  `cnpj` VARCHAR(18) NULL,
  `email` VARCHAR(45) NULL,
  `telefone` VARCHAR(15) NULL,
  `banco` VARCHAR(45) NULL,
  `recorrente` TINYINT(1) NULL,
  `anosExperiencia` INT NULL,
  PRIMARY KEY (`idFornecedor`)
  );


CREATE TABLE `Empresa` (
  `idEmpresa` INT NOT NULL AUTO_INCREMENT,
  `nomeEmpresa` VARCHAR(65) NULL,
  `CNPJ` VARCHAR(45) NULL,
  PRIMARY KEY (`idEmpresa`)
  );


CREATE TABLE `Solicitacao` (
  `idSolicitacao` INT NOT NULL AUTO_INCREMENT,
  `item` VARCHAR(45) NULL,
  `especificacao` VARCHAR(70) NULL,
  `qtdTotal` INT NULL,
  `dtAbertura` DATE NULL,
  `dtEncerramento` DATE NULL,
  `status` ENUM('ABERTA', 'A AVALIAR', 'FECHADA') NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idSolicitacao`, `fkEmpresa`),
  FOREIGN KEY (`fkEmpresa`)
  REFERENCES `Empresa` (`idEmpresa`)
  );


CREATE TABLE `Proposta` (
  `idProposta` INT NOT NULL AUTO_INCREMENT,
  `fkFornecedor` INT NOT NULL,
  `fkSolicitacao` INT NOT NULL,
  `nome` VARCHAR(80) NULL,
  `dtEntrega` DATE NULL,
  `valorTotal` DECIMAL(12,2) NULL,
  `escolhido` TINYINT(1) NULL,
  PRIMARY KEY (`idProposta`, `fkFornecedor`, `fkSolicitacao`),
  FOREIGN KEY (`fkFornecedor`)
  REFERENCES `Fornecedor` (`idFornecedor`),
  FOREIGN KEY (`fkSolicitacao`)
  REFERENCES `Solicitacao` (`idSolicitacao`)
  );


CREATE TABLE `AdminUser` (
  `idAdminUser` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(65) NULL,
  `email` VARCHAR(45) NULL,
  `senha` VARCHAR(45) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idAdminUser`, `fkEmpresa`),
  FOREIGN KEY (`fkEmpresa`)
  REFERENCES `Empresa` (`idEmpresa`)
);


CREATE TABLE `Avaliacao` (
  `idAvaliacao` INT NOT NULL AUTO_INCREMENT,
  `fkProposta` INT NOT NULL,
  `comentario` VARCHAR(255) NULL,
  `nota` DECIMAL(2,1) NULL,
  `fkAdminUser` INT NOT NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idAvaliacao`, `fkProposta`),
  FOREIGN KEY (`fkProposta`)
  REFERENCES `Proposta` (`idProposta`),
  FOREIGN KEY (`fkAdminUser`)
  REFERENCES `AdminUser` (`idAdminUser`),
  FOREIGN KEY (`fkEmpresa`)
  REFERENCES `Empresa` (`idEmpresa`)
);


CREATE TABLE `EmpresaReferencias` (
  `idReferencias` INT NOT NULL AUTO_INCREMENT,
  `Empresa` VARCHAR(70) NULL,
  PRIMARY KEY (`idReferencias`)
);


CREATE TABLE `FornecedorReferencia` (
  `fkFornecedor` INT NOT NULL,
  `fkReferencias` INT NOT NULL,
  `item` VARCHAR(45) NULL,
  `comentario` VARCHAR(255) NULL,
  `dtServico` DATE NULL,
  PRIMARY KEY (`fkFornecedor`, `fkReferencias`),
  FOREIGN KEY (`fkFornecedor`)
  REFERENCES `Fornecedor` (`idFornecedor`),
  FOREIGN KEY (`fkReferencias`)
  REFERENCES `EmpresaReferencias` (`idReferencias`)
);

INSERT INTO Fornecedor VALUES (null,'Bem Brasil','Rua das Flores, 123','12345678','12.345.678/0001-90','contato@bembrasil.com.br','1234-5678','Banco do Brasil',1,10),
                              (null,'Aulus compra e venda','Avenida Brasil, 456','23456789','23.456.789/0001-90','contato@aulus.com.br','2345-6789','Bradesco',0,5),
                              (null,'NFT Tech','Praça da Sé, 789','34567890','34.567.890/0001-90','contato@nfttech.com.br','3456-7890','Itaú',1,8),
                              (null,'Tech Supplies','Rua dos Andrades, 321','54321678','45.678.912/0001-56','contato@techsupplies.com.br','4321-5678','Santander',1,12),
                              (null,'Office Equipments','Avenida Paulista, 789','65432189','56.789.123/0001-67','contato@officeequipments.com.br','5432-6789','Caixa Econômica',0,7),
                              (null,'Modern Solutions','Praça da Liberdade, 654','76543210','67.891.234/0001-78','contato@modernsolutions.com.br','6543-7890','HSBC',1,15);

INSERT INTO Empresa values (null, 'Banco Arbi', '11.111.111/0001-11'),
                           (null, 'Sptech', '22.222.222/0001-22'),
                           (null, 'Jazz Tech', '33.333.333/0001-33'),
                           (null, 'TechCorp', '44.444.444/0001-44'),
                           (null, 'Innovatech', '55.555.555/0001-55'),
                           (null, 'Creative Solutions', '66.666.666/0001-66');

INSERT INTO Solicitacao values (null, 'Cadeira', 'Amarela', 100, '2024-06-01',null, 'ABERTA', 1),
                               (null, 'Mesa', 'Cinza', 200, '2024-06-02','2024-06-16','A AVALIAR', 2),
                               (null, 'Monitor', '144Hz', 150, '2024-06-03','2024-06-17','FECHADA', 3),
                               (null, 'Teclado', 'Mecânico RGB', 80, '2024-06-05',null,'ABERTA', 4),
                               (null, 'Mouse', 'Ergonômico', 150, '2024-06-06','2024-06-21','A AVALIAR', 5),
                               (null, 'Webcam', 'HD 1080p', 150, '2024-06-07','2024-06-22','FECHADA', 6);

INSERT INTO Proposta VALUES (null,1,1,'proposta-exemplo1.pdf','2024-06-10',5000.00,0),
                            (null,2,2,'proposta-exemplo2.pdf','2024-06-12',10000.00,1),
                            (null,3,3,'proposta-exemplo3.pdf','2024-06-15',7500.00,1),
                            (null,4,4,'proposta-exemplo4.pdf','2024-06-15',7500.00,0),
                            (null,5,5,'proposta-exemplo5.pdf','2024-06-15',7500.00,1),
                            (null,6,6,'proposta-exemplo6.pdf','2024-06-15',7500.00,1);

INSERT INTO AdminUser values (null,'Lucas Navasconi','lucas.navasconi@sptech.school','senha123',1),
                             (null,'Thiago Bonacelli','thiago.bonacelli@sptech.school','senhaForte123',2),
                             (null,'Gabriel Bordin','gabriel.bordin@sptech.school','senha987',3),
                             (null,'Ana Silva','ana.silva@techcorp.com','senha1234',4),
                             (null,'Carlos Pereira','carlos.pereira@innovatech.com','senhaForte456',5),
                             (null,'Mariana Souza','mariana.souza@creativesolutions.com','senha789',6);

INSERT INTO EmpresaReferencias VALUES (null, 'Google'),
                                    (null, 'Apple'),
                                    (null, 'Microsoft'),
                                    (null, 'Amazon'),
                                    (null, 'Facebook'),
                                    (null, 'Tesla');

INSERT INTO FornecedorReferencia VALUES (1,1,'Cadeira','Serviço prestado com excelência.','2023-05-01'),
                                        (2,2,'Mesa','Entrega no prazo e qualidade esperada.','2023-06-01'),
                                        (3,3,'Monitor','Bom atendimento e suporte.','2023-07-01'),
                                        (4,4,'Teclado','Produto de alta qualidade e entrega rápida.','2023-08-01'),
                                        (5,5,'Mouse','Excelente ergonomia e durabilidade.','2023-09-01'),
                                        (6,6,'Webcam','Imagem clara e ótima resolução.','2023-10-01');

select * from Avaliacao;

select * from Fornecedor;
select * from Empresa;
select * from Solicitacao;
select * from FornecedorReferencia;
select * from Proposta;
select * from EmpresaReferencias;
select * from AdminUser;