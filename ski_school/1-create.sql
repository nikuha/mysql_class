CREATE DATABASE ski_school;

USE ski_school;

/*
 * Амины, которые заводят заявки
 */
DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL, 
  last_name VARCHAR(145) NOT NULL,
  email VARCHAR(145) NOT NULL,
  phone CHAR(11) NOT NULL,
  password_hash CHAR(65) DEFAULT NULL,
  percent TINYINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
  UNIQUE INDEX email_unique_idx (email),
  UNIQUE INDEX phone_unique_idx (phone)
);


/*
 * Инструкторы горнолыжной школы
 * percent - процент от заявки, который получает инструктор
 */
DROP TABLE IF EXISTS instructors;
CREATE TABLE instructors (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL, 
  last_name VARCHAR(145) NOT NULL,
  email VARCHAR(145) NOT NULL,
  phone CHAR(11) NOT NULL,
  ski BOOL NOT NULL,
  snowboard BOOL NOT NULL,
  english BOOL NOT NULL,
  percent TINYINT UNSIGNED NOT NULL,
  password_hash CHAR(65) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
  UNIQUE INDEX email_unique_idx (email),
  UNIQUE INDEX phone_unique_idx (phone)
);


/*
 * Партнеры, приводящие клиентов
 * Источник, откуда пришла заявка
 * percent - процент от заявки, который получает партнер
 */
DROP TABLE IF EXISTS partners;
CREATE TABLE partners (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL, 
  phone CHAR(11) DEFAULT NULL,
  percent TINYINT UNSIGNED DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
  UNIQUE INDEX phone_unique_idx (phone)
);


/*
 * Клиенты
 */
DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL, 
  last_name VARCHAR(145) DEFAULT NULL,
  email VARCHAR(145) DEFAULT NULL,
  phone CHAR(11) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


/*
 * Категории занятий
 */
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL, 
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


/*
 * Курорты, где проводятся занятия
 */
DROP TABLE IF EXISTS resorts;
CREATE TABLE resorts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL, 
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


/*
 * Заявки
 */
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  admin_id BIGINT UNSIGNED NOT NULL,
  partner_id BIGINT UNSIGNED NOT NULL,
  client_id BIGINT UNSIGNED NOT NULL,
  resort_id BIGINT UNSIGNED NOT NULL,
  category_id BIGINT UNSIGNED NOT NULL,
  price FLOAT UNSIGNED NOT NULL,
  status ENUM('in_process','paid','done','canceled') DEFAULT 'in_process',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX orders_admin_id_idx (admin_id),
  CONSTRAINT orders_admins_foreign FOREIGN KEY (admin_id) REFERENCES admins (id),
  INDEX orders_partner_id_idx (partner_id),
  CONSTRAINT orders_partners_foreign FOREIGN KEY (partner_id) REFERENCES partners (id),
  INDEX orders_client_id_idx (client_id),
  CONSTRAINT orders_clients_foreign FOREIGN KEY (client_id) REFERENCES clients (id),
  INDEX orders_resort_id_idx (resort_id),
  CONSTRAINT orders_resorts_foreign FOREIGN KEY (resort_id) REFERENCES resorts (id),
  INDEX orders_category_id_idx (resort_id),
  CONSTRAINT orders_categories_foreign FOREIGN KEY (category_id) REFERENCES categories (id)
);


/*
 * Занятия
 */
DROP TABLE IF EXISTS lessons;
CREATE TABLE lessons (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED DEFAULT NULL,
  instructor_id BIGINT UNSIGNED NOT NULL,
  start_time DATETIME NOT NULL, 
  end_time DATETIME NOT NULL, 
  equipment ENUM('ski', 'snowboard') DEFAULT NULL,
  price FLOAT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX lessons_order_id_idx (order_id),
  CONSTRAINT lessons_orders_foreign FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
  INDEX lessons_instructor_id_idx (instructor_id),
  CONSTRAINT lessons_instructors_foreign FOREIGN KEY (instructor_id) REFERENCES instructors (id),
  INDEX lessons_start_time_idx (start_time),
  INDEX lessons_end_time_idx (end_time)
);


