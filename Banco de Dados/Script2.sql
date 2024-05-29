DROP DATABASE Fornecedores;
CREATE DATABASE Fornecedores;
USE Fornecedores;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Table `Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor` (
  `idFornecedor` INT NOT NULL,
  `empresa` VARCHAR(70) NULL,
  `endereco` VARCHAR(130) NULL,
  `cep` CHAR(8) NULL,
  `cnpj` VARCHAR(18) NULL,
  `email` VARCHAR(45) NULL,
  `telefone` VARCHAR(15) NULL,
  `banco` VARCHAR(45) NULL,
  `recorrente` TINYINT(1) NULL,
  `anosExperiencia` INT NULL,
  PRIMARY KEY (`idFornecedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Solicitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Solicitacao` (
  `idSolicitacao` INT NOT NULL AUTO_INCREMENT,
  `item` VARCHAR(45) NULL,
  `especificacao` VARCHAR(70) NULL,
  `qtdTotal` INT NULL,
  `dtAbertura` DATE NULL,
  `dtEncerramento` DATE NULL,
  `status` ENUM ('ABERTA','A AVALIAR','FECHADA'),
  PRIMARY KEY (`idSolicitacao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proposta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proposta` (
  `idProposta` INT NOT NULL,
  `fkFornecedor` INT NOT NULL,
  `fkSolicitacao` INT NOT NULL,
  `dtEntrega` DATE NULL,
  `valorTotal` DECIMAL(12,2) NULL,
  `escolhido` TINYINT(1) NULL,
  PRIMARY KEY (`idProposta`, `fkFornecedor`, `fkSolicitacao`),
  INDEX `fk_Proposta_Fornecedor1_idx` (`fkFornecedor` ASC),
  INDEX `fk_Proposta_Solicitacao1_idx` (`fkSolicitacao` ASC),
  CONSTRAINT `fk_Proposta_Fornecedor1`
    FOREIGN KEY (`fkFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proposta_Solicitacao1`
    FOREIGN KEY (`fkSolicitacao`)
    REFERENCES `Solicitacao` (`idSolicitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AdminUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AdminUser` (
  `idAdminUser` INT NOT NULL,
  `nome` VARCHAR(65) NULL,
  `email` VARCHAR(45) NULL,
  `senha` VARCHAR(45) NULL,
  PRIMARY KEY (`idAdminUser`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Avaliacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Avaliacao` (
  `idAvaliacao` INT NOT NULL,
  `fkProposta` INT NOT NULL,
  `fkAdmin` INT NOT NULL,
  `comentario` VARCHAR(255) NULL,
  `nota` DECIMAL(2,1) NULL,
  PRIMARY KEY (`idAvaliacao`, `fkProposta`, `fkAdmin`),
  INDEX `fk_Avaliacao_Proposta1_idx` (`fkProposta` ASC),
  INDEX `fk_Avaliacao_AdminUser1_idx` (`fkAdmin` ASC),
  CONSTRAINT `fk_Avaliacao_Proposta1`
    FOREIGN KEY (`fkProposta`)
    REFERENCES `Proposta` (`idProposta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Avaliacao_AdminUser1`
    FOREIGN KEY (`fkAdmin`)
    REFERENCES `AdminUser` (`idAdminUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Referencias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Referencias` (
  `idReferencias` INT NOT NULL,
  `Empresa` VARCHAR(70) NULL,
  PRIMARY KEY (`idReferencias`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ServicosReferencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ServicosReferencia` (
  `fkFornecedor` INT NOT NULL,
  `fkReferencias` INT NOT NULL,
  `item` VARCHAR(45) NULL,
  `comentario` VARCHAR(255) NULL,
  `dtServico` DATE NULL,
  PRIMARY KEY (`fkFornecedor`, `fkReferencias`),
  INDEX `fk_Fornecedor_has_Referencias_Referencias1_idx` (`fkReferencias` ASC),
  INDEX `fk_Fornecedor_has_Referencias_Fornecedor1_idx` (`fkFornecedor` ASC),
  CONSTRAINT `fk_Fornecedor_has_Referencias_Fornecedor1`
    FOREIGN KEY (`fkFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Referencias_Referencias1`
    FOREIGN KEY (`fkReferencias`)
    REFERENCES `Referencias` (`idReferencias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


INSERT INTO Solicitacao values (1, 'Cadeira', 'Preta de couro com 33cm de altura', 30, '2024-04-23',null, 'EM ABERTO'),
(2, 'Mesa', 'Branca de madeira com 50cm de altura', 10, '2024-05-10',null,'EM ABERTO'), 
(3, 'Lapiseira', 'Grafite 0.8', 150, '2024-05-20',null,'EM ABERTO');

INSERT INTO adminuser values (1, 'Renato Tierno', 'renato.tierno@sptech.school', 'estagc6bank'),
(2, 'Júlia Araripe', 'julia.lopes@sptech.school', 'estagsptech'), 
(3, 'Marco Campos', 'marco.cjr@sptech.school', 'estaghpe');

SELECT * FROM adminuser;
SELECT * FROM Solicitacao;
SELECT * FROM Proposta;

SELECT idAdminUser, nome, email from AdminUser WHERE email = 'renato.tierno@sptech.school'AND senha = 'estagc6bank';

INSERT INTO FORNECEDOR VALUES (1, 'Bananinha tech','RUA DRAVA 77', '04283000', '48693707000157', 'bananinha@gmail.com', '11989437596', 'C6 BANK', TRUE, 2);

INSERT INTO Proposta VALUES (1, 1, 1, '2024-05-23', 5000.0, false);

SELECT * FROM Solicitacao where status = 'EM ABERTO';

DELETE FROM Solicitacao where idSolicitacao = 6;

DELETE FROM PROPOSTA WHERE fkSolicitacao = 1;