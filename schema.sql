-- Schema for Sweet Treat, reconstructed from the queries in app.py.
--
-- Run against a fresh database:
--   mysql -u root -p < schema.sql

CREATE DATABASE IF NOT EXISTS bakery_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bakery_db;

CREATE TABLE IF NOT EXISTS donuts (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(120)   NOT NULL,
  description TEXT,
  -- Money as DECIMAL, not FLOAT: binary floating point cannot represent
  -- values like 2.30 exactly, and the error compounds once you sum a basket.
  price       DECIMAL(10, 2) NOT NULL,
  image_url   VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  -- app.py checks for a duplicate username before inserting; the UNIQUE
  -- constraint is what makes that check hold under concurrent registrations.
  username      VARCHAR(50)  NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL
);

-- The application connects as bakery_user (see DB_CONFIG in app.py).
-- Replace the password before running this.
-- CREATE USER 'bakery_user'@'localhost' IDENTIFIED BY 'change_me';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON bakery_db.* TO 'bakery_user'@'localhost';
-- FLUSH PRIVILEGES;

INSERT INTO donuts (name, description, price, image_url) VALUES
  ('Strawberry Frosted', 'Pink glaze, rainbow sprinkles.',        2.50, NULL),
  ('Chocolate Old Fashioned', 'Cocoa cake ring, dark chocolate glaze.', 2.20, NULL),
  ('Matcha Cream', 'Whipped matcha filling, dusted sugar.',       3.10, NULL);
