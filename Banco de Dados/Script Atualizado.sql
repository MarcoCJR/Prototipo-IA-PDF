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
  `idSolicitacao` INT NOT NULL AUTO_INCREMENT,
  `nomeEmpresa` VARCHAR(65) NULL,
  `CNPJ` VARCHAR(45) NULL,
  PRIMARY KEY (`idSolicitacao`)
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
  REFERENCES `Empresa` (`idSolicitacao`)
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
  REFERENCES `Empresa` (`idSolicitacao`)
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
  REFERENCES `Empresa` (`idSolicitacao`)
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


INSERT INTO Empresa values (null, 'Empresa 1', '123.456.789/100133'),
                           (null, 'Empresa 2', '176.986.995/999122'),
                           (null, 'Empresa 3', '872.324.567/227322');

INSERT INTO AdminUser values (null, 'Renato Tierno', 'renato.tierno@sptech.school', 'estagc6bank', 1),
                             (null, 'Júlia Araripe', 'julia.lopes@sptech.school', 'estagsptech', 1),
                             (null, 'Marco Campos', 'marco.cjr@sptech.school', 'estaghpe', 2);

INSERT INTO Solicitacao values (null, 'Cadeira', 'Preta de couro com 33cm de altura', 30, '2024-04-23',null, 'ABERTA', 1),
                               (null, 'Mesa', 'Branca de madeira com 50cm de altura', 10, '2024-05-10',null,'ABERTA', 1),
                               (null, 'Lapiseira', 'Grafite 0.8', 150, '2024-05-20',null,'ABERTA', 3);

select * from Proposta;
select * from Fornecedor;