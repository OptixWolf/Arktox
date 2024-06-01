use arktox;

DROP VIEW IF EXISTS view_bestaetigte_archiv_eintraege;
DROP VIEW IF EXISTS view_bestaetigte_skript_eintraege;
DROP VIEW IF EXISTS view_unbestaetigte_archiv_eintraege;
DROP VIEW IF EXISTS view_unbestaetigte_skript_eintraege;
DROP VIEW IF EXISTS view_archiv_eintraege_approval_status;
DROP VIEW IF EXISTS view_skripte_approval_status;
DROP VIEW IF EXISTS view_archiv_kommentare_comment;
DROP VIEW IF EXISTS view_skripte_kommentare_comment;
DROP VIEW IF EXISTS view_nutzerdaten_reset_password;
DROP VIEW IF EXISTS view_profil_edit;
DROP TRIGGER IF EXISTS before_update_profil;
DROP TRIGGER IF EXISTS before_insert_archiv_eintrag;
DROP TRIGGER IF EXiSTS before_insert_skripte;
DROP PROCEDURE IF EXISTS proc_new_profile;
DROP ROLE IF EXISTS 'moderator';
DROP ROLE IF EXISTS 'administrator';
DROP USER IF EXISTS 'testmoderator'@'%';
DROP USER IF EXISTS 'testadministrator'@'%';

CREATE VIEW view_bestaetigte_archiv_eintraege AS
SELECT * from archiv_eintraege
WHERE approval_status = '1';

CREATE VIEW view_bestaetigte_skript_eintraege AS
SELECT * from skripte
WHERE approval_status = '1';

CREATE VIEW view_archiv_eintraege_approval_status AS
SELECT archiv_item_id, approval_status
FROM archiv_eintraege;

CREATE VIEW view_skripte_approval_status AS
SELECT skript_id, approval_status
FROM skripte;

CREATE VIEW view_archiv_kommentare_comment AS
SELECT comment_id, comment
FROM kommentare_archiv;

CREATE VIEW view_skripte_kommentare_comment AS
SELECT comment_id, comment
FROM kommentare_skripte;

CREATE VIEW view_nutzerdaten_reset_password AS
SELECT user_id, password_hash
FROM nutzerdaten;

CREATE VIEW view_profil_edit AS
SELECT profile_id, username, profilbild_link, profilbanner_link, about_me
FROM profil;

DELIMITER //

CREATE TRIGGER before_update_profil
BEFORE UPDATE ON profil
FOR EACH ROW
BEGIN
    DECLARE invalid_profilbanner BOOLEAN;
    DECLARE invalid_profilbild BOOLEAN;

    SET invalid_profilbanner = 
        NEW.profilbanner_link LIKE '%iplogger.com%' OR
        NEW.profilbanner_link LIKE '%maper.info%' OR
        NEW.profilbanner_link LIKE '%iplogger.ru%' OR
        NEW.profilbanner_link LIKE '%iplogger.co%' OR
        NEW.profilbanner_link LIKE '%2no.co%' OR
        NEW.profilbanner_link LIKE '%yip.su%' OR
        NEW.profilbanner_link LIKE '%iplogger.info%' OR
        NEW.profilbanner_link LIKE '%ipgrabber.ru%' OR
        NEW.profilbanner_link LIKE '%ipgraber.ru%' OR
        NEW.profilbanner_link LIKE '%iplis.ru%' OR
        NEW.profilbanner_link LIKE '%02ip.ru%' OR
        NEW.profilbanner_link LIKE '%ezstat.ru%' OR
        NEW.profilbanner_link LIKE '%iplog.co%' OR
        NEW.profilbanner_link LIKE '%iplogger.cn%' OR
        NEW.profilbanner_link LIKE '%grabify.link%' OR
        NEW.profilbanner_link LIKE '%iplogger.org%' OR
        NEW.profilbanner_link LIKE '%wl.gl%' OR
        NEW.profilbanner_link LIKE '%ed.tc%' OR
        NEW.profilbanner_link LIKE '%bc.ax%';

    SET invalid_profilbild = 
        NEW.profilbild_link LIKE '%iplogger.com%' OR
        NEW.profilbild_link LIKE '%maper.info%' OR
        NEW.profilbild_link LIKE '%iplogger.ru%' OR
        NEW.profilbild_link LIKE '%iplogger.co%' OR
        NEW.profilbild_link LIKE '%2no.co%' OR
        NEW.profilbild_link LIKE '%yip.su%' OR
        NEW.profilbild_link LIKE '%iplogger.info%' OR
        NEW.profilbild_link LIKE '%ipgrabber.ru%' OR
        NEW.profilbild_link LIKE '%ipgraber.ru%' OR
        NEW.profilbild_link LIKE '%iplis.ru%' OR
        NEW.profilbild_link LIKE '%02ip.ru%' OR
        NEW.profilbild_link LIKE '%ezstat.ru%' OR
        NEW.profilbild_link LIKE '%iplog.co%' OR
        NEW.profilbild_link LIKE '%iplogger.cn%' OR
        NEW.profilbild_link LIKE '%grabify.link%' OR
        NEW.profilbild_link LIKE '%iplogger.org%' OR
        NEW.profilbild_link LIKE '%wl.gl%' OR
        NEW.profilbild_link LIKE '%ed.tc%' OR
        NEW.profilbild_link LIKE '%bc.ax%';

    IF invalid_profilbanner THEN
        SET NEW.profilbanner_link = OLD.profilbanner_link;
    END IF;

    IF invalid_profilbild THEN
        SET NEW.profilbild_link = OLD.profilbild_link;
    END IF;
END //

CREATE TRIGGER before_insert_archiv_eintrag
BEFORE INSERT ON archiv_eintraege
FOR EACH ROW
BEGIN
    SET NEW.approval_status = 0;
END //

CREATE TRIGGER before_insert_skripte
BEFORE INSERT ON skripte
FOR EACH ROW
BEGIN
    SET NEW.approval_status = 0;
END //

CREATE PROCEDURE proc_new_profile(IN user_id INT, IN first_name VARCHAR(255), IN last_name VARCHAR(255), IN username VARCHAR(255))
BEGIN
    DECLARE profileNr INT;

    IF EXISTS (SELECT * FROM profil p WHERE p.username = username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Benutzername ist vergeben';
    END IF;

    SET profileNr = (SELECT MAX(profile_id) FROM profil) + 1;
    
    INSERT INTO profil(profile_id, user_id, first_name, last_name, username) VALUES(profileNr, user_id, first_name, last_name, username);

END //

DELIMITER ;

CREATE ROLE 'moderator';
CREATE ROLE 'administrator';
CREATE USER 'testmoderator'@'%' IDENTIFIED BY 'moderatorarktox2024';
CREATE USER 'testadministrator'@'%' IDENTIFIED BY 'administratorarktox2024';

GRANT UPDATE, SELECT ON arktox.view_archiv_eintraege_approval_status TO 'moderator';
GRANT UPDATE, SELECT ON arktox.view_skripte_approval_status TO 'moderator';
GRANT ALL ON arktox.view_archiv_kommentare_comment TO 'moderator';
GRANT ALL ON arktox.view_skripte_kommentare_comment TO 'moderator';

GRANT 'moderator' TO 'administrator';
GRANT ALL ON kategorien_archiv TO 'administrator';
GRANT ALL ON kategorien_skripte TO 'administrator';
GRANT UPDATE, SELECT ON arktox.view_nutzerdaten_reset_password TO 'administrator';
GRANT UPDATE, SELECT ON arktox.view_profil_edit TO 'administrator';
GRANT ALL ON version_history TO 'administrator';

GRANT 'moderator' TO 'testmoderator'@'%';
GRANT 'administrator' TO 'testadministrator'@'%';

FLUSH PRIVILEGES;