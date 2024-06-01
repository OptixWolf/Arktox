# DROP DATABASE IF EXISTS arktox;

CREATE DATABASE arktox;

USE arktox;

CREATE TABLE nutzerdaten(
	user_id	INT auto_increment,
    email	VARCHAR(128),
    password_hash	VARCHAR(256),
    created_at	DATE,
    last_seen DATETIME,
    
    PRIMARY KEY(user_id)
);

CREATE TABLE profil(
	profile_id INT auto_increment,
    user_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    username VARCHAR(32),
    profilbild_link VARCHAR(512),
    profilbanner_link VARCHAR(512),
    about_me VARCHAR(255),
    
    PRIMARY KEY(profile_id),
    FOREIGN KEY(user_id) REFERENCES nutzerdaten(user_id)
);

CREATE TABLE kategorien_archiv(
	kategorie_id INT auto_increment,
    kategorie VARCHAR(255),
    
    PRIMARY KEY(kategorie_id)
);

CREATE TABLE kategorien_skripte(
	kategorie_id INT auto_increment,
    kategorie VARCHAR(255),
    
    PRIMARY KEY(kategorie_id)
);

CREATE TABLE plattform_archiv(
	plattform_id INT auto_increment,
    plattform VARCHAR(255),
    
    PRIMARY KEY(plattform_id)
);

CREATE TABLE plattform_skripte(
	plattform_id INT auto_increment,
    plattform VARCHAR(255),
    
    PRIMARY KEY(plattform_id)
);

CREATE TABLE follower(
	follower_id INT auto_increment,
	from_profile_id INT,
    to_profile_id INT,
    followed_at DATE,
    
    PRIMARY KEY(follower_id),
    FOREIGN KEY(from_profile_id) REFERENCES profil(profile_id),
    FOREIGN KEY(to_profile_id) REFERENCES profil(profile_id)
);

CREATE TABLE skripte(
	skript_id INT auto_increment,
    profile_id INT,
    approval_status bool,
    title VARCHAR(128),
    description VARCHAR(255),
    script VARCHAR(10240),
    kategorie_id INT,
    plattform_id INT,
    created_at DATE,
    
    PRIMARY KEY(skript_id),
    FOREIGN KEY(profile_id) REFERENCES profil(profile_id),
    FOREIGN KEY(kategorie_id) REFERENCES kategorien_skripte(kategorie_id),
    FOREIGN KEY(plattform_id) REFERENCES plattform_skripte(plattform_id)
);

CREATE TABLE nachrichten(
	message_id INT auto_increment,
    from_profile_id INT,
    to_profile_id INT,
    message VARCHAR(255),
    attachement_link VARCHAR(255),
    readed BOOL,
    message_send_at DATETIME,
    
    CONSTRAINT PK_Nachrichten PRIMARY KEY(message_id, from_profile_id,to_profile_id),
    FOREIGN KEY(from_profile_id) REFERENCES profil(profile_id),
    FOREIGN KEY(to_profile_id) REFERENCES profil(profile_id)
);

CREATE TABLE kommentare_skripte(
	comment_id INT auto_increment,
    post_id INT,
    profile_id INT,
    comment VARCHAR(255),
    commented_at DATETIME,
    
    PRIMARY KEY(comment_id),
    FOREIGN KEY(profile_id) REFERENCES profil(profile_id),
    FOREIGN KEY(post_id) REFERENCES skripte(skript_id)
);

CREATE TABLE likes_skripte(
	like_id INT auto_increment,
    post_id INT,
    profile_id INT,
    
    PRIMARY KEY(like_id),
    FOREIGN KEY(post_id) REFERENCES skripte(skript_id),
    FOREIGN KEY(profile_id) REFERENCES profil(user_id)
);

CREATE TABLE archiv_eintraege(
	archiv_item_id INT auto_increment,
    profile_id INT,
    approval_status BOOL,
    title VARCHAR(128),
    description VARCHAR(512),
    link VARCHAR(255),
    link_title VARCHAR(255),
    link2 VARCHAR(255),
    link2_title VARCHAR(255),
    link3 VARCHAR(255),
    link3_title VARCHAR(255),
    project_author VARCHAR(64),
    project_author_link VARCHAR(255),
    kategorie_id INT,
    plattform_id INT,
    command VARCHAR(255),
    hint VARCHAR(512),
    created_at DATE,
    
    PRIMARY KEY(archiv_item_id),
    FOREIGN KEY(profile_id) REFERENCES profil(profile_id),
    FOREIGN KEY(kategorie_id) REFERENCES kategorien_archiv(kategorie_id),
    FOREIGN KEY(plattform_id) REFERENCES plattform_archiv(plattform_id)
);

CREATE TABLE kommentare_archiv(
	comment_id INT auto_increment,
    post_id INT,
    profile_id INT,
    comment VARCHAR(255),
    commented_at DATETIME,
    
    PRIMARY KEY(comment_id),
    FOREIGN KEY(profile_id) REFERENCES profil(profile_id),
    FOREIGN KEY(post_id) REFERENCES archiv_eintraege(archiv_item_id)
);

CREATE TABLE likes_archiv(
	like_id INT auto_increment,
    post_id INT,
    profile_id INT,
    
    PRIMARY KEY(like_id),
    FOREIGN KEY(post_id) REFERENCES archiv_eintraege(archiv_item_id),
    FOREIGN KEY(profile_id) REFERENCES profil(user_id)
);

CREATE TABLE version_history(
	version_id INT auto_increment,
    version VARCHAR(16),
    changelog VARCHAR(512),
	published_at DATE,
    
    PRIMARY KEY(version_id)
);