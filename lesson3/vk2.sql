-- используем БД vk
USE vk;

/*
 * Создаем таблицу постов, связка с пользоватлем   
 * 
*/
CREATE TABLE posts(
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  txt TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
  INDEX posts_user_idx (user_id),
  CONSTRAINT fk_posts_users FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT INTO posts VALUES (DEFAULT, 1, 'Какая прекрасная погода!', DEFAULT, DEFAULT); 

SELECT * FROM posts;

/* 
 * Таблица связей медиа и постов
 */
CREATE TABLE posts_medias (
  post_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (post_id, user_id),
  INDEX posts_medias_post_idx (post_id),
  INDEX posts_medias_user_idx (user_id),
  CONSTRAINT fk_posts_medias_posts FOREIGN KEY (post_id) REFERENCES posts (id),
  CONSTRAINT fk_posts_medias_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;


INSERT INTO posts_medias VALUES (1, 1, DEFAULT);

SELECT * FROM posts_medias;

/*
 * Таблица чатов
 * 
 * */
CREATE TABLE chats(
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  admin_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX chats_admin_idx (admin_id),
  CONSTRAINT fk_chats_users FOREIGN KEY (admin_id) REFERENCES users (id)
);

INSERT INTO chats VALUES (DEFAULT, 1, DEFAULT);

SELECT * FROM chats;

/* Таблица пользователей в чате */

-- Таблица связи пользователей и сообществ
CREATE TABLE chats_users (
  chat_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (chat_id, user_id),
  INDEX chats_users_chat_idx (chat_id),
  INDEX chats_users_users_idx (user_id),
  CONSTRAINT fk_chats_users_comm FOREIGN KEY (chat_id) REFERENCES chats (id),
  CONSTRAINT fk_chats_users_users FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT INTO chats_users VALUES (1, 1, DEFAULT);
INSERT INTO chats_users VALUES (1, 2, DEFAULT);

SELECT * FROM chats_users;

/* модифицируем таблицу сообщений, добавляя туда чат
 * добавляем связь с таблицей chats */

ALTER TABLE messages ADD chat_id BIGINT UNSIGNED DEFAULT NULL;
ALTER TABLE messages ADD INDEX chats_chat_idx (chat_id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_chats FOREIGN KEY (chat_id) REFERENCES chats (id);

-- делаем возможность не указывать получателя 
-- (если указан и чат, и получатель, считаем, что это ответ на сообщение пользователю)
ALTER TABLE messages MODIFY to_user_id BIGINT UNSIGNED DEFAULT NULL;

/*сообщение в чате*/
INSERT INTO messages VALUES (DEFAULT, 1, NULL, 'hello people!', 1, DEFAULT, DEFAULT, 1);

SELECT * FROM messages;






