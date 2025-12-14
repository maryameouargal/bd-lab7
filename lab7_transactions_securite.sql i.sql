-- Étape 1 – Création de la base de démonstration
CREATE DATABASE IF NOT EXISTS banque_demo
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE banque_demo;

-- Étape 2 – Création de la table compte
CREATE TABLE compte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulaire VARCHAR(100) NOT NULL,
    solde DECIMAL(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB;

SHOW CREATE TABLE compte;

-- Étape 3 – Insertion de données d’exemple
INSERT INTO compte (titulaire, solde) VALUES
    ('Alice', 1000.00),
    ('Bob', 500.00);

SELECT * FROM compte;

-- Étape 4 – Transaction réussie (COMMIT)
START TRANSACTION;

UPDATE compte SET solde = solde - 200.00 WHERE id = 1;  -- Alice
UPDATE compte SET solde = solde + 200.00 WHERE id = 2;  -- Bob

COMMIT;

SELECT * FROM compte;

-- Étape 5 – Transaction annulée (ROLLBACK)
START TRANSACTION;

UPDATE compte SET solde = solde - 2000.00 WHERE id = 1;  
UPDATE compte SET solde = solde + 2000.00 WHERE id = 2; 

ROLLBACK;
SELECT * FROM compte;

-- Étape 6 – Niveaux d’isolation
-- Session 1 :
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT solde FROM compte WHERE id = 1;

-- Session 2 :
UPDATE compte SET solde = solde + 100.00 WHERE titulaire = 'Alice';
COMMIT;

-- Retour Session 1 :
SELECT solde FROM compte WHERE titulaire = 'Alice';

-- Étape 7 – Verrous explicites
-- Session 1 :
START TRANSACTION;
SELECT * FROM compte WHERE titulaire = 'Alice' FOR UPDATE;

-- (En Session 2, cela sera bloqué)
-- UPDATE compte SET solde = solde + 10.00 WHERE titulaire = 'Alice';

-- Session 1 :
COMMIT; -- déverrouille

-- Étape 8 – Sécurisation : création d’utilisateurs et privilèges
CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'P@ssw0rd!';

GRANT SELECT, INSERT, UPDATE ON banque_demo.compte TO 'app_user'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'app_user'@'localhost';

ALTER USER 'app_user'@'localhost' IDENTIFIED BY '123';
FLUSH PRIVILEGES;


-- Révoquer un droit :
REVOKE UPDATE ON banque_demo.compte FROM 'app_user'@'localhost';
FLUSH PRIVILEGES;