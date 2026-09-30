GRANT ALL PRIVILEGES ON gestioneutente.* TO 'app'@'%';
GRANT ALL PRIVILEGES ON notificadb.* TO 'app'@'%';
GRANT ALL PRIVILEGES ON prenotazioneappdb.* TO 'app'@'%';

FLUSH PRIVILEGES;

-- =========================================================
-- DATABASE 1: PRENOTAZIONE
-- =========================================================
CREATE DATABASE IF NOT EXISTS prenotazioneappdb;

USE prenotazioneappdb;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS prenotazione;
DROP TABLE IF EXISTS postazione;
DROP TABLE IF EXISTS utente;
DROP TABLE IF EXISTS stanza;
DROP TABLE IF EXISTS sede;

SET FOREIGN_KEY_CHECKS = 1;


-- =========================================================
-- 1. SEDE
-- =========================================================

CREATE TABLE sede (
    id INT NOT NULL AUTO_INCREMENT,
    paese VARCHAR(45) DEFAULT NULL,
    citta VARCHAR(45) DEFAULT NULL,
    regione VARCHAR(45) DEFAULT NULL,
    indirizzo VARCHAR(45) DEFAULT NULL,

    PRIMARY KEY (id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- =========================================================
-- 2. STANZA
-- =========================================================

CREATE TABLE stanza (
    id INT NOT NULL AUTO_INCREMENT,
    id_sede INT DEFAULT NULL,
    n_stanza VARCHAR(255) DEFAULT NULL,

    PRIMARY KEY (id),

    KEY FK_stanza_sede (id_sede),

    CONSTRAINT FK_stanza_sede
        FOREIGN KEY (id_sede)
        REFERENCES sede (id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- =========================================================
-- 3. POSTAZIONE
-- =========================================================

CREATE TABLE postazione (
    id INT NOT NULL AUTO_INCREMENT,
    id_stanza INT DEFAULT NULL,
    manutenzione BIT(1) DEFAULT NULL,

    PRIMARY KEY (id),

    KEY FK_postazione_stanza (id_stanza),

    CONSTRAINT FK_postazione_stanza
        FOREIGN KEY (id_stanza)
        REFERENCES stanza (id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- =========================================================
-- 4. UTENTE
-- =========================================================

CREATE TABLE utente (
    id_sede INT DEFAULT NULL,
    user_key VARCHAR(255) NOT NULL,

    PRIMARY KEY (user_key),

    KEY FK_utente_sede (id_sede),

    CONSTRAINT FK_utente_sede
        FOREIGN KEY (id_sede)
        REFERENCES sede (id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- =========================================================
-- 5. PRENOTAZIONE
-- =========================================================

CREATE TABLE prenotazione (
    id INT NOT NULL AUTO_INCREMENT,
    id_postazione INT DEFAULT NULL,
    data_creazione DATETIME(6) DEFAULT NULL,
    data_fine DATETIME(6) DEFAULT NULL,
    data_inizio DATETIME(6) DEFAULT NULL,
    id_utente VARCHAR(255) DEFAULT NULL,
    stato VARCHAR(255) DEFAULT NULL,

    PRIMARY KEY (id),

    KEY FK_prenotazione_postazione (id_postazione),
    KEY FK_prenotazione_utente (id_utente),

    CONSTRAINT FK_prenotazione_postazione
        FOREIGN KEY (id_postazione)
        REFERENCES postazione (id),

    CONSTRAINT FK_prenotazione_utente
        FOREIGN KEY (id_utente)
        REFERENCES utente (user_key)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

USE prenotazioneappdb;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE prenotazione;
TRUNCATE TABLE utente;
TRUNCATE TABLE postazione;
TRUNCATE TABLE stanza;
TRUNCATE TABLE sede;

SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================
-- SEDI
-- =========================================================

INSERT INTO sede (id, paese, citta, regione, indirizzo)
VALUES
    (1, 'Italia', 'Palermo', 'Sicilia', 'Via aaa'),
    (2, 'Italia', 'Palermo', 'Sicilia', 'Via bbb'),
    (3, 'Italia', 'Palermo', 'Sicilia', 'Via ccc');


-- =========================================================
-- STANZE
-- =========================================================

INSERT INTO stanza (id, n_stanza, id_sede)
VALUES
    (1, '1', 1),

    (2, '1', 2),
    (3, '2', 2),

    (4, '1', 3),
    (5, '2', 3);


-- =========================================================
-- POSTAZIONI
-- 4 postazioni per ogni stanza
-- =========================================================

INSERT INTO postazione (id, manutenzione, id_stanza)
VALUES
    -- Via aaa - Stanza 1
    (1, false, 1),
    (2, false, 1),
    (3, false, 1),
    (4, false, 1),

    -- Via bbb - Stanza 1
    (5, false, 2),
    (6, false, 2),
    (7, false, 2),
    (8, false, 2),

    -- Via bbb - Stanza 2
    (9, false, 3),
    (10, false, 3),
    (11, false, 3),
    (12, false, 3),

    -- Via ccc - Stanza 1
    (13, false, 4),
    (14, false, 4),
    (15, false, 4),
    (16, false, 4),

    -- Via ccc - Stanza 2
    (17, false, 5),
    (18, false, 5),
    (19, false, 5),
    (20, false, 5);


-- =========================================================
-- UTENTI
--
-- Adriana e Mario -> sede 1
-- Tutti gli altri -> sede casuale 1, 2 oppure 3
-- =========================================================

INSERT INTO utente (user_key, id_sede)
VALUES
    (
        'd78d1b8b-7439-4b07-9488-44f0f08a6293',
        1
    ),
    (
        '4fc9beed-5244-4f60-90c5-5239a799b710',
        1
    ),

    (
        '2a005afe-9a89-42d5-b7a5-f3bed68a18d1',
        2
    ),
    (
        '509315c5-6da9-4e30-afb9-ddf54ad29a9e',
        3
    ),
    (
        '2a2c7901-d915-4cfb-b672-738ee91148d6',
        1
    ),
    (
        'ce822014-8564-4d5b-ad80-bb6d658a23cf',
        2
    ),
    (
        'e5ef4e19-da77-448a-b066-abef6c03c0ff',
        3
    ),
    (
        '1ed66226-2da6-471c-98c8-75372e6cc525',
        1
    ),
    (
        'e78f0216-4183-4f50-8d9a-5c331a344ff7',
        2
    ),
    (
        'c533775c-da47-48cd-be4c-7659d55824a8',
        3
    ),
    (
        '69ae8f6b-36cc-47e2-b2cf-e014cf656c21',
        1
    ),
    (
        '6edf589e-0636-40a6-80de-61fb563b3554',
        2
    ),
    (
        '45843668-93f6-4c11-9359-3eba9f120481',
        3
    ),
    (
        '35f691b1-ef89-4551-b1c5-f267ec2973c4',
        1
    ),
    (
        'e8e76548-fef-4817-8fda-1911405e2668',
        2
    ),
    (
        'fdbb01fc-3e93-41b5-bfc2-b74ac513aafa',
        3
    ),
    (
        'aaa2b221-a4dd-4b61-b234-47ea50abd75a',
        1
    ),
    (
        'd2551d1c-7784-4f0d-a338-6651c1d51cad',
        2
    ),
    (
        'f550dfdb-1809-4cc1-884c-c5cfffd19d0e',
        3
    ),
    (
        '59e446c0-be73-489a-b46b-99e96d641579',
        1
    ),
    (
        '932fd5cd-dcf1-4eea-9781-822b8a8a9cfc',
        2
    ),
    (
        '9f665233-2901-4215-b110-07bac1787fce',
        3
    ),
    (
        '36b10dd6-afb6-4153-9ce4-3fb6f90d708d',
        1
    ),
    (
        '2aa290db-9e60-416e-9c2f-9c8189a1352d',
        2
    ),
    (
        'c70048a5-5447-4972-9186-7ac54537e5ff',
        3
    ),
    (
        '155f6107-0306-42b8-942c-fff218825c5f',
        1
    ),
    (
        '7f5386a2-53c8-4eaa-b304-35e43e8cc5cb',
        2
    ),
    (
        '0a88c511-3996-41c8-97fd-c6e088fc52ca',
        3
    ),
    (
        'bcca474d-4018-475d-a4ef-1e0f3b9f62a5',
        1
    ),
    (
        'ea0c718c-1473-4ee7-aac1-189df590be20',
        2
    ),
    (
        'eb7c191b-cdbc-4c50-bfab-58b3cd0d9009',
        3
    ),
    (
        '67479929-d3a7-4596-a17d-a6edd03dc67e',
        1
    ),
    (
        'bb3ec532-914e-4be2-bfc8-96a285e13d0b',
        2
    ),
    (
        '9f213c13-4f60-4732-a076-33f0a1baef6f',
        3
    ),
    (
        '07cfbfe2-beb0-4b55-92f8-557a4deeeaa0',
        1
    ),
    (
        'ef53d8b9-4949-408b-8a6b-9479de1a547e',
        2
    ),
    (
        '0fc2f09b-1a59-48e3-9bef-ef0c2adb7a73',
        3
    ),
    (
        '632f6075-9e11-4c13-a31b-63ec32b5fe49',
        1
    ),
    (
        '2697be4a-6b8a-4f8a-86ee-136bcc59a1d1',
        2
    ),
    (
        'd8be3569-bf32-412f-8840-11b6f1283c93',
        3
    ),
    (
        '6b7d1fdd-79a7-4dd9-888d-04105d172374',
        1
    ),
    (
        'ec609a5b-7b5a-43a5-8228-c6d4f797c121',
        2
    ),
    (
        '5c025d16-c56f-4b5c-9641-719f8c59dbdb',
        3
    ),
    (
        'ab0e1ec1-27dd-4b03-8a61-ec342069ba47',
        1
    ),
    (
        '270faa75-4e62-4c88-95e2-9d09403b347f',
        2
    ),
    (
        '09b73c2e-b304-4ce8-bfca-cee5050403b4',
        3
    ),
    (
        'bc3748f3-9b60-417b-9d3d-5c675e92fe62',
        1
    ),
    (
        '818cfe82-101d-4798-bf95-8ffeb0aa63b1',
        2
    ),
    (
        'd23078d3-5f8b-4e2c-8e56-b74a1adf10c4',
        3
    ),
    (
        '1de24f46-5ab8-4134-850c-0c5a4fc713ec',
        1
    ),
    (
        '2364c1d8-c3c3-4c26-983d-138dfe96c1bd',
        2
    ),
    (
        '41c2f9f9-0544-46d2-acf7-0402d4e23b10',
        3
    ),
    (
        '34540c35-49fa-4871-a9c9-392b0671bf3c',
        1
    ),
    (
        'ad60ebab-e1bb-4e95-91f5-88e6960c5010',
        2
    ),
    (
        'eaba0cb9-b6b6-4aad-95c1-97ab52fe16fa',
        3
    ),
    (
        '8222d42a-599b-42bb-9173-289e06de8984',
        1
    ),
    (
        '0f4d13af-9fa1-4871-bcd0-05bd3e119deb',
        2
    ),
    (
        '2bca4392-c001-4e15-a2fd-f91eb2081838',
        3
    ),
    (
        '5f2f9c1e-566d-4972-be86-85bfcfd8c2ce',
        1
    ),
    (
        'bb54e937-b706-4a56-9609-eb565f2661b5',
        2
    ),
    (
        '02090147-4d5f-43e1-b8f1-25c8fecf2869',
        3
    ),
    (
        '339fde4b-9f91-43c8-a01b-335338599f61',
        1
    ),
    (
        'a73a14aa-c8ea-47a2-9d47-77484d22dd44',
        2
    ),
    (
        'b818ec4b-d61f-4b3a-8ea7-ef8076b496f7',
        3
    ),
    (
        'b65ecd91-5188-4146-aae0-cc887ac3ffad',
        1
    ),
    (
        'a69a228d-4b74-46da-8988-22ebbba29fc8',
        2
    ),
    (
        'ef4eb5a3-a1c3-4757-9702-41d4c4058fe1',
        3
    ),
    (
        'defa0883-d9d6-4706-bf79-b5d351246db7',
        1
    ),
    (
        'c6181c2f-7bf5-4eb0-83ca-4640e4d05cc8',
        2
    ),
    (
        '2079e172-feb9-46d2-b842-b88a494718ba',
        3
    ),
    (
        'b2bf5d16-b1a9-4e12-ad83-17013a228f48',
        1
    ),
    (
        '00116230-7470-4b6b-8489-218be1df1891',
        2
    ),
    (
        'b60a7f3a-43a5-47d4-a8c2-143156100aae',
        3
    ),
    (
        '6ffce99e-9dff-4b5c-906d-a003600c29d3',
        1
    ),
    (
        'c96d5ac0-1f90-4ddd-94bb-8663f58e164a',
        2
    ),
    (
        '591b63f7-ee21-4f00-a1b0-53c3af9c6362',
        3
    ),
    (
        '062b8311-2a43-4c89-9eae-62bfcd7f8458',
        1
    ),
    (
        '33efd3ac-9110-4909-b46f-e7f551701fe1',
        2
    ),
    (
        '2c6ef2f7-d5b2-440d-98c9-764cda4ec84e',
        3
    ),
    (
        '426d6ad8-6ead-487c-9bc9-1ed42aaead61',
        1
    ),
    (
        '3bddc13e-71a1-401a-bb06-52935e0e2ad7',
        2
    ),
    (
        'cf342cdd-b40f-4205-9504-d9e088ea015a',
        3
    ),
    (
        'a63e9b11-fba5-4a36-b8ce-3e044e046e08',
        1
    ),
    (
        '60bfcca6-2606-452f-88ab-0674eb9a06b8',
        2
    ),
    (
        '9333d7b2-839f-41f3-bcd6-c6c40cfb8e0b',
        3
    ),
    (
        'e230e477-eff4-4285-951f-d29c227389cd',
        1
    ),
    (
        '08b058ce-a651-4a01-b6bd-29446c8663eb',
        2
    ),
    (
        'fc94d1d5-3472-4b3c-85f5-67c0ac98bbab',
        3
    ),
    (
        'a41b2831-ff79-4aa1-9315-5026817069a3',
        1
    ),
    (
        '91a54e4a-1e4c-4f4b-8da5-1d5134b1f103',
        2
    ),
    (
        '49b02f73-1b7d-44f9-8e2d-856454debc92',
        3
    ),
    (
        'b40596f6-f93e-4b9b-acac-bf9e335395ce',
        1
    ),
    (
        '332f6ea4-b9bc-4d69-94ad-dce6bcea78a5',
        2
    ),
    (
        'cadf8250-085e-4f3f-b25a-b7af2509689c',
        3
    ),
    (
        '4c5f233d-1824-4d8d-9136-52cadb8a2e93',
        1
    ),
    (
        'f2e2cedc-e6e9-47be-a0a4-0ec49d5db717',
        2
    ),
    (
        '77f85c36-7ba6-4464-be8a-45f4469a89a9',
        3
    ),
    (
        'b026242d-26a5-43ab-b0a9-5e16be94405d',
        1
    ),
    (
        '58034182-9656-42da-b68b-19370d42d530',
        2
    ),
    (
        'fe34ceee-e835-48b7-9366-70279fbd4c8d',
        3
    ),
    (
        '9c7eb1b5-34d2-42f8-83cc-78a5f8b81a6d',
        1
    );


-- =========================================================
-- PRENOTAZIONI
-- =========================================================

INSERT INTO prenotazione
(id, data_inizio, data_fine, stato, data_creazione, id_utente, id_postazione)
VALUES

(1, '2026-06-07 11:00:00', '2026-06-07 15:00:00',
 'scaduto', '2026-06-07 11:00:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 1),

(2, '2026-06-08 11:00:00', '2026-06-08 15:00:00',
 'prenotato', '2026-06-08 11:00:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 1),

(4, '2026-06-08 11:00:00', '2026-06-08 15:00:00',
 'prenotato', '2026-06-08 11:00:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 2),

(6, '2026-06-22 17:32:00', '2026-06-22 17:32:00',
 'prenotato', '2026-06-22 17:32:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(7, '2026-06-22 17:34:00', '2026-06-22 17:34:00',
 'prenotato', '2026-06-22 17:34:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 10),

(8, '2026-06-30 09:30:00', '2026-06-30 09:30:00',
 'prenotato', '2026-06-30 09:30:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 10),

(9, '2026-06-30 09:30:00', '2026-06-30 09:30:00',
 'prenotato', '2026-06-30 09:30:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 10),

(10, '2026-06-22 17:41:00', '2026-06-22 17:41:00',
 'prenotato', '2026-06-22 17:41:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 7),

(11, '2026-06-22 17:45:00', '2026-06-22 17:45:00',
 'prenotato', '2026-06-22 17:45:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(22, '2026-06-23 10:12:00', '2026-06-23 10:12:00',
 'prenotato', '2026-06-23 10:12:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 7),

(25, '2026-06-23 10:45:00', '2026-06-23 10:45:00',
 'prenotato', '2026-06-23 10:45:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(26, '2026-06-23 10:46:00', '2026-06-23 10:46:00',
 'prenotato', '2026-06-23 10:46:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(28, '2026-06-23 11:27:00', '2026-06-23 11:27:00',
 'prenotato', '2026-06-23 11:27:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(29, '2026-06-23 11:28:00', '2026-06-23 11:28:00',
 'prenotato', '2026-06-23 11:28:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(30, '2026-06-23 11:28:00', '2026-06-23 11:28:00',
 'prenotato', '2026-06-23 11:28:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 9),

(31, '2026-06-23 11:29:00', '2026-06-23 11:29:00',
 'prenotato', '2026-06-23 11:29:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 7),

(32, '2026-06-23 11:38:00', '2026-06-23 11:38:00',
 'prenotato', '2026-06-23 11:38:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(34, '2026-06-23 12:25:00', '2026-06-23 12:25:00',
 'prenotato', '2026-06-23 12:25:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 9),

(37, '2026-06-23 12:48:00', '2026-06-23 12:48:00',
 'prenotato', '2026-06-23 12:48:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(39, '2026-06-23 12:53:00', '2026-06-23 12:53:00',
 'prenotato', '2026-06-23 12:53:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(40, '2026-06-23 12:53:00', '2026-06-23 12:53:00',
 'prenotato', '2026-06-23 12:53:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 9),

(44, '2026-06-23 13:04:00', '2026-06-23 13:04:00',
 'prenotato', '2026-06-23 13:04:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 8),

(45, '2026-06-23 13:04:00', '2026-06-23 13:04:00',
 'prenotato', '2026-06-23 13:04:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 9),

(46, '2026-06-23 16:47:00', '2026-06-23 16:47:00',
 'prenotato', '2026-06-23 16:47:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(48, '2026-06-23 16:49:00', '2026-06-23 16:49:00',
 'prenotato', '2026-06-23 16:49:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(49, '2026-06-23 16:54:00', '2026-06-23 16:54:00',
 'prenotato', '2026-06-23 16:54:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(50, '2026-06-23 16:57:00', '2026-06-23 16:57:00',
 'prenotato', '2026-06-23 16:57:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(51, '2026-06-23 16:57:00', '2026-06-23 16:57:00',
 'prenotato', '2026-06-23 16:57:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(52, '2026-06-23 16:59:00', '2026-06-23 16:59:00',
 'prenotato', '2026-06-23 16:59:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(53, '2026-06-23 17:56:00', '2026-06-23 17:56:00',
 'prenotato', '2026-06-23 17:56:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(54, '2026-06-24 09:29:00', '2026-06-24 09:29:00',
 'prenotato', '2026-06-24 09:29:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(55, '2026-06-24 09:31:00', '2026-06-24 09:31:00',
 'prenotato', '2026-06-24 09:31:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(56, '2026-06-24 09:55:00', '2026-06-24 09:55:00',
 'prenotato', '2026-06-24 09:55:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(57, '2026-06-24 09:57:00', '2026-06-24 09:57:00',
 'prenotato', '2026-06-24 09:57:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(58, '2026-06-24 09:59:00', '2026-06-24 09:59:00',
 'prenotato', '2026-06-24 09:59:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(59, '2026-06-24 10:00:00', '2026-06-24 10:00:00',
 'prenotato', '2026-06-24 10:00:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 9),

(60, '2026-06-24 10:09:00', '2026-06-24 10:09:00',
 'prenotato', '2026-06-24 10:09:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(61, '2026-06-24 10:10:00', '2026-06-24 10:10:00',
 'prenotato', '2026-06-24 10:10:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(62, '2026-06-24 10:26:00', '2026-06-24 10:26:00',
 'prenotato', '2026-06-24 10:26:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(63, '2026-06-24 10:37:00', '2026-06-24 10:37:00',
 'prenotato', '2026-06-24 10:37:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(64, '2026-06-24 10:38:00', '2026-06-24 10:38:00',
 'prenotato', '2026-06-24 10:38:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(65, '2026-06-24 10:41:00', '2026-06-24 10:41:00',
 'prenotato', '2026-06-24 10:41:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(66, '2026-06-24 10:50:00', '2026-06-24 10:50:00',
 'prenotato', '2026-06-24 10:50:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(67, '2026-06-24 11:02:00', '2026-06-24 11:02:00',
 'prenotato', '2026-06-24 11:02:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(68, '2026-06-24 11:05:00', '2026-06-24 11:05:00',
 'prenotato', '2026-06-24 11:05:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(69, '2026-06-24 11:26:00', '2026-06-24 11:26:00',
 'prenotato', '2026-06-24 11:26:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(70, '2026-06-24 11:32:00', '2026-06-24 11:32:00',
 'prenotato', '2026-06-24 11:32:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(80, '2026-07-21 10:21:00', '2026-07-21 10:21:00',
 'prenotato', '2026-07-21 10:21:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 1),

(84, '2026-07-28 09:57:00', '2026-07-28 09:57:00',
 'prenotato', '2026-07-28 09:57:00',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 10),

(85, '2026-07-28 14:46:00', '2026-07-28 14:46:00',
 'prenotato', '2026-07-28 14:46:00',
 '4fc9beed-5244-4f60-90c5-5239a799b710', 7),

(86, '2026-07-29 12:51:24', '2026-07-29 12:51:24',
 'prenotato', '2026-07-29 12:51:24',
 'd78d1b8b-7439-4b07-9488-44f0f08a6293', 1);

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- DATABASE 2: USER SERVICE
-- =========================================================
CREATE DATABASE IF NOT EXISTS gestioneutente
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE gestioneutente;

DROP TABLE IF EXISTS `apiuser`;

CREATE TABLE `apiuser` (
  `username` varchar(45) NOT NULL,
  `password` varchar(65) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `apiuser`
    (`username`, `password`, `id`)
VALUES
    ('root',
     '$2a$12$mkpgdA5r.TSSt7vXwictuuW.HpJwoa4aythfegpqGcwOz2Jw.wP9y',
     1);


DROP TABLE IF EXISTS `utente`;

CREATE TABLE `utente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) DEFAULT NULL,
  `cognome` varchar(45) DEFAULT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `tipo_utente` varchar(45) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `utente` VALUES (1,'adriana','sciarratta','adriana@adriana','$2a$12$sNrc/G2K.U3TUyfxdatxNOnjQO61HyV06T4owA.x/UcrX5uqgEJk6','12345678','manager','d78d1b8b-7439-4b07-9488-44f0f08a6293'),(2,'mario','rossi','mario@mario','$2a$12$sNrc/G2K.U3TUyfxdatxNOnjQO61HyV06T4owA.x/UcrX5uqgEJk6','12345689','user','4fc9beed-5244-4f60-90c5-5239a799b710'),(54,'Luca','Rossi','luca.rossi3@example.com','$2a$10$rYHuPq.mtB8ZjJSvDaqKX./qT729jq.ZjpCICcOb1owue1hCQb.y.','3201000003','user','2a005afe-9a89-42d5-b7a5-f3bed68a18d1'),(55,'Marco','Bianchi','marco.bianchi4@example.com','$2a$10$sSbAbP9Ag/PYm.vXTXyAS.DYMuPIToCqlQT2SbHkHYN380CyaRgHq','3201000004','user','509315c5-6da9-4e30-afb9-ddf54ad29a9e'),(56,'Giulia','Verdi','giulia.verdi5@example.com','$2a$10$FPKhRYM9QbBMIpQQQDk5FuGu.RIJnDuN2r8ct3d5dRxJVDLErA.T.','3201000005','user','2a2c7901-d915-4cfb-b672-738ee91148d6'),(57,'Sara','Esposito','sara.esposito6@example.com','$2a$10$jfiMJ/GFEKdGkmDRnsN5YOmJ9YFtVON2oz3fzdiMYnzQRj2ZuALV6','3201000006','manager','ce822014-8564-4d5b-ad80-bb6d658a23cf'),(58,'Andrea','Ricci','andrea.ricci7@example.com','$2a$10$C.A7Nrx0UkpJXXk0nIq4I.HZF3rQgp3dwF8crU0jABvr8qSD6rfWe','3201000007','user','e5ef4e19-da77-448a-b066-abef6c03c0ff'),(59,'Francesca','Romano','francesca.romano8@example.com','$2a$10$qQ5VmVJoOQw6JhqevY6XHOeWEDLrXqv3qxGEn8vTVfX5PTbNdicem','3201000008','user','1ed66226-2da6-471c-98c8-75372e6cc525'),(60,'Matteo','Gallo','matteo.gallo9@example.com','$2a$10$VhRPntTG6B4dc5XmF7wqHuKOb7ZdWrczg8M2d8AT5HA.QHpBDgh7m','3201000009','user','e78f0216-4183-4f50-8d9a-5c331a344ff7'),(61,'Chiara','Conti','chiara.conti10@example.com','$2a$10$2NL.FfwR.MhFq5iKxpE4yuG1I7.PwpcEvjXtcuth.sJrlCrCciCDi','3201000010','manager','c533775c-da47-48cd-be4c-7659d55824a8'),(63,'Davide','Ferrari','davide.ferrari11@example.com','$2a$10$wcuT7mD0tALtrYWXRj3Rfu8Ntp7a3AAiK/8/5pAPLkt1nFIHa2Fj.','3201000011','user','69ae8f6b-36cc-47e2-b2cf-e014cf656c21'),(64,'Elisa','Marini','elisa.marini12@example.com','$2a$10$M2KS0AEPU6pZ2iAymJBqwOVw.djFRGSkwxF2HMOxGBfcbkIuGrIfm','3201000012','user','6edf589e-0636-40a6-80de-61fb563b3554'),(65,'Simone','Fontana','simone.fontana13@example.com','$2a$10$Ps30J1Y9kCdG5pmBrrr3zOu6oJwjkprnD7aJuKNp/IaqR9rpBkzia','3201000013','user','45843668-93f6-4c11-9359-3eba9f120481'),(66,'Valentina','Riva','valentina.riva14@example.com','$2a$10$jZV.zS1aQtIrLELPsjdr8egZYlKW.RUW5ZeDORV/uUUmzcoi66vC6','3201000014','manager','35f691b1-ef89-4551-b1c5-f267ec2973c4'),(67,'Alessandro','Serra','alessandro.serra15@example.com','$2a$10$KBBiCV.iIsO2XT.vkj9/MeAKtVQNA8Q2lA2wXAjs6R2hVE8jF0Z2W','3201000015','user','e8e76548-fef0-4817-8fda-1911405e2668'),(68,'Martina','Greco','martina.greco16@example.com','$2a$10$uBLJOZgA4865qBS2qLw/K.i8kmGsWgrNMJmdz9IrQPc6Dw2eeW9.W','3201000016','user','fdbb01fc-3e93-41b5-bfc2-b74ac513aafa'),(69,'Federico','Moretti','federico.moretti17@example.com','$2a$10$iEtwszEGhDccsSLRQvJXFuEBLbBjH2zyOdx8UEVV5d1FFxDaEDz9G','3201000017','user','aaa2b221-a4dd-4b61-b234-47ea50abd75a'),(70,'Ilaria','Barbieri','ilaria.barbieri18@example.com','$2a$10$HtF/zDZ2cMX0nV0BrV8RReA79rZ15G6kgnttcCSj/A6P3a9ZNgbBy','3201000018','manager','d2551d1c-778a-4f0d-a338-6651c1d51cad'),(71,'Gabriele','Lombardi','gabriele.lombardi19@example.com','$2a$10$rtC.xgp4Imv9.1JxSQu92uqxbg1Ob4nEczLiJjO1ZynM9MWLJ.UKa','3201000019','user','f550dfdb-1809-4cc1-884c-c5cfffd19d0e'),(72,'Beatrice','Santoro','beatrice.santoro20@example.com','$2a$10$Wh.na1GQ4BWmZwxx9xOzN.m3O8ESmozyDtOqRzqnylL5lCLcGYBrS','3201000020','user','59e446c0-be73-489a-b46b-99e96d641579'),(73,'Riccardo','Testa','riccardo.testa21@example.com','$2a$10$q5ERHPjVabXJFCqBHpygP.VuSu9JRcf8icJrpBbj3XAgnh/zdXTFS','3201000021','user','932fd5cd-dcf1-4eea-9781-822b8a8a9cfc'),(74,'Camilla','De Luca','camilla.deluca22@example.com','$2a$10$bFuk/LWUv7P9D42lFOo1U.7v2hbwbwz0iEoUUX04r0n/AWewPZHXK','3201000022','manager','9f665233-2901-4215-b110-07bac1787fce'),(75,'Lorenzo','Pellegrini','lorenzo.pellegrini23@example.com','$2a$10$uMLzppjD8k1cIeYTns9RD.Ee5GaRFiaH.qlyxsibmXhSLtGw3LEVy','3201000023','user','36b10dd6-afb6-4153-9ce4-3fb6f90d708d'),(76,'Noemi','Russo','noemi.russo24@example.com','$2a$10$Xa2dC48TmCHjvdB.zhPBhOK.8c3dMkU539YypPVc601RR/lvO5rDy','3201000024','user','2aa290db-9e60-416e-9c2f-9c8189a1352d'),(77,'Emanuele','Caruso','emanuele.caruso25@example.com','$2a$10$9cJYiYYiH/p0aezuRsYTRubY9WdK0Syb1jKO4NF8zBnRCE6psW3Hi','3201000025','user','c70048a5-5447-4972-9186-7ac54537e5ff'),(78,'Stefano','Amato','stefano.amato26@example.com','$2a$10$y2Iomtq.V9bc072CM9M1EeMl76aPh3KLaMEHvtV.Rqib0T4QjtX9u','3201000026','user','155f6107-0306-42b8-942c-fff218825c5f'),(79,'Arianna','Colombo','arianna.colombo27@example.com','$2a$10$P4oU4MblqbrIzx.eQEVWE.bh6p2h8IG8gd14XZlc1NYR6EsUL7Xoy','3201000027','user','7f5386a2-53c8-4eaa-b304-35e43e8cc5cb'),(80,'Nicola','Romano','nicola.romano28@example.com','$2a$10$/Cw/OnVegronSi523.s9Q.X.Pu52IU1XHNmWkhdpJ8ALM02Ah4QaK','3201000028','manager','0a88c511-3996-41c8-97fd-c6e088fc52ca'),(81,'Federica','Martini','federica.martini29@example.com','$2a$10$ve09Fl5iaCs2J/E5xb78Eeg1dGCehW15nnAFAlRtgXw7CKzUhTRTu','3201000029','user','bcca474d-4018-475d-a4ef-1e0f3b9f62a5'),(82,'Tommaso','Ferrara','tommaso.ferrara30@example.com','$2a$10$jbyrI/oPUIcPGoOPGQOGnuRZhFoYcN29mjc4dB9sTBTx1n.eSKHE6','3201000030','user','ea0c718c-1473-4ee7-aac1-189df590be20'),(83,'Aurora','Rossetti','aurora.rossetti31@example.com','$2a$10$w2EA.EUa8z2ScvRr.nvXY.CpgSarF.dQMK3GfDVhuNmV6MS4QK2ou','3201000031','user','eb7c191b-cdbc-4c50-bfab-58b3cd0d9009'),(84,'Pietro','Marchetti','pietro.marchetti32@example.com','$2a$10$6.N7HPjze6uHs2kMMEvwn.mYEPHOQKglpwZtkFqtnZK1KWFrTeWPG','3201000032','manager','67479929-d3a7-4596-a17d-a6edd03dc67e'),(85,'Caterina','Valenti','caterina.valenti33@example.com','$2a$10$XvZUmN.WRjyQUARa3MEtkOFQyuQu.0h1LD2P4DAY90k5RMWbCiKBa','3201000033','user','bb3ec532-914e-4be2-bfc8-96a285e13d0b'),(86,'Leonardo','Basile','leonardo.basile34@example.com','$2a$10$7EDe55sVjH7a8eKNgjvpO.SGGAgg8nqXDPn9O8TXKG0srtwdzsQam','3201000034','user','9f213c13-4f60-4732-a076-33f0a1baef6f'),(87,'Marta','Fiore','marta.fiore35@example.com','$2a$10$.HvCAvB6Gxguo7XCZR5a5.ytEkdjedvHjtWjjF5R8qG4A7k9TcQ4q','3201000035','user','07cfbfe2-beb0-4b55-92f8-557a4deeeaa0'),(88,'Salvatore','Rizzi','salvatore.rizzi36@example.com','$2a$10$koJIOAtxvZIMBIjnCTAJhupiX1jkM3/pGDdk1R6MNCewPIjKocy6K','3201000036','manager','ef53d8b9-4949-408b-8a6b-9479de1a547e'),(89,'Alice','Monti','alice.monti37@example.com','$2a$10$/PDCUao7IzCNx3JXm5Mjouf8BvSexrj9Cc7b.5P6fzdATPiCP7aHO','3201000037','user','0fc2f09b-1a59-48e3-9bef-ef0c2adb7a73'),(90,'Fabio','Orlando','fabio.orlando38@example.com','$2a$10$SyOhuu0L3Mlp41D2zQKVReiOwwDtPaGlG0kFfuXXzUYsoMPM82H6y','3201000038','user','632f6075-9e11-4c13-a31b-63ec32b5fe49'),(91,'Giorgia','Vitale','giorgia.vitale39@example.com','$2a$10$N4BxBLViGxiulrmLit.DTe3wZ.B7wWhm46ApOyEf0y/xbHG4Cd/hC','3201000039','user','2697be4a-6b8a-4f8a-86ee-136bcc59a1d1'),(92,'Christian','Ferri','christian.ferri40@example.com','$2a$10$.lOCF5dmcYbRgZGxj0P6FugjZrBXFXKBKQp6IPrODxfljUp8b8OeW','3201000040','manager','d8be3569-bf32-412f-8840-11b6f1283c93'),(93,'Silvia','Pagano','silvia.pagano41@example.com','$2a$10$OzrALfNwxRp2J2lSB7uYc.L/QCVrolRB0qw5N6BT1yrBWeP10x2EG','3201000041','user','6b7d1fdd-79a7-4dd9-888d-04105d172374'),(94,'Massimo','Longo','massimo.longo42@example.com','$2a$10$to1CqGBfIT2o6hs03n0hcONRZT/2KQpGsFUaXil3hSNzfGTYAhngW','3201000042','user','ec609a5b-7b5a-43a5-8228-c6d4f797c121'),(95,'Elena','Grassi','elena.grassi43@example.com','$2a$10$05k8fhyuek6F21Wikgi7Ru8v2x0nAdHbdXxxJe0IuQwHs.BNGIPSO','3201000043','user','5c025d16-c56f-4b5c-9641-719f8c59dbdb'),(96,'Daniele','Rinaldi','daniele.rinaldi44@example.com','$2a$10$kzmWUZGcm2wpl9jABCDI4.cSfgvVrLhVkuepMxIOsRha7FG4u.x/K','3201000044','manager','ab0e1ec1-27dd-4b03-8a61-ec342069ba47'),(97,'Claudia','Marino','claudia.marino45@example.com','$2a$10$DgKbyqF3Y/ZFt.qGA6deN.nFkC.cpmikmfW0gWbZC2JMJDYLmqAd6','3201000045','user','270faa75-4e62-4c88-95e2-9d09403b347f'),(98,'Giacomo','De Angelis','giacomo.deangelis46@example.com','$2a$10$Px1uf.6R8EWxlSxfeFsa6Ol9n0KLJQ/q/97TfP45EeTYv9tlmZ.oq','3201000046','user','09b73c2e-b304-4ce8-bfca-cee5050403b4'),(99,'Serena','Mancini','serena.mancini47@example.com','$2a$10$8i23T9PYa/AlQFUIFhjmEOA07BQO4GEbhnhY1W6gBip.K6IzamCEq','3201000047','user','bc3748f3-9b60-417b-9d3d-5c675e92fe62'),(100,'Marco','Farina','marco.farina48@example.com','$2a$10$UERpCcloqI.JjG8cSQ1ai.0pexGE5S7W/l4AJb6JHI1SQBcNoRnsS','3201000048','manager','818cfe82-101d-4798-bf95-8ffeb0aa63b1'),(101,'Veronica','Russo','veronica.russo49@example.com','$2a$10$sT5otBgswZY0LN9lKXV8SO.0ZT9/2mzsRoS2bwC1GlXG9zMMCqmiu','3201000049','user','d23078d3-5f8b-4e2c-8e56-b74a1adf10c4'),(102,'Antonio','Mariani','antonio.mariani50@example.com','$2a$10$LUD/6yApUjWMpcRvo9bVoucT9WIdHecPHWNZk0fEKA7cJ7LQAodTS','3201000050','user','1de24f46-5ab8-4134-850c-0c5a4fc713ec'),(103,'Irene','Leone','irene.leone51@example.com','$2a$10$hjMzBTnPpkfTMptZbL3z9.pYC99W9x8PJSswUYsuQp625aRz.3Wpm','3201000051','user','2364c1d8-c3c3-4c26-983d-138dfe96c1bd'),(104,'Fabiana','Messina','fabiana.messina52@example.com','$2a$10$z8dS5FqbVm8xDBBpU2VjKOtTHbDyeH5Qe/KPJ5MHjlGoEQk5e85im','3201000052','manager','41c2f9f9-0544-46d2-acf7-0402d4e23b10'),(105,'Cristian','Martino','cristian.martino53@example.com','$2a$10$sy7rflBO9K8R268pqTEH4.SUk8vBPPla6KCIix9OQ3/8rTrHvMptu','3201000053','user','34540c35-49fa-4871-a9c9-392b0671bf3c'),(106,'Noemi','Fontana','noemi.fontana54@example.com','$2a$10$NTdbFv6uWwPaqUjmAQz2Vegoh1QJXyLiYfZXrgFIODUJ3X2jTXyRu','3201000054','user','ad60ebab-e1bb-4e95-91f5-88e6960c5010'),(107,'Edoardo','Gentile','edoardo.gentile55@example.com','$2a$10$vefuQB5dSgKNdcz81OklgepU.7t12Glsm0Lm8UKJt5hSK9feI3oTu','3201000055','user','eaba0cb9-b6b6-4aad-95c1-97ab52fe16fa'),(108,'Luisa','Piras','luisa.piras56@example.com','$2a$10$XbeTsF5rZr4jaLqIhVDj0ORrFS6uPH.QA8d3bZmoStzU6HK2GYPBe','3201000056','manager','8222d42a-599b-42bb-9173-289e06de8984'),(109,'Roberto','Marchetti','roberto.marchetti57@example.com','$2a$10$lNv3cQGl.SqVjEjHRFhUXeVF/1aLK3JPrv/tDSFUtCQhHBtZLcWIi','3201000057','user','0f4d13af-9fa1-4871-bcd0-05bd3e119deb'),(110,'Alessia','Carbone','alessia.carbone58@example.com','$2a$10$JkD3aw9PEKzowAksFwRjyu87Ii9S8yRXqTH3pSQvuk6wfQ1IKoB..','3201000058','user','2bca4392-c001-4e15-a2fd-f91eb2081838'),(111,'Vincenzo','Palumbo','vincenzo.palumbo59@example.com','$2a$10$FJ6UFiHHAhi4ONV4wKwx9.7rQ8wuiOIbJZF9amCafqsG4FoVU9xZW','3201000059','user','5f2f9c1e-566d-4972-be86-85bfcfd8c2ce'),(112,'Greta','Sorrentino','greta.sorrentino60@example.com','$2a$10$e01jQeGGOjs1FiKdqsVvZulwEkw6eQGiY/hFIpwUUHwWArnF6R2zu','3201000060','manager','bb54e937-b706-4a56-9609-eb565f2661b5'),(113,'Michele','Ruggiero','michele.ruggiero61@example.com','$2a$10$P3ggl0o5Q9dWHKyFu5TBP.qOe3QXbAkcnRZQgK.iamLr6jOAZ2XlO','3201000061','user','02090147-4d5f-43e1-b8f1-25c8fecf2869'),(114,'Beatrice','Donati','beatrice.donati62@example.com','$2a$10$F0WvXWFScd/gKI959BKEE.eBA13I5ac1uQuHRa8J9TX/Nu0lFLzfu','3201000062','user','339fde4b-9f91-43c8-a01b-335338599f61'),(115,'Andrea','Bernardi','andrea.bernardi63@example.com','$2a$10$.qZOxqRvjEQHzWzMXkZ3R.HE31djUd/bqUQLNMVJtTAbuDWMtMKWq','3201000063','user','a73a14aa-c8ea-47a2-9d47-77484d22dd44'),(116,'Federica','Landi','federica.landi64@example.com','$2a$10$XNUDkci2kcBkBYTgbCKdjOoJivlAMN/CPeixf7mx/Cr182AAlzxE6','3201000064','manager','b818ec4b-d61f-4b3a-8ea7-ef8076b496f7'),(117,'Nicolò','Coppola','nicolo.coppola65@example.com','$2a$10$I.Uddl9pDcCCaLViLaxR5u59ffXWQA0wBTw1Xiqo8xql2/z8/FgT2','3201000065','user','b65ecd91-5188-4146-aae0-cc887ac3ffad'),(118,'Matilde','Marino','matilde.marino66@example.com','$2a$10$MDF9vLmaokb8Cjp8ROMB4uE0L2eMYp11y5FM7bisHjNvVnM4bNQry','3201000066','user','a69a228d-4b74-46da-8988-22ebbba29fc8'),(119,'Luca','Bellini','luca.bellini67@example.com','$2a$10$Zwywkcz8s9kO1a0TPQlWFO4sfDDkImhQDxin01JWhTDSU08tVepSO','3201000067','user','ef4eb5a3-a1c3-4757-9702-41d4c4058fe1'),(120,'Sofia','Martini','sofia.martini68@example.com','$2a$10$Jq9McRf1maNcewsO0FoXtOt9MIigu.2ccAKuvbmNCxlKMjgyOnyMG','3201000068','manager','defa0883-d9d6-4706-bf79-b5d351246db7'),(121,'Gabriele','Rosati','gabriele.rosati69@example.com','$2a$10$DsxvkQlnOQTFs6HR/KKwTOt6AakVDJgFaXeyYDFemHOp58EkJD8bO','3201000069','user','c6181c2f-7bf5-4eb0-83ca-4640e4d05cc8'),(122,'Alice','Fabbri','alice.fabbri70@example.com','$2a$10$GULgdHWuhOSLjCJv.GQufelM2ArTnA9rikGfQ15zCStEVtWB.Xkuy','3201000070','user','2079e172-feb9-46d2-b842-b88a494718ba'),(123,'Dario','Costantini','dario.costantini71@example.com','$2a$10$Ul1QUeBdthGySppC6HF6CuIVq8sJaKsK6OAeKCeLw9Oe4.KMMpVnS','3201000071','user','b2bf5d16-b1a9-4e12-ad83-17013a228f48'),(124,'Elisa','Morelli','elisa.morelli72@example.com','$2a$10$mK7.3Rlti6PIn9fFpswOHOoTAvAyfal7PFF7BE1arz4/oasdcfknG','3201000072','manager','00116230-7470-4b6b-8489-218be1df1891'),(125,'Fabio','Russo','fabio.russo73@example.com','$2a$10$IjUSmdB7/EBwMkesuACQVOepO8JbC1zdTPA/nIj4LxMLmoFS4D66e','3201000073','user','b60a7f3a-43a5-47d4-a8c2-143156100aae'),(126,'Chiara','Silvestri','chiara.silvestri74@example.com','$2a$10$hDgunrJ8EdIfWW0ikhCTEOLxnvUVi7yVsI9RW4PAGgf/dlxFJhWhS','3201000074','user','6ffce99e-9dff-4b5c-906d-a003600c29d3'),(127,'Matteo','Valentini','matteo.valentini75@example.com','$2a$10$UJ8i3Jbod2dBzdwvq1WsOeoPr3AV0FXrjc31jBx.2F8pFVcC0I3bK','3201000075','user','c96d5ac0-1f90-4ddd-94bb-8663f58e164a'),(128,'Sara','Ferraro','sara.ferraro76@example.com','$2a$10$rS6d0FdqUENptQJwvQc0UOGRi1FFlWbq.UQPKuVqAGHdcyJS.YBV.','3201000076','manager','591b63f7-ee21-4f00-a1b0-53c3af9c6362'),(129,'Lorenzo','Guidi','lorenzo.guidi77@example.com','$2a$10$sC9W.maYOLVO6XAIENo.4uQ8BGXBnnZN8ZmWQswt3gPqLsY4pmE8e','3201000077','user','062b8311-2a43-4c89-9eae-62bfcd7f8458'),(130,'Camilla','Romani','camilla.romani78@example.com','$2a$10$pc7AzTQkt59JHjuFqCHPDufEvVwISgKNXIXPY8Sh0MOTRkgfX5wWa','3201000078','user','33efd3ac-9110-4909-b46f-e7f551701fe1'),(131,'Simone','Parisi','simone.parisi79@example.com','$2a$10$NWxwJrTmiwJFbJX6VRHwy.H3lc0Q4A7NSCFe9AUrKJWmzF31n0Ple','3201000079','user','2c6ef2f7-d5b2-440d-98c9-764cda4ec84e'),(132,'Valentina','Marchetti','valentina.marchetti80@example.com','$2a$10$joqkozo4fEhihrrf.CYi.uElAZnJ0m56PJug3I803gIe5sMCBA9cO','3201000080','manager','426d6ad8-6ead-487c-9bc9-1ed42aaead61'),(133,'Pietro','Esposito','pietro.esposito81@example.com','$2a$10$t6iYwzM.MTTHI6MsRQ/aJ.U3vuXk93HQJnYtSMCpQob6KkJ8zKxVW','3201000081','user','3bddc13e-71a1-401a-bb06-52935e0e2ad7'),(134,'Giulia','Rinaldi','giulia.rinaldi82@example.com','$2a$10$Y2Igo8LjZjoj9GqupZDLguBxjUfIOFbngbYSn3.ZebkNrbnewuXBy','3201000082','user','cf342cdd-b40f-4205-9504-d9e088ea015a'),(135,'Andrea','Colombo','andrea.colombo83@example.com','$2a$10$IyCQDJJloA29UWGqNLbAWeBNksNBYgPyfMa/YhjlYE0Ck8cFswZJG','3201000083','user','a63e9b11-fba5-4a36-b8ce-3e044e046e08'),(136,'Martina','Galli','martina.galli84@example.com','$2a$10$8429EbzMVKIgklXvbrhIB.pb4IMkeQDiR45Af.i9VYbh5R5y8Faui','3201000084','manager','60bfcca6-2606-452f-88ab-0674eb9a06b8'),(137,'Davide','Conti','davide.conti85@example.com','$2a$10$60EBdrg6pyy7CGtDsC2VWeaw6ngG2gZzxH.YGiQ2eWwisBg54RACC','3201000085','user','9333d7b2-839f-41f3-bcd6-c6c40cfb8e0b'),(138,'Francesca','Ricci','francesca.ricci86@example.com','$2a$10$6lM2PAkEoUBeI31TUkI0duettrvmLEJTCqFnlx7bSioDEJIcWkPq.','3201000086','user','e230e477-eff4-4285-951f-d29c227389cd'),(139,'Marco','Marino','marco.marino87@example.com','$2a$10$S5GnrdIVCN0t/E9IIRDqd.rKrogA4l9yR/kNWEhidytf.n/3OidGi','3201000087','user','08b058ce-a651-4a01-b6bd-29446c8663eb'),(140,'Elena','Greco','elena.greco88@example.com','$2a$10$C.3MJLzb6DusLvwyAU4rreOixnz9g1CnoqyEtdspJrb/qGtFwWsAW','3201000088','manager','fc94d1d5-3472-4b3c-85f5-67c0ac98bbab'),(141,'Alessandro','Fontana','alessandro.fontana89@example.com','$2a$10$WPwGmmVmX11uUupvF.hnv.c9DMZnQAqgGHH1UIrwlatBaJhUbylDe','3201000089','user','a41b2831-ff79-4aa1-9315-5026817069a3'),(142,'Beatrice','Serra','beatrice.serra90@example.com','$2a$10$aR6qsILjIIr/FZQ14BUJ7eKuJ6ujQyKPgx1I8tezxJX7eo73yUm8W','3201000090','user','91a54e4a-1e4c-4f4b-8da5-1d5134b1f103'),(143,'Federico','Martini','federico.martini91@example.com','$2a$10$etmnEiFbVfZC0ksxDcS2uOtZSNriLlkftl2PWwcOJVBeETAa8c9c2','3201000091','user','49b02f73-1b7d-44f9-8e2d-856454debc92'),(144,'Noemi','DeLuca','noemi.deluca92@example.com','$2a$10$PCtzQ8HrvJukCS0Xf3fa2.aaE9STBWoOuRrOw0jcraoBNvQfS43fS','3201000092','manager','b40596f6-f93e-4b9b-acac-bf9e335395ce'),(145,'Gabriele','Lombardi','gabriele.lombardi93@example.com','$2a$10$AgurNRbYZkh7RRd7IHQVTev.ty9rlCWBe6bbhgH4ksZEIfBDFDMq.','3201000093','user','332f6ea4-b9bc-4d69-94ad-dce6bcea78a5'),(146,'Aurora','Ferri','aurora.ferri94@example.com','$2a$10$iBseCLIVe8fOtLN/gmIhpOKcYMfSxEGmLpgkRZFuJradQELlXiaea','3201000094','user','cadf8250-085e-4f3f-b25a-b7af2509689c'),(147,'Riccardo','Caruso','riccardo.caruso95@example.com','$2a$10$5sss94dShCixhsQgCjlGUOEsnGU.2JhxL7TzVGFlAUrRJLVfYXT82','3201000095','user','4c5f233d-1829-4d8d-9136-52cadb8a2e93'),(148,'Sofia','Mancini','sofia.mancini96@example.com','$2a$10$QpzxUjFJYb9qV.KO3ijFaukms04ZWYL1orq6YKDr8kdHfUmhNV9zy','3201000096','manager','f2e2cedc-e6e9-47be-a0a4-0ec49d5db717'),(149,'Tommaso','Leone','tommaso.leone97@example.com','$2a$10$xljxZeulCdJEQUfZCsdAxeiR4NSXSvfufQVmyOxQFDN5.n5rdRvem','3201000097','user','77f85c36-7ba6-4464-be8a-45f4469a89a9'),(150,'Alice','Giordano','alice.giordano98@example.com','$2a$10$ROcIS338UjwC4fEoFAT1Lel./4wA7F85h4b5B.MENvZjHd9IOXsLK','3201000098','user','b026242d-26a5-43ab-b0a9-5e16be94405d'),(151,'Nicolo','Bianco','nicolo.bianco99@example.com','$2a$10$uBG9QGa6bpWr6AGEBIa6gucmPi4TchF4HOhSWyQaZ9MLVii/bS6za','3201000099','user','58034182-9656-42da-b68b-19370d42d530'),(152,'Emma','Testa','emma.testa100@example.com','$2a$10$xdPAHkk9.YNbuB.XXHMvuOrBlh/b7bdQQZOV9645x7QGlDInkcft6','3201000100','manager','fe34ceee-e835-48b7-9366-70279fbd4c8d'),(153,'Leonardo','Villa','leonardo.villa101@example.com','$2a$10$h5s3SeHWWU59bNcGdudMuuNuYV3.hw7jlpMTowkKg9oguorFxyt2y','3201000101','user','9c7eb1b5-34d2-42f8-83cc-78a5f8b81a6d');

-- ============================================================
-- DATABASE NOTIFICATION SERVICE
-- ============================================================

CREATE DATABASE IF NOT EXISTS notificadb
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE notificadb;


-- ============================================================
-- TABLE: tipo
-- ============================================================

DROP TABLE IF EXISTS `tipo`;

CREATE TABLE `tipo` (
    `id` int NOT NULL AUTO_INCREMENT,
    `nome` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB
  AUTO_INCREMENT=4
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- ============================================================
-- DATA: tipo
-- ============================================================

INSERT INTO `tipo` (`id`, `nome`)
VALUES
    (1, 'EMAIL'),
    (2, 'SMS'),
    (3, 'POPUP');


-- ============================================================
-- TABLE: configuration
-- ============================================================

DROP TABLE IF EXISTS `configuration`;

CREATE TABLE `configuration` (
    `id` int NOT NULL AUTO_INCREMENT,
    `topic` varchar(255) DEFAULT NULL,
    `id_tipo` int DEFAULT NULL,
    `properties` varchar(255) DEFAULT NULL,
    `values` varchar(255) DEFAULT NULL,

    PRIMARY KEY (`id`),

    KEY `type_idx` (`id_tipo`),

    CONSTRAINT `id_tipo`
        FOREIGN KEY (`id_tipo`)
        REFERENCES `tipo` (`id`)
) ENGINE=InnoDB
  AUTO_INCREMENT=2
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- ============================================================
-- DATA: configuration
-- ============================================================

INSERT INTO `configuration`
    (`id`, `topic`, `id_tipo`, `properties`, `values`)
VALUES
(
    1,
    'notification',
    1,
    'mail.smtp.host;mail.smtp.port;mail.smtp.auth;mail.smtp.socketFactory.port;mail.smtp.socketFactory.class',
    'smtp.gmail.com;465;true;465;javax.net.ssl.SSLSocketFactory'
);


-- ============================================================
-- TABLE: mail_template
-- ============================================================

DROP TABLE IF EXISTS `mail_template`;

CREATE TABLE `mail_template` (
    `id` int NOT NULL AUTO_INCREMENT,
    `body` text,
    `subject` varchar(255) DEFAULT NULL,

    PRIMARY KEY (`id`)
) ENGINE=InnoDB
  AUTO_INCREMENT=2
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- ============================================================
-- DATA: mail_template
-- ============================================================

INSERT INTO `mail_template`
    (`id`, `body`, `subject`)
VALUES
(
    1,
    '<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Prenotazione effettuata</title>
</head>
<body>

    <p>
        Ciao <span th:text="${name}">Adriana</span>,
    </p>

    <p>
        la tua prenotazione è stata effettuata per il giorno
        <strong th:text="${#temporals.format(subscriptionDate, ''dd-MM-yyyy'')}">
            28-12-2012
        </strong>
        alle ore
        <strong th:text="${#temporals.format(subscriptionDate, ''HH:mm'')}">
            14:30
        </strong>.
    </p>

    <p>Con i seguenti dati:</p>

    <ul>
        <li>
            Città:
            <span th:text="${citta}">Reading</span>
        </li>
        <li>
            Indirizzo:
            <span th:text="${indirizzo}">Via Roma 10</span>
        </li>
        <li>
            Numero stanza:
            <span th:text="${nStanza}">101</span>
        </li>
    </ul>

    <p>
        Grazie per aver effettuato la prenotazione.
    </p>

    <p>
        Cordiali saluti,<br>
        <em>Notification Service</em>
    </p>

</body>
</html>',
    'test mail'
);

