DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;

-- используем БД vk
USE vk;

-- показываем все таблицы
SHOW tables;

/*
 * 1. Создадим таблицу users.
*/

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL, -- COMMENT "Имя",
  last_name VARCHAR(145) NOT NULL,
  email VARCHAR(145) NOT NULL,
  phone CHAR(11) NOT NULL,
  password_hash CHAR(65) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
  UNIQUE INDEX email_unique_idx (email),
  UNIQUE INDEX phone_unique_idx (phone)
) ENGINE=InnoDB;

-- Заполним таблицу, добавим Петю и Васю
INSERT INTO users VALUES (DEFAULT, 'Petya', 'Petukhov', 'petya@mail.com', '89212223334', DEFAULT, DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Vasya', 'Vasilkov', 'vasya@mail.com', '89212023334', DEFAULT, DEFAULT);

-- Посмотрим на содержимое таблицы
SELECT * FROM users;

-- описание таблицы
DESCRIBE users;

-- скрипт создания таблицы
SHOW CREATE TABLE users; 

/* 2
 * создаем таблицы стран и городов, привязанных к странам
 */ 
CREATE TABLE countries(
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL
);
INSERT INTO countries values(DEFAULT, 'Россия');

SELECT * FROM countries;

CREATE TABLE cities(
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  country_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(145) NOT NULL,
  INDEX cities_country_idx (country_id),
  CONSTRAINT fk_cities_countries FOREIGN KEY (country_id) REFERENCES countries (id)
);

INSERT INTO cities values(DEFAULT, 1, 'Москва');
INSERT INTO cities values(DEFAULT, 1, 'Сочи');

-- теперь в профиле можно указывать только город пользователя, который связан со страной 

/*
 * 3. Создадим таблицу с профилем пользователя, чтобы не хранить все данные в таблице users
 * 
 * 
*/
-- 1:1 связь
CREATE TABLE profiles (
  user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  gender ENUM('f', 'm', 'x') NOT NULL, -- CHAR(1)
  birthday DATE NOT NULL,
  photo_id INT UNSIGNED,
  user_status VARCHAR(30),
  city_id BIGINT UNSIGNED NOT NULL,
  INDEX profiles_city_id (city_id),
  CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users (id), -- ON DELETE CASCADE ON UPDATE CASCADE
  CONSTRAINT fk_profiles_cities FOREIGN KEY (city_id) REFERENCES cities (id)
);

DESCRIBE profiles;

-- Заполним таблицу, добавим профили для уже созданных Пети и Васи
INSERT INTO profiles VALUES (1, 'm', '1997-12-01', NULL, NULL, 1); -- профиль Пети
INSERT INTO profiles VALUES (2, 'm', '1988-11-02', NULL, NULL, 2); -- профиль Васи

SELECT * FROM profiles;

/*
 * 4. Создадим таблицу с сообщениями пользователей.
 * 
*/

CREATE TABLE messages (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  from_user_id BIGINT UNSIGNED NOT NULL,
  to_user_id BIGINT UNSIGNED NOT NULL,
  txt TEXT NOT NULL, -- txt = ПРИВЕТ
  is_delivered BOOLEAN DEFAULT False,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  INDEX fk_messages_from_user_idx (from_user_id),
  INDEX fk_messages_to_user_idx (to_user_id),
  CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE messages;

-- Добавим два сообщения от Пети к Васе, одно сообщение от Васи к Пете
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Hi!', 1, DEFAULT, DEFAULT); -- сообщение от Пети к Васе номер 1
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Vasya!', 1, DEFAULT, DEFAULT); -- сообщение от Пети к Васе номер 2
INSERT INTO messages VALUES (DEFAULT, 2, 1, 'Hi, Petya', 1, DEFAULT, DEFAULT); -- сообщение от Пети к Васе номер 2

-- смотрим на сообщения
SELECT * FROM messages;

/*
 * 5. Создадим таблицу запросов в друзья.
 * 
 * 
*/

CREATE TABLE friend_requests (
  from_user_id BIGINT UNSIGNED NOT NULL,
  to_user_id BIGINT UNSIGNED NOT NULL,
  accepted BOOLEAN DEFAULT False,
  PRIMARY KEY(from_user_id, to_user_id),
  INDEX fk_friend_requests_from_user_idx (from_user_id),
  INDEX fk_friend_requests_to_user_idx (to_user_id),
  CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

-- Добавим запрос на дружбу от Пети к Васе
INSERT INTO friend_requests VALUES (1, 2, 1);

SELECT * FROM friend_requests;

/*
 * 6. Создадим таблицу сообществ.
 * 
 * 
*/

CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL,
  admin_id BIGINT UNSIGNED NOT NULL,
  INDEX communities_users_admin_idx (admin_id),
  CONSTRAINT fk_communities_users FOREIGN KEY (admin_id) REFERENCES users (id)
) ENGINE=InnoDB;

-- Добавим сообщество с создателем Петей
INSERT INTO communities VALUES (DEFAULT, 'Number1', 'I am number one', 1);

SELECT * FROM communities;

/*
 * 7. Создадим таблицу для хранения информации обо всех участниках всех сообществ.
 * 
 * Сценарий: Вася вступил в сообщество Number1.
 * 
 * Вася может вступить во много разных сообществ, при этом в одном сообществе может быть много участников.
 * Связь от многих к многим.
 * 
 * Что нам необходимо хранить? Пользователя, сообщество, в которое он вступил, дату вступления в сообщество.
 * 
 * Так как Вася может вступить в сообщество Number1 только один раз, уникальный идентификатор записи нам не нужен (id),
 * используем спецификацию таблицы friend_requests как макет и создаем по аналогии.
*/

-- Таблица связи пользователей и сообществ
CREATE TABLE communities_users (
  community_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (community_id, user_id),
  INDEX communities_users_comm_idx (community_id),
  INDEX communities_users_users_idx (user_id),
  CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;

-- Добавим запись вида Вася участник сообщества Number 1
INSERT INTO communities_users VALUES (1, 2, DEFAULT);

SELECT * FROM communities_users;

/*
 * 8. Создадим таблицу для хранения типов медиа файлов, каталог типов медифайлов.
 * 
*/

CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL UNIQUE -- изображение, музыка, документ
) ENGINE=InnoDB;

-- Добавим типы в каталог
INSERT INTO media_types VALUES (DEFAULT, 'изображение');
INSERT INTO media_types VALUES (DEFAULT, 'музыка');
INSERT INTO media_types VALUES (DEFAULT, 'документ');

SELECT * FROM media_types;


/*
 * 9. Создадим таблицу всех медиафайлов.
 * 
*/

CREATE TABLE media (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Картинка 1
  user_id BIGINT UNSIGNED NOT NULL,
  media_types_id INT UNSIGNED NOT NULL, -- фото
  file_name VARCHAR(245) DEFAULT NULL,
  file_size BIGINT UNSIGNED,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX media_media_types_idx (media_types_id),
  INDEX media_users_idx (user_id),
  CONSTRAINT fk_media_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id),
  CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Добавим два изображения, которые добавил Петя
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im.jpg', 100, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im1.png', 78, DEFAULT);
-- Добавим документ, который добавил Вася
INSERT INTO media VALUES (DEFAULT, 2, 3, 'doc.docx', 1024, DEFAULT);

SELECT * FROM media;