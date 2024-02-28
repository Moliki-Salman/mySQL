CREATE TABLE users(
id int NOT NULL  PRIMARY key AUTO_INCREMENT,
create_time DATETIME COMMENT 'create time',
username VARCHAR(255) UNIQUE,
userpassword VARCHAR(255) UNIQUE
) COMMENT '';