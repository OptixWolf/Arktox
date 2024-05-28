use arktox;

DROP VIEW IF EXISTS view_bestaetigte_archiv_eintraege;
DROP VIEW IF EXISTS view_bestaetigte_skript_eintraege;
DROP VIEW IF EXISTS view_unbestaetigte_archiv_eintraege;
DROP VIEW IF EXISTS view_unbestaetigte_skript_eintraege;
DROP VIEW IF EXISTS  view_archiv_eintraege_approval_status;
DROP VIEW IF EXISTS view_skripte_approval_status;
DROP TRIGGER IF EXISTS before_update_profil;
DROP ROLE IF EXISTS 'moderator';
DROP USER IF EXISTS 'testuser'@'localhost';

CREATE VIEW view_bestaetigte_archiv_eintraege AS
SELECT * from archiv_eintraege
WHERE approval_status = '1';

CREATE VIEW view_bestaetigte_skript_eintraege AS
SELECT * from skripte
WHERE approval_status = '1';

CREATE VIEW view_unbestaetigte_archiv_eintraege AS
SELECT * from archiv_eintraege
WHERE approval_status = '0';

CREATE VIEW view_unbestaetigte_skript_eintraege AS
SELECT * from skripte
WHERE approval_status = '0';

CREATE VIEW view_archiv_eintraege_approval_status AS
SELECT archiv_item_id, approval_status
FROM archiv_eintraege;

CREATE VIEW view_skripte_approval_status AS
SELECT skript_id, approval_status
FROM skripte;

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

DELIMITER ;

CREATE ROLE 'moderator';
CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'moderatorarktox2024';

GRANT UPDATE, SELECT ON arktox.view_archiv_eintraege_approval_status TO 'moderator';
GRANT UPDATE, SELECT ON arktox.view_skripte_approval_status TO 'moderator';

GRANT 'moderator' TO 'testuser'@'localhost';

FLUSH PRIVILEGES;