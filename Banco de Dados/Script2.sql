DROP DATABASE Fornecedores;
CREATE DATABASE Fornecedores;
USE Fornecedores;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema sakila
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor` (
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
  PRIMARY KEY (`idFornecedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Empresa` (
  `idSolicitacao` INT NOT NULL AUTO_INCREMENT,
  `nomeEmpresa` VARCHAR(65) NULL,
  `CNPJ` VARCHAR(45) NULL,
  PRIMARY KEY (`idSolicitacao`))
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
  `status` ENUM('ABERTA', 'A AVALIAR', 'FECHADA') NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idSolicitacao`, `fkEmpresa`),
  INDEX `fk_Solicitacao_Empresa1_idx` (`fkEmpresa` ASC),
  CONSTRAINT `fk_Solicitacao_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idSolicitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proposta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proposta` (
  `idProposta` INT NOT NULL AUTO_INCREMENT,
  `fkFornecedor` INT NOT NULL,
  `fkSolicitacao` INT NOT NULL,
  `nome` VARCHAR(80) NULL,
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
-- Table `Avaliacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Avaliacao` (
  `idAvaliacao` INT NOT NULL AUTO_INCREMENT,
  `fkProposta` INT NOT NULL,
  `comentario` VARCHAR(255) NULL,
  `nota` DECIMAL(2,1) NULL,
  PRIMARY KEY (`idAvaliacao`, `fkProposta`),
  INDEX `fk_Avaliacao_Proposta1_idx` (`fkProposta` ASC),
  CONSTRAINT `fk_Avaliacao_Proposta1`
    FOREIGN KEY (`fkProposta`)
    REFERENCES `Proposta` (`idProposta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AdminUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AdminUser` (
  `idAdminUser` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(65) NULL,
  `email` VARCHAR(45) NULL,
  `senha` VARCHAR(45) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idAdminUser`, `fkEmpresa`),
  INDEX `fk_AdminUser_Empresa1_idx` (`fkEmpresa` ASC),
  CONSTRAINT `fk_AdminUser_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idSolicitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EmpresaReferencias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EmpresaReferencias` (
  `idReferencias` INT NOT NULL AUTO_INCREMENT,
  `Empresa` VARCHAR(70) NULL,
  PRIMARY KEY (`idReferencias`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FornecedorReferencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FornecedorReferencia` (
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
    REFERENCES `EmpresaReferencias` (`idReferencias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

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

truncate table Proposta;
truncate table Fornecedor;