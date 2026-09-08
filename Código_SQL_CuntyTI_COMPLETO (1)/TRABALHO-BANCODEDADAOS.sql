-- ===========================================================================
-- SCRIPT SQL COMPLETO DA EMPRESA CUNTY TI - TRABALHO PRÁTICO - BANCO DE DADOS
-- ===========================================================================

-- --------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (a) - IMPLEMENTAÇÃO DE TODAS AS TABELAS E RELAÇÃO DE INTEGRIDADE
-- =========================================================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cuntyti
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS cuntyti;
CREATE SCHEMA IF NOT EXISTS `cuntyti` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `cuntyti` ;

-- DESLIGA A TRAVA DE SEGURANÇA GLOBALMENTE PARA EVITAR O ERRO 1175
SET SQL_SAFE_UPDATES = 0; 

-- -----------------------------------------------------
-- Table `cuntyti`.`beneficio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`beneficio` (
  `idBeneficio` INT NOT NULL AUTO_INCREMENT,
  `nomeBeneficio` VARCHAR(40) NOT NULL,
  `tipo` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`idBeneficio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`departamento` (
  `idDepartamento` INT NOT NULL AUTO_INCREMENT,
  `nomeDepartamento` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idDepartamento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`funcionario` (
  `idFuncionario` INT NOT NULL AUTO_INCREMENT,
  `cpf` CHAR(11) NOT NULL,
  `nomeSocial` VARCHAR(80) NOT NULL,
  `logradouro` VARCHAR(40) NOT NULL,
  `numero` INT NOT NULL,
  `bairro` VARCHAR(30) NULL DEFAULT NULL,
  `cidade` VARCHAR(30) NOT NULL,
  `estado` CHAR(2) NOT NULL,
  `cep` CHAR(8) NOT NULL,
  `sexo` CHAR(1) NOT NULL,
  `status` CHAR(1) NOT NULL,
  `dataAdmissao` DATE NOT NULL,
  `dataNas` DATE NOT NULL,
  `telefone` CHAR(9) NULL DEFAULT NULL,
  `departamento_idDepartamento` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC),
  INDEX `fk_funcionario_departamento1_idx` (`departamento_idDepartamento` ASC),
  CONSTRAINT `fk_funcionario_departamento1`
    FOREIGN KEY (`departamento_idDepartamento`)
    REFERENCES `cuntyti`.`departamento` (`idDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`clt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`clt` (
  `idFuncionario` INT AUTO_INCREMENT NOT NULL,
  `carteiraTrabalho` VARCHAR(20) NOT NULL,
  `fgts` VARCHAR(20) NOT NULL,
  `funcionario_idFuncionario` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`, `funcionario_idFuncionario`),
  INDEX `fk_clt_funcionario1_idx` (`funcionario_idFuncionario` ASC),
  CONSTRAINT `fk_clt_funcionario1`
    FOREIGN KEY (`funcionario_idFuncionario`)
    REFERENCES `cuntyti`.`funcionario` (`idFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`clt_beneficio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`clt_beneficio` (
  `idFuncionario` INT NOT NULL,
  `idBeneficio` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`, `idBeneficio`),
  INDEX `fk_cb_beneficio` (`idBeneficio` ASC),
  CONSTRAINT `fk_cb_beneficio`
    FOREIGN KEY (`idBeneficio`)
    REFERENCES `cuntyti`.`beneficio` (`idBeneficio`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cb_clt`
    FOREIGN KEY (`idFuncionario`)
    REFERENCES `cuntyti`.`clt` (`idFuncionario`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`dependente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`dependente` (
  `nome` VARCHAR(80) NOT NULL,
  `parentesco` VARCHAR(20) NOT NULL,
  `dataNascimento` DATE NOT NULL,
  `sexo` CHAR(1) NOT NULL,
  `clt_idFuncionario` INT NOT NULL,
  PRIMARY KEY (`clt_idFuncionario`, `nome`),
  INDEX `fk_dependente_clt1_idx` (`clt_idFuncionario` ASC),
  CONSTRAINT `fk_dependente_clt1`
    FOREIGN KEY (`clt_idFuncionario`)
    REFERENCES `cuntyti`.`clt` (`idFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`estagiario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`estagiario` (
  `idFuncionario` INT AUTO_INCREMENT NOT NULL,
  `curso` VARCHAR(60) NOT NULL,
  `cargaHoraria` INT NOT NULL,
  `universidade` VARCHAR(60) NOT NULL,
  `funcionario_idFuncionario` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`, `funcionario_idFuncionario`),
  INDEX `fk_estagiario_funcionario1_idx` (`funcionario_idFuncionario` ASC),
  CONSTRAINT `fk_estagiario_funcionario1`
    FOREIGN KEY (`funcionario_idFuncionario`)
    REFERENCES `cuntyti`.`funcionario` (`idFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`estagiario_beneficio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`estagiario_beneficio` (
  `idFuncionario` INT NOT NULL,
  `idBeneficio` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`, `idBeneficio`),
  INDEX `fk_eb_beneficio` (`idBeneficio` ASC),
  CONSTRAINT `fk_eb_beneficio`
    FOREIGN KEY (`idBeneficio`)
    REFERENCES `cuntyti`.`beneficio` (`idBeneficio`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_eb_estagiario`
    FOREIGN KEY (`idFuncionario`)
    REFERENCES `cuntyti`.`estagiario` (`idFuncionario`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`pj`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`pj` (
  `idFuncionario` INT AUTO_INCREMENT NOT NULL,
  `razaoSocial` VARCHAR(80) NOT NULL,
  `funcionario_idFuncionario` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`, `funcionario_idFuncionario`),
  INDEX `fk_pj_funcionario1_idx` (`funcionario_idFuncionario` ASC),
  CONSTRAINT `fk_pj_funcionario1`
    FOREIGN KEY (`funcionario_idFuncionario`)
    REFERENCES `cuntyti`.`funcionario` (`idFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`salario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`salario` (
  `holerite` INT AUTO_INCREMENT NOT NULL,
  `dataPagamento` DATE NOT NULL,
  `valorBruto` DECIMAL(10,2) NOT NULL,
  `desconto` DECIMAL(10,2) NOT NULL,
  `valorLiquido` DECIMAL(10,2) NOT NULL,
  `funcionario_idFuncionario` INT NOT NULL,
  PRIMARY KEY (`holerite`, `funcionario_idFuncionario`),
  INDEX `fk_salario_funcionario1_idx` (`funcionario_idFuncionario` ASC),
  CONSTRAINT `fk_salario_funcionario1`
    FOREIGN KEY (`funcionario_idFuncionario`)
    REFERENCES `cuntyti`.`funcionario` (`idFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Table `cuntyti`.`servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cuntyti`.`servico` (
  `idServico` INT AUTO_INCREMENT NOT NULL,
  `idFuncionario` INT NOT NULL,
  `descricao` VARCHAR(100) NOT NULL,
  `valorContrato` DECIMAL(10,2) NOT NULL,
  `prazoEntrega` DATE NOT NULL,
  PRIMARY KEY (`idServico`),
  INDEX `fk_servico_pj` (`idFuncionario` ASC),
  CONSTRAINT `fk_servico_pj`
    FOREIGN KEY (`idFuncionario`)
    REFERENCES `cuntyti`.`pj` (`idFuncionario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- --------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (b) - IMPLEMENTAÇÃO DE ALTER TABLE E DROP TABLE
-- =========================================================================

USE cuntyti;

-- ALTER 1 — adicionar coluna
ALTER TABLE funcionario ADD COLUMN email VARCHAR(80) NULL;

-- ALTER 2 — alterar a definição de uma coluna
ALTER TABLE funcionario MODIFY COLUMN telefone VARCHAR(15) NULL;

-- ALTER 3 — adicionar restrição (Garante que o salário não seja zero ou negativo)
ALTER TABLE salario ADD CONSTRAINT chk_salario_bruto CHECK (valorBruto > 0);

-- ALTER 4 — remover coluna (Remove o campo criado no ALTER 1 para limpar a tabela)
ALTER TABLE funcionario DROP COLUMN email;

-- Tabela extra + DROP TABLE
CREATE TABLE tabela_exemplo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    texto VARCHAR(50)
);

DROP TABLE tabela_exemplo; 

-- =========================================================================
-- COMANDOS EXTRAS NECESSÁRIOS DA LETRA B:
-- =========================================================================

-- 1) ALTER TABLE funcionario MODIFY COLUMN telefone CHAR(9) NULL; (Alterar novamente à configuração padrão de 9 caracteres)
-- 2) ALTER TABLE salario DROP CONSTRAINT chk_salario_bruto; (Remover a restrição acima de checar o salário)
-- 3) ALTER TABLE funcionario DROP COLUMN email; (Usufruir à parte para remover a coluna email em caso de erros)
-- 4) DROP TABLE IF EXISTS tabela_exemplo; (Usufruir à parte para remover a tabela de exemplo em caso de erros com mais segurança)

-- ------------------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (c) - INSERÇÃO DE DADOS (EM CADA TABELA)
-- =========================================================================

USE cuntyti;

-- 1. TABELA: departamento 
-- Inserindo com IDs explicitos para garantir a integridade
INSERT INTO departamento (idDepartamento, nomeDepartamento) VALUES
(1, 'TI'),
(2, 'Recursos Humanos'),
(3, 'Financeiro'),
(4, 'Comercial'),
(5, 'Juridico');
-- Nota: idDepartamento será gerado automaticamente de 1 a 5.

-- 2. TABELA: beneficio
-- Inserindo com IDs explicitos para garantir a integridade
INSERT INTO beneficio (idBeneficio, nomeBeneficio, tipo) VALUES
(1, 'Plano de Saude', 'Saude'),
(2, 'Vale-Refeicao', 'Alimentacao'),
(3, 'Vale-Transporte', 'Transporte'),
(4, 'Seguro de Vida', 'Seguro'),
(5, 'Auxilio Creche', 'Familia'),
(6, 'Gympass', 'Bem-estar');
-- Nota: idBeneficio será gerado automaticamente de 1 a 6.

-- 3. TABELA: funcionario
-- Inserindo com IDs explicitos para garantir a integridade
INSERT INTO funcionario 
(idFuncionario, cpf, nomeSocial, logradouro, numero, bairro, cidade, estado, cep, sexo, status, dataAdmissao, dataNas, telefone, departamento_idDepartamento) VALUES
(1, '11111111111', 'Joao Silva', 'Rua A', 100, 'Centro', 'Lavras', 'MG', '37200000', 'M', 'A', '2019-03-01', '1990-05-12', '998765432', 1),
(2, '22222222222', 'Maria Souza', 'Rua B', 200, 'Jardim', 'Lavras', 'MG', '37200010', 'F', 'A', '2020-07-15', '1988-11-30', '998111222', 2),
(3, '33333333333', 'Ana Oliveira', 'Rua C', 300, NULL, 'Lavras', 'MG', '37200020', 'F', 'A', '2021-01-10', '1995-02-25', '997333444', 1),
(4, '44444444444', 'Carlos Pereira', 'Rua D', 400, 'Centro', 'Lavras', 'MG', '37200030', 'M', 'I', '2018-05-20', '1985-08-08', NULL, 3),
(5, '55555555555', 'Beatriz Lima', 'Rua E', 500, 'Vila', 'Lavras', 'MG', '37200040', 'F', 'A', '2022-09-01', '1998-12-01', '996555666', 1),
(6, '66666666666', 'Diego Santos', 'Rua F', 600, 'Centro', 'Lavras', 'MG', '37200050', 'M', 'D', '2017-02-18', '1983-04-19', '995777888', 4),
(7, '77777777777', 'Felipe Costa', 'Rua G', 700, 'Jardim', 'Lavras', 'MG', '37200060', 'M', 'A', '2023-08-01', '2002-06-10', '994999000', 1),
(8, '88888888888', 'Gabriela Rocha', 'Rua H', 800, 'Vila', 'Lavras', 'MG', '37200070', 'F', 'A', '2023-09-12', '2003-03-22', '993222111', 2),
(9, '99999999999', 'Heitor Alves', 'Rua I', 900, NULL, 'Lavras', 'MG', '37200080', 'M', 'A', '2024-02-01', '2001-09-05', '992444333', 1),
(10, '10101010101', 'Isabela Martins', 'Rua J', 1000, 'Centro', 'Lavras', 'MG', '37200090', 'F', 'A', '2024-03-15', '2002-12-30', '991666555', 5),
(11, '12121212121', 'Julia Fernandes', 'Rua K', 1100, 'Jardim', 'Lavras', 'MG', '37200100', 'F', 'A', '2024-05-01', '2003-07-18', NULL, 1),
(12, '13131313131', 'Lucas Mendes', 'Av X', 1200, 'Centro', 'Lavras', 'MG', '37200110', 'M', 'A', '2022-11-01', '1992-01-15', '990888777', 1),
(13, '14141414141', 'Marina Dias', 'Av Y', 1300, 'Jardim', 'Lavras', 'MG', '37200120', 'F', 'A', '2023-01-20', '1991-10-10', '989000999', 4),
(14, '15151515151', 'Nathan Gomes', 'Av Z', 1400, 'Vila', 'Lavras', 'MG', '37200130', 'M', 'A', '2023-06-05', '1989-03-03', '988111000', 1),
(15, '16161616161', 'Olivia Castro', 'Av W', 1500, 'Centro', 'Lavras', 'MG', '37200140', 'F', 'A', '2024-01-10', '1994-08-21', '987222333', 4),
(16, '17171717171', 'Paulo Ramos', 'Av V', 1600, 'Jardim', 'Lavras','MG','37200150','M','A','2022-04-25','1987-05-30','986333444', 3);
-- Nota: idFuncionario será gerado automaticamente de 1 a 16.

-- 4. TABELA: clt (Vincula aos IDs de funcionário correspondentes)
-- Inserindo com IDs explicitos para garantir a integridade
INSERT INTO clt (idFuncionario, carteiraTrabalho, fgts, funcionario_idFuncionario) VALUES
(1, 'CTPS001', 'FGTS001', 1), 
(2, 'CTPS002', 'FGTS002', 2), 
(3, 'CTPS003', 'FGTS003', 3), 
(4, 'CTPS004', 'FGTS004', 4), 
(5, 'CTPS005', 'FGTS005', 5), 
(6, 'CTPS006', 'FGTS006', 6);
-- Nota: Os seis funcionários (idFuncionario) de 1 a 6 recebem o vínculo CLT.

-- 5. TABELA: estagiario (Vincula aos IDs de funcionário correspondentes)
-- Inserindo com IDs explicitos para garantir a integridade
INSERT INTO estagiario (idFuncionario, curso, cargaHoraria, universidade, funcionario_idFuncionario) VALUES
(1, 'Ciencia da Computacao', 30, 'UFLA', 7), 
(2, 'Administracao', 20, 'UFLA', 8), 
(3, 'Sistemas de Informacao', 30, 'UFLA', 9), 
(4, 'Direito', 20, 'UFLA', 10), 
(5, 'Engenharia de Software', 40, 'UNILAVRAS', 11);
-- Nota: Os cinco funcionários (idFuncionario) de 7 a 11 recebem o vínculo de Estagiário.

-- 6. TABELA: pj (Vincula aos IDs de funcionário correspondentes)
-- Inserindo com IDs explicitos para garantir a integridade
INSERT INTO pj (idFuncionario, razaoSocial, funcionario_idFuncionario) VALUES
(1, 'Mendes Tech LTDA', 12), 
(2, 'Dias Consultoria ME', 13), 
(3, 'NG Solutions LTDA', 14), 
(4, 'Castro Design ME', 15), 
(5, 'Ramos Sistemas LTDA', 16);
-- Nota: Os cinco funcionários (idFuncionario) de 12 a 16 recebem o vínculo PJ.

-- 7. TABELA: salario (Vincula ao idFuncionario correspondente, respeitando o modelo limpo)
INSERT INTO salario (dataPagamento, valorBruto, desconto, valorLiquido, funcionario_idFuncionario) VALUES
('2025-01-05', 5000.00, 1000.00, 4000.00, 1), 
('2025-02-05', 5000.00, 1000.00, 4000.00, 1), 
('2025-01-05', 4500.00, 900.00, 3600.00, 2), 
('2025-02-05', 4500.00, 900.00, 3600.00, 2), 
('2025-01-05', 6000.00, 1500.00, 4500.00, 3), 
('2025-02-05', 6000.00, 1500.00, 4500.00, 3), 
('2025-01-05', 3500.00, 500.00, 3000.00, 4), 
('2025-02-05', 3500.00, 500.00, 3000.00, 4), 
('2025-01-05', 7000.00, 2000.00, 5000.00, 5), 
('2025-02-05', 7000.00, 2000.00, 5000.00, 5), 
('2025-01-05', 4000.00, 600.00, 3400.00, 6), 
('2025-02-05', 4000.00, 600.00, 3400.00, 6), 
('2025-01-05', 1500.00, 100.00, 1400.00, 7), 
('2025-01-05', 1400.00, 100.00, 1300.00, 8), 
('2025-01-05', 1500.00, 100.00, 1400.00, 9);
-- Nota: Os quinze holerites (idSalario) serão gerados automaticamente aos CLTs e Estagiários.

-- 8. TABELA: dependente (Cadastra os familiares atrelados estritamente aos funcionários do regime CLT)
INSERT INTO dependente (clt_idFuncionario, nome, parentesco, dataNascimento, sexo) VALUES
(1, 'Pedro Silva', 'Filho', '2015-04-10', 'M'), 
(1, 'Laura Silva', 'Filha', '2018-09-22', 'F'), 
(2, 'Rafael Souza', 'Filho', '2012-01-05', 'M'), 
(3, 'Sofia Oliveira','Filha', '2019-11-30', 'F'), 
(4, 'Marcos Pereira','Conjuge', '1986-06-15', 'M');

-- 9. TABELA: servico (Vincula ao idFuncionario da tabela pj)
INSERT INTO servico (idFuncionario, descricao, valorContrato, prazoEntrega) VALUES
(1, 'Desenvolvimento de API', 8000.00, '2025-06-30'), 
(1, 'Manutencao mensal de servidor', 2000.00, '2025-12-31'), 
(2, 'Consultoria de processos', 4500.00, '2025-08-15'), 
(3, 'Implantacao de ERP', 12000.00, '2025-09-30'), 
(4, 'Treinamento de equipe', 3000.00, '2025-07-20'), 
(4, 'Criacao de identidade visual', 3500.00, '2025-05-10');
-- Nota: O idServico será gerado automaticamente de 1 a 6.

-- 10. TABELA: clt_beneficio (Associa os funcionários CLT aos seus respectivos benefícios)
INSERT INTO clt_beneficio (idFuncionario, idBeneficio) VALUES
(1, 1), (1, 2), (1, 3), 
(2, 1), (2, 2), 
(3, 4), 
(5, 6);

-- 11. TABELA: estagiario_beneficio (Associa os estagiários às suas vantagens contratuais)
INSERT INTO estagiario_beneficio (idFuncionario, idBeneficio) VALUES
(1, 2), (1, 3), 
(2, 2), 
(3, 3), 
(4, 2), 
(5, 6);

-- =========================================================================
-- COMANDOS EXTRAS NECESSÁRIOS DA LETRA C:
-- =========================================================================

-- 1) Para consultar todos os dados que acabamos de inserir em cada tabela:
-- SELECT * FROM departamento;
-- SELECT * FROM beneficio;
-- SELECT * FROM funcionario;
-- SELECT * FROM clt;
-- SELECT * FROM estagiario;
-- SELECT * FROM pj;
-- SELECT * FROM salario;
-- SELECT * FROM dependente;
-- SELECT * FROM servico;
-- SELECT * FROM estagiario_beneficio;
-- SELECT * FROM clt_beneficio;

-- 2) Para excluir em massa todos os dados das tabelas:
-- SET SQL_SAFE_UPDATES = 0; (Desativa o modo seguro do Workbench (Error Code: 1175 — Safe Update Mode))
-- DELETE FROM clt_beneficio;
-- DELETE FROM estagiario_beneficio;
-- DELETE FROM servico;
-- DELETE FROM dependente; 
-- DELETE FROM salario;
-- DELETE FROM pj;
-- DELETE FROM estagiario;
-- DELETE FROM clt;
-- DELETE FROM funcionario;
-- DELETE FROM beneficio;
-- DELETE FROM departamento;
-- SET SQL_SAFE_UPDATES = 1; (Reativa o modo seguro para manter o padrão do programa)

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (d) - MODIFICAÇÃO DE DADOS 
-- =========================================================================

USE cuntyti;

-- UPDATE 1 — alterar o status de um funcionário
UPDATE funcionario 
SET status = 'D' 
WHERE idFuncionario = 4;

-- UPDATE 2 — alterar o nome de algum departamento
UPDATE departamento 
SET nomeDepartamento = 'Tecnologia da Informacao' 
WHERE nomeDepartamento = 'TI';

-- UPDATE 3 — alterar o tipo de algum benefício
UPDATE beneficio 
SET tipo = 'Qualidade de Vida'
WHERE nomeBeneficio = 'Gympass'; 

-- UPDATE 4 — aumentar a carga horária de todos os estagiários de alguma faculdade
UPDATE estagiario 
SET cargaHoraria = cargaHoraria + 10 
WHERE universidade = 'UFLA';

-- UPDATE 5 — recalcular o valor bruto e o valor líquido em todos os funcionários de algum departamento (ANINHADO)
UPDATE salario 
SET valorBruto = ROUND(valorBruto * 1.10, 2), 
	valorLiquido = ROUND((valorBruto * 1.10) - desconto, 2)
WHERE funcionario_idFuncionario IN ( 
	SELECT idFuncionario 
    FROM funcionario 
    WHERE departamento_idDepartamento = ( 
		SELECT idDepartamento 
        FROM departamento 
        WHERE nomeDepartamento = 'Tecnologia da Informacao' 
	) 
);

-- =========================================================================
-- COMANDOS EXTRAS NECESSÁRIOS DA LETRA D:
-- =========================================================================

-- 1) UPDATE funcionario SET status = 'I' WHERE idFuncionario = 4; (para voltar ao status de antes: Inativo)

-- 2) UPDATE departamento SET nomeDepartamento = 'TI' WHERE nomeDepartamento = 'Tecnologia da Informacao'; (para voltar ao nome de 
-- antes: TI)

-- 3) UPDATE beneficio SET tipo = 'Qualidade de Vida' WHERE nomeBeneficio = 'Gympass'; (para voltar ao tipo anterior: Gympass)

-- 4) UPDATE estagiario SET cargaHoraria = cargaHoraria - 10 WHERE universidade = 'UFLA'; (para voltar à carga horária anterior: 10 
-- horas a menos)

-- 5) UPDATE salario SET valorBruto = ROUND(valorBruto / 1.10, 2), valorLiquido = ROUND((valorBruto / 1.10) - desconto, 2)... 
-- (resetar o valor bruto e o valor líquido em todos os funcionários de algum departamento)

-- 6) SET SQL_SAFE_UPDATES = 0; (Desativa o modo seguro do Workbench e permite o WHERE antes de um atributo que não seja chave 
-- primária (Error Code: 1175 — Safe Update Mode))

-- 7) SET SQL_SAFE_UPDATES = 1; (Reativa o modo seguro para manter o padrão do programa)

-- --------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (e) - EXCLUSÃO DE DADOS
-- =========================================================================

USE cuntyti;

-- DELETE 1 — remover dependentes de algum funcionário (que seja obrigatoriamente CLT)
DELETE FROM dependente 
WHERE clt_idFuncionario = 4;

-- DELETE 2 — remover um benefício específico de algum funcionário CLT
DELETE FROM clt_beneficio 
WHERE idFuncionario = 5 AND idBeneficio = 6;

-- DELETE 3 — remover um benefício específico de todos os estagiários
DELETE FROM estagiario_beneficio 
WHERE idBeneficio = 6;

-- DELETE 4 — remover serviços abaixo de algum valor determinado
DELETE FROM servico 
WHERE valorContrato < 2500;

-- DELETE 5 — remover o registro de pagamento (holerite) de determinados funcionários consoante seu status (ANINHADO)
DELETE FROM salario 
WHERE funcionario_idFuncionario IN ( 
	SELECT idFuncionario 
	FROM funcionario 
	WHERE status = 'D' 
);

-- =========================================================================
-- COMANDOS EXTRAS NECESSÁRIOS DA LETRA E:
-- =========================================================================

-- 1) INSERT INTO dependente (clt_idFuncionario, nome, parentesco, dataNascimento, sexo) VALUES (4, 'Marcos Pereira', 'Conjuge', 
-- '1986-06-15', 'M'); (reinserir o dependente excluído do funcionário 4)

-- 2) INSERT INTO clt_beneficio (idFuncionario, idBeneficio) VALUES (5, 6); (reinserir o benefício 6 para o funcionário CLT de 
-- número 5)

-- 3) INSERT INTO estagiario_beneficio (idFuncionario, idBeneficio) VALUES (7, 6), (11, 6); (reinserir o benefício 6 para os 
-- estagiários que o detinham)

-- 4) INSERT INTO servico (idFuncionario, descricao, valorContrato, prazoEntrega) VALUES (12, 'Manutencao mensal de servidor', 
-- 2000.00, '2025-12-31'); (reinserir o serviço de valor inferior que foi apagado)

-- 5) INSERT INTO salario (dataPagamento, valorBruto, desconto, valorLiquido, funcionario_idFuncionario) VALUES ('2025-01-05', 
-- 4000.00, 600.00, 3400.00, 6), ('2025-02-05', 4000.00, 600.00, 3400.00, 6); (reinserir o registro de pagamento apagado de um 
-- funcionário)

-- 6) SET SQL_SAFE_UPDATES = 0; (Desativa o modo seguro do Workbench e permite o WHERE antes de um atributo que não seja chave 
-- primária (Error Code: 1175 — Safe Update Mode))

-- 7) SET SQL_SAFE_UPDATES = 1; (Reativa o modo seguro para manter o padrão do programa)

-- ----------------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (f) - CONSULTAS NAS TABELAS
-- =========================================================================

USE cuntyti;

-- F1 — INNER JOIN

-- Descrição: Recupera o nome social de cada funcionário junto com o nome do departamento ao qual ele pertence através do 
-- cruzamento das tabelas.

SELECT f.nomeSocial, d.nomeDepartamento
FROM funcionario f
INNER JOIN departamento d ON f.departamento_idDepartamento = d.idDepartamento;

-- F2 — OUTER JOIN

-- Descrição: Lista todas as PJs (Pessoas Jurídicas) e os serviços que elas prestam. Por usar LEFT OUTER JOIN, as PJs que ainda 
-- não possuem nenhum serviço cadastrado aparecem na listagem mesmo assim, trazendo a descrição nula.

SELECT p.razaoSocial, s.descricao
FROM pj p
LEFT OUTER JOIN servico s ON p.idFuncionario = s.idFuncionario;

-- F3 — ORDER BY

-- Descrição: Lista os funcionários ordenados pela data de admissão do mais antigo para o mais recente na empresa. Em caso de 
-- empate na data, ordena alfabeticamente pelo nome social.

SELECT nomeSocial, dataAdmissao
FROM funcionario
ORDER BY dataAdmissao ASC, nomeSocial ASC;

-- F4 — GROUP BY (com funções agregadas)

-- Descrição: Para cada funcionário que possui registro de pagamento, agrupa as linhas, conta a quantidade total de holerites 
-- gerados e soma o total líquido recebido acumulado.

SELECT funcionario_idFuncionario,
COUNT(*) AS qtdHolerites,
SUM(valorLiquido) AS totalLiquido
FROM salario
GROUP BY funcionario_idFuncionario;

-- F5 — HAVING

-- Descrição: Agrupa os funcionários por departamento e mostra apenas aqueles departamentos que possuem estritamente mais de dois 
-- funcionários cadastrados.

SELECT d.nomeDepartamento, COUNT(*) AS qtdFuncionarios
FROM funcionario f
INNER JOIN departamento d ON f.departamento_idDepartamento = d.idDepartamento
GROUP BY d.idDepartamento, d.nomeDepartamento
HAVING COUNT(*) > 2;

-- F6 — UNION

-- Descrição: Gera uma lista única com os nomes de todas as pessoas cadastradas no sistema (funcionários e dependentes), rotulando a 
-- origem de cada registro.

SELECT nomeSocial AS nome, 'Funcionario' AS tipo FROM funcionario
UNION
SELECT nome, 'Dependente' AS tipo FROM dependente;

-- F7 — IN (com subconsulta/consulta aninhada)

-- Descrição: Recupera os funcionários que pertencem aos departamentos de 'TI' ou 'Comercial'. Ademais, a subconsulta (consulta 
-- aninhada) devolve os IDs desses setores.

SELECT nomeSocial
FROM funcionario
WHERE departamento_idDepartamento IN (
    SELECT idDepartamento
    FROM departamento
    WHERE nomeDepartamento IN ('TI', 'Comercial', 'Tecnologia da Informacao')
);

-- F8 — LIKE
-- Descrição: Recupera as PJs cuja razão social termina com o sufixo 'LTDA'.

SELECT razaoSocial
FROM pj
WHERE razaoSocial LIKE '%LTDA';

-- F9 — IS NULL 
-- Descrição: Recupera os funcionários que estão sem telefone cadastrado no banco.

SELECT nomeSocial
FROM funcionario
WHERE telefone IS NULL;

-- F10 — ANY/SOME

-- Descrição: Recupera os serviços cujo valor de contrato é estritamente maior do que pelo menos um dos serviços prestados pela PJ 
-- de ID 12.

SELECT descricao, valorContrato
FROM servico
WHERE valorContrato > ANY (
    SELECT valorContrato
    FROM servico
    WHERE idFuncionario = 1
);

-- F11 — ALL

-- Descrição: Recupera o serviço de maior valor de contrato cadastrado no sistema. Ademais, o valor deve ser maior ou igual a todos 
-- os contratos existentes na tabela.

SELECT descricao, valorContrato
FROM servico
WHERE valorContrato >= ALL (
    SELECT valorContrato
    FROM servico
);

-- F12 — EXISTS
-- Descrição: Recupera os funcionários CLT que possuem pelo menos um dependente cadastrado no sistema.

SELECT f.nomeSocial
FROM clt c
INNER JOIN funcionario f ON c.funcionario_idFuncionario = f.idFuncionario
WHERE EXISTS (
    SELECT 1
    FROM dependente d
    WHERE d.clt_idFuncionario = c.idFuncionario
);

-- =========================================================================
-- CONSULTAS EXTRAS DA LETRA F:
-- =========================================================================

-- F13 — AND/OR
-- Descrição: Recupera os funcionários ativos que pertencem ao departamento 1 OU ao departamento 2.

SELECT nomeSocial, status, departamento_idDepartamento
FROM funcionario
WHERE status = 'A' AND (departamento_idDepartamento = 1 OR departamento_idDepartamento = 2);

-- F14 — BETWEEN
-- Descrição: Recupera os serviços cujo valor de contrato está na faixa entre R$ 3.000,00 e R$ 9.000,00 inclusive.

SELECT descricao, valorContrato
FROM servico
WHERE valorContrato BETWEEN 3000 AND 9000;

-- F15 — NOT EXISTS
-- Descrição: Recupera as PJs que não prestaram nenhum serviço, usando a negação NOT com EXISTS.

SELECT p.razaoSocial
FROM pj p
WHERE NOT EXISTS (
    SELECT 1
    FROM servico s
    WHERE s.idFuncionario = p.idFuncionario
);

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (g) - VISÕES (VIEWS)
-- =========================================================================

USE cuntyti;

-- VIEW 1 — funcionários com seu departamento

CREATE OR REPLACE VIEW vw_funcionario_departmento AS
SELECT f.idFuncionario, f.nomeSocial, f.status, d.nomeDepartamento
FROM funcionario f
INNER JOIN departamento d ON f.departamento_idDepartamento = d.idDepartamento;

-- Exemplo de Uso da View 1 (todos os funcionários do departamento de TI):
SELECT * FROM vw_funcionario_departmento
WHERE nomeDepartamento = 'Tecnologia da Informacao';

-- VIEW 2 — folha de pagamento por funcionário

CREATE OR REPLACE VIEW vw_folha_por_funcionario AS
SELECT f.idFuncionario, 
       f.nomeSocial,
       COUNT(s.holerite) AS qtdHolerites, 
       COALESCE(SUM(s.valorLiquido), 0) AS totalLiquido
FROM funcionario f
LEFT JOIN salario s ON f.idFuncionario = s.funcionario_idFuncionario
GROUP BY f.idFuncionario, f.nomeSocial;

-- Exemplo de Uso da View 2 (todos os funcionários que já receberam mais de R$ 7.000 no total):
SELECT * FROM vw_folha_por_funcionario
WHERE totalLiquido > 7000;

-- Visão 3 — serviços por PJ

CREATE OR REPLACE VIEW vw_pj_servicos AS
SELECT p.idFuncionario, 
	   p.razaoSocial,
       COUNT(s.idServico) AS qtdServicos,
       COALESCE(SUM(s.valorContrato), 0) AS totalContratos
FROM pj p
LEFT JOIN servico s ON p.idFuncionario = s.idFuncionario
GROUP BY p.idFuncionario, p.razaoSocial;

-- Exemplo de Uso da View 3 (PJs ordenadas pelo total contratado em ordem decrescente):
SELECT * FROM vw_pj_servicos
ORDER BY totalContratos DESC;

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (i) - PROCEDIMENTOS/FUNÇÕES (STORE PROCEDURES)
-- =========================================================================

USE cuntyti;

DROP FUNCTION IF EXISTS fn_total_liquido; -- remoção da função caso ela já exista (evitar erros de reexecução do script)

-- 1. FUNÇÃO 1 — fn_total_liquido (entrada + retorno, IFNULL)

-- Descrição: Função com parâmetro de entrada (ID do funcionário) que calcula e retorna o somatório acumulado de todos os valores 
-- líquidos recebidos por ele. Utiliza declaração de variáveis locais, cláusula INTO e a função nativa IFNULL para tratamento de 
-- ausência de registros (logs).

DELIMITER //
CREATE FUNCTION fn_total_liquido(p_id INT) 
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Declaração de variável local para armazenar temporariamente o cálculo
    DECLARE v_total DECIMAL(12,2);
    
    -- Realiza o somatório tratando possíveis retornos nulos com IFNULL
    -- E direciona o resultado para a variável local usando o INTO
    SELECT IFNULL(SUM(valorLiquido), 0) INTO v_total 
    FROM salario 
    WHERE funcionario_idFuncionario = p_id;
    
    -- Devolve o valor calculado ao chamador da função
    RETURN v_total;
END //
DELIMITER ;

-- 2. TESTE DA FUNÇÃO 1

-- Descrição: Executa a função diretamente em um SELECT para buscar o total líquido acumulado que o João Silva (ID 1) já recebeu 
-- em holerites até o momento.

SELECT fn_total_liquido(1) AS totalFuncionario1;

-- --------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS sp_status_extenso; -- remoção do procediemento caso ela já exista (evitar erros de reexecução do script)

-- 3. PROCEDIMENTO 2 — sp_status_extenso; (com parâmetros: IN + OUT, IF/ELSE e CASE WHEN)

-- Descrição: Procedimento que recebe o ID de um funcionário (IN) e devolve por extenso (OUT) a situação cadastral dele na empresa.
-- Utiliza lógica condicional aninhada com IF/ELSE para tratar IDs inexistentes e a estrutura CASE WHEN para realizar a tradução 
-- limpa dos códigos internos de status.

DELIMITER //
CREATE PROCEDURE sp_status_extenso(
    IN p_id INT, 
    OUT p_desc VARCHAR(20)
)
BEGIN
    -- Declaração de variável local para armazenar o caractere bruto de status
    DECLARE v_status CHAR(1);
    
    -- Captura o status do funcionário correspondente e injeta na variável local
    SELECT status INTO v_status 
    FROM funcionario 
    WHERE idFuncionario = p_id;
    
    -- Estrutura Condicional IF para verificar se o ID fornecido existe no banco
    IF v_status IS NULL THEN
        SET p_desc = 'Não encontrado';
    ELSE
        -- Estrutura Escolha/Caso (CASE WHEN) para traduzir o código para o usuário
        CASE v_status
            WHEN 'A' THEN SET p_desc = 'Ativo';
            WHEN 'I' THEN SET p_desc = 'Inativo';
            WHEN 'D' THEN SET p_desc = 'Desligado';
            ELSE SET p_desc = 'Desconhecido';
        END CASE;
    END IF;
END //
DELIMITER ;

-- 4. TESTE DO PROCEDIMENTO 2

-- Descrição: Invocamos o procedimento passando o ID 4 (Carlos Pereira) e capturamos o retorno de saída na variável global do 
-- sistema chamada @desc. Em seguida, exibimos o valor em uma consulta de conferência.

CALL sp_status_extenso(4, @desc); -- invocação do procedimento, captura do seu parâmetro e seu retorno
SELECT @desc AS statusFuncionario4; -- consulta de verificação do retorno

-- --------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS sp_popular_departamentos_teste; -- remoção do procediemento caso ela já exista (evitar erros de reexecução 
-- do script)

-- 5. PROCEDIMENTO 3 — sp_popular_departamentos_teste (sem parâmetros, WHILE)

-- Descrição: Procedimento sem parâmetros estruturado para geração em lote de registros na tabela departamento. Utiliza a 
-- declaração de um contador local, a estrutura de repetição WHILE e a função nativa CONCAT para automatizar as inserções 
-- sequenciais no banco de dados.

DELIMITER //
CREATE PROCEDURE sp_popular_departamentos_teste()
BEGIN
    -- Declaração de variável local contadora e inicialização com o valor 1
    DECLARE v_i INT DEFAULT 1;
    
    -- Laço de repetição WHILE que executará o bloco de códigos por 3 iterações
    WHILE v_i <= 3 DO
        -- Realiza a inserção automatizada concatenando o sufixo numérico
        INSERT INTO departamento (nomeDepartamento) 
        VALUES (CONCAT('Depto Teste ', v_i));

        -- Incrementa a variável contadora para evitar loops infinitos
        SET v_i = v_i + 1;
    END WHILE;
END //
DELIMITER ;

-- 6. TESTE DO PROCEDIMENTO 3

-- Descrição: Invocamos o procedimento para injetar as 3 linhas de teste de uma só vez. Em seguida, exibimos os dados gerados pelo
-- laço WHILE na consulta de verificação

CALL sp_popular_departamentos_teste(); -- invocação do procedimento, sem parâmetro 
SELECT idDepartamento, nomeDepartamento -- consulta de verificação dos dados gerados pelo laço WHILE
FROM departamento 
WHERE nomeDepartamento LIKE 'Depto Teste%';

-- 7. LIMPEZA DOS DADOS DO PROCEDIMENTO 3

-- Descrição: Limpar a massa de teste criada (três departamentos inexistentes), garantindo a integridade do banco de dados

DELETE FROM departamento WHERE nomeDepartamento LIKE 'Depto Teste%';

-- =========================================================================
-- COMANDOS EXTRAS NECESSÁRIOS DA LETRA I:
-- =========================================================================

-- 1) DROP FUNCTION fn_total_liquido; (deletar a primeira função à parte)
-- 2) DROP PROCEDURE sp_status_extenso; (deletar o segundo procedimento à parte)
-- 3) DROP PROCEDURE sp_popular_departamentos_teste; (deletar o terceiro procedimento à parte)

-- --------------------------------------------------------------------------------------------------------------------------------

-- =========================================================================
-- ITEM (j) - TRIGGERS
-- =========================================================================

USE cuntyti;

-- TABELA: auditoria (tabela de apoio às triggers de UPDATE e DELETE)

DROP TABLE IF EXISTS auditoria; -- deletar a tabela para reexucutar o script sem erro

CREATE TABLE auditoria ( 
	idLog INT AUTO_INCREMENT PRIMARY KEY, 
	tabela VARCHAR(30), 
	operacao VARCHAR(10), 
	descricao VARCHAR(200), 
	dataHora DATETIME 
);

DROP TRIGGER IF EXISTS tg_salario_bi; -- resetar o trigger no sistema (para evitar erros)

-- TRIGGER 1 (INSERÇÃO) — tg_salario_bi

-- Descrição: Antes de inserir um registro na folha, calcula automaticamente o valor líquido real (Bruto - Desconto), impedindo 
-- fraudes ou inconsistências.

DELIMITER // 
CREATE TRIGGER tg_salario_bi 
BEFORE INSERT ON salario 
FOR EACH ROW 
BEGIN 
	SET NEW.valorLiquido = NEW.valorBruto - NEW.desconto; 
END // 
DELIMITER ;

-- 2. CASO DE TESTE DO DISPARO DA TRIGGER DE INSERÇÃO

-- Descrição: Inserimos o valorLiquido propositalmente zerado (0.00). O gatilho deve atuar, interceptar a operação e forçar o 
-- cálculo correto de R$ 1.700,00 no banco.

INSERT INTO salario (dataPagamento, valorBruto, desconto, valorLiquido, funcionario_idFuncionario) 
VALUES ('2025-03-05', 2000.00, 300.00, 0.00, 7);

SELECT holerite, valorBruto, desconto, valorLiquido 
FROM salario 
WHERE funcionario_idFuncionario = 7 AND dataPagamento = '2025-03-05';

-- 3. CASO DE TESTE DO NÃO DISPARO DA TRIGGER DE INSERÇÃO

-- Descrição: -- Realizamos uma alteração (UPDATE). Como o gatilho está amarrado estritamente ao evento INSERT, esta operação não 
-- passará pela lógica interna da trigger.

UPDATE salario 
SET desconto = 350.00 
WHERE funcionario_idFuncionario = 7 AND dataPagamento = '2025-03-05';

-- --------------------------------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS tg_funcionario_au; -- resetar o trigger no sistema (para evitar erros)

-- 4. TRIGGER 2 (ALTERAÇÃO) — tg_funcionario_au

-- Descrição: Após uma atualização na tabela funcionário, verifica se houve alteração no seu status corporativo. Em caso positivo, 
-- grava um histórico detalhado na tabela de auditoria contendo o estado anterior e o atual.

DELIMITER //
CREATE TRIGGER tg_funcionario_au 
AFTER UPDATE ON funcionario 
FOR EACH ROW 
BEGIN 
    -- Verifica se o status antigo é diferente do novo status atribuído
    IF OLD.status <> NEW.status THEN 
        INSERT INTO auditoria (tabela, operacao, descricao, dataHora) 
        VALUES (
            'funcionario', 
            'UPDATE', 
            CONCAT('Funcionario ID ', NEW.idFuncionario, ' mudou de status de "', OLD.status, '" para "', NEW.status, '"'), 
            NOW()
        ); 
    END IF; 
END //
DELIMITER ;

-- 5. CASO DE TESTE DO DISPARO DA TRIGGER DE ALTERAÇÃO

-- Descrição: Alteramos o status da funcionária Maria Souza (ID 2) de Ativo ('A') para Inativo ('I'). Como a condição do IF é 
-- atendida, uma linha deve surgir na auditoria.

UPDATE funcionario 
SET status = 'I' 
WHERE idFuncionario = 2;

-- 6. CASO DE TESTE DO NÃO DISPARO DA TRIGGER DE ALTERAÇÃO

-- Descrição: Modificamos o telefone da mesma funcionária (ID 2). Como o status dela permanece sendo 'I' (não mudou), a trigger é 
-- acionada pelo evento, mas o bloco IF barra a gravação.

UPDATE funcionario 
SET telefone = '988887777' 
WHERE idFuncionario = 2;

-- 7. TABELA DE AUDITORIA (REGISTRO DE ALTERAÇÃO)

-- Descrição: O resultado esperado na tela deve conter EXATAMENTE UMA LINHA na tabela de auditoria, provando que o caso 1 gravou e 
-- o caso 2 foi ignorado com sucesso.

SELECT * FROM auditoria WHERE tabela = 'funcionario';

-- --------------------------------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS tg_funcionario_ad; -- resetar o trigger no sistema (para evitar erros)

-- 8. TRIGGER 3 (EXCLUSÃO) — tg_funcionario_ad

-- Descrição: Após a remoção definitiva de um colaborador do banco de dados, recupera seus dados históricos através do qualificador
-- 'OLD' e grava um registro indelével na auditoria para fins de fiscalização.

DELIMITER //
CREATE TRIGGER tg_funcionario_ad 
AFTER DELETE ON funcionario 
FOR EACH ROW 
BEGIN 
    INSERT INTO auditoria (tabela, operacao, descricao, dataHora) 
    VALUES ('funcionario', 'DELETE', 
        CONCAT('Funcionario ID ', OLD.idFuncionario, ' (', OLD.nomeSocial, ') foi excluido do sistema definitivamente.'), 
        NOW()
    ); 
END //
DELIMITER ;

-- 9. CASO DE TESTE DO DISPARO DA TRIGGER DE EXCLUSÃO

-- Descrição: Primeiro deletamos a dependência (PJ) e depois o funcionário para disparar a exclusão sem ferir a integridade.

DELETE FROM pj WHERE funcionario_idFuncionario = 16;
DELETE FROM funcionario WHERE idFuncionario = 16;

-- 10. CASO DE TESTE DO NÃO DISPARO DA TRIGGER DE EXCLUSÃO

DELETE FROM clt_beneficio 
WHERE idFuncionario = 3 AND idBeneficio = 4;

-- 11. TABELA DE AUDITORIA (REGISTRO DE EXCLUSÃO)

-- Descrição: O resultado na tela deve comprovar a existência de apenas uma linha com a operação 'DELETE', atestando o 
-- funcionamento perfeito do caso 1 e caso 2.

SELECT * FROM auditoria WHERE operacao = 'DELETE';

-- =========================================================================
-- COMANDOS EXTRAS NECESSÁRIOS DA LETRA J:
-- =========================================================================

-- 1) DELETE FROM auditoria; (deletar a tabela de auditoria do sistema à parte)
-- 2) DROP TRIGGER tg_salario_bi; (deletar o trigger de inserção à parte)
-- 3) DROP TRIGGER tg_funcionario_au; (deletar o trigger de alteração à parte)
-- 4) DROP TRIGGER tg_funcionario_ad; (deletar o trigger de exclusão à parte)

-- --------------------------------------------------------------------------------------------------------------------------------