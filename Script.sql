DROP DATABASE Fornecedores;

CREATE DATABASE Fornecedores;
USE Fornecedores;

CREATE TABLE IF NOT EXISTS `Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `empresa` VARCHAR(70) NULL,
  `endereco` VARCHAR(130) NULL,
  `cep` VARCHAR(10) NULL,
  `email` VARCHAR(60) NULL,
  `telefone` VARCHAR(30) NULL,
  `banco` VARCHAR(45) NULL,
  `nomeCompleto` VARCHAR(80) NULL,
  PRIMARY KEY (`idFornecedor`)
);

CREATE TABLE IF NOT EXISTS `Proposta` (
  `idProposta` INT NOT NULL AUTO_INCREMENT,
  `fkFornecedor` INT NOT NULL,
  `item` VARCHAR(45) NULL,
  `especificacao` VARCHAR(70) NULL,
  `unidade` VARCHAR(15) NULL,
  `qtdTotal` INT NULL,
  `valorTotal` VARCHAR(12) NULL,
  PRIMARY KEY (`idProposta`, `fkFornecedor`),
    FOREIGN KEY (`fkFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
);

CREATE TABLE IF NOT EXISTS `Avaliacao` (
  `idAvaliacao` INT NOT NULL AUTO_INCREMENT,
  `fkProposta` INT NOT NULL,
  `avaliador` VARCHAR(45) NULL,
  `comentario` VARCHAR(120) NULL,
  `nota` INT NULL,
  PRIMARY KEY (`idAvaliacao`, `fkProposta`),
    FOREIGN KEY (`fkProposta`)
    REFERENCES `Proposta` (`idProposta`)
);

INSERT INTO Fornecedor VALUES(
null, "Bananinha Tech", "Haddock Lobo, 505", "03077000", "bananinha@gmail.com", "11940273200", "C6Bank", "Renato Tierno");

INSERT INTO Proposta VALUES(
null, 1, "Cadeira Preta", "Cadeira de escritório da cor preta", "Unidade", 30, "6000.50");

INSERT INTO Avaliacao VALUES(
null, 1, "João Jão", "Muito boa", 5);

SELECT * FROM Fornecedor;
SELECT * FROM Proposta;
SELECT * FROM Avaliacao;