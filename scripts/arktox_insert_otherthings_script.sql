use arktox;

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

delimiter //

CREATE TRIGGER before_update_profilbanner before update on profil
    FOR EACH ROW
    BEGIN
        DECLARE match_count INT;

        CREATE TEMPORARY TABLE my_list (
          link varchar(255)
        );

        INSERT INTO my_list (link) VALUES
            ('iplogger.com'),
            ('maper.info'),
            ('iplogger.ru'),
            ('iplogger.co'),
            ('2no.co'),
            ('yip.su'),
            ('iplogger.info'),
            ('ipgrabber.ru'),
            ('ipgraber.ru'),
            ('iplis.ru'),
            ('02ip.ru'),
            ('ezstat.ru'),
            ('iplog.co'),
            ('iplogger.cn'),
            ('grabify.link'),
            ('iplogger.org'),
            ('wl.gl'),
            ('ed.tc'),
            ('bc.ax');

        SELECT COUNT(*)
        INTO match_count
        FROM my_list
        WHERE NEW.profilbanner_link LIKE link;

        IF match_count > 0 THEN
            SET NEW.profilbanner_link = OLD.profilbanner_link;
        END IF;

        DROP TABLE my_list;
END //

delimiter ;

CREATE USER 'moderator'@'localhost' IDENTIFIED BY 'moderatorarktox2024';

GRANT UPDATE, SELECT ON arktox.archiv_eintraege.approval_status TO 'moderator'@'localhost';
GRANT UPDATE, SELECT ON arktox.skripte.approval_status TO 'moderator'@'localhost';

FLUSH PRIVILEGES;








