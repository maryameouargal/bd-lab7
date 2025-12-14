USE banque_demo;
UPDATE compte SET solde = solde + 100.00 WHERE id = 1;
COMMIT;

-- Étape 7 – Verrous explicites

UPDATE compte SET solde = solde + 10.00 WHERE id = 1;