DROP DATABASE IF EXISTS example;

CREATE DATABASE example;

USE example;

CREATE TABLE IF NOT EXISTS users(
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
name varchar(255)
);

INSERT INTO users VALUES
(DEFAULT, 'Катя'), 
(DEFAULT, 'Маша');