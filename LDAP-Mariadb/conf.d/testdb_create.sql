CREATE TABLE IF NOT EXISTS `users` (	`id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,	`name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',	`email` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',	`email_verified_at` TIMESTAMP NULL DEFAULT NULL,	`password` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',	`two_factor_secret` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',	`two_factor_recovery_codes` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',	`two_factor_confirmed_at` TIMESTAMP NULL DEFAULT NULL,	`remember_token` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',	`current_team_id` BIGINT(20) UNSIGNED NULL DEFAULT NULL,	`profile_photo_path` VARCHAR(2048) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',	`created_at` TIMESTAMP NULL DEFAULT NULL,	`updated_at` TIMESTAMP NULL DEFAULT NULL,	`uuid` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',	PRIMARY KEY (`id`) USING BTREE,	UNIQUE INDEX `users_email_unique` (`email`) USING BTREE) COLLATE='utf8mb4_unicode_ci' ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS institutes (	id int NOT NULL,	name varchar(255));
CREATE TABLE IF NOT EXISTS documents (	id int NOT NULL,	title varchar(255) NOT NULL,	abstract varchar(255));
CREATE TABLE IF NOT EXISTS authors_docs (	pers_id int NOT NULL,	doc_id int NOT NULL);
CREATE TABLE IF NOT EXISTS phones (	id int NOT NULL ,	phone varchar(255) NOT NULL ,	pers_id int NOT NULL );
CREATE TABLE IF NOT EXISTS certs (	id int NOT NULL ,	cert LONGBLOB NOT NULL,	pers_id int NOT NULL );
ALTER TABLE authors_docs  ADD 	CONSTRAINT PK_authors_docs PRIMARY KEY  	(		pers_id,		doc_id	);
ALTER TABLE documents  ADD 	CONSTRAINT PK_documents PRIMARY KEY  	(		id	);
ALTER TABLE institutes  ADD 	CONSTRAINT PK_institutes PRIMARY KEY  	(		id	);
ALTER TABLE phones  ADD 	CONSTRAINT PK_phones PRIMARY KEY  	(		id	);
ALTER TABLE certs  ADD 	CONSTRAINT PK_certs PRIMARY KEY  	(		id	);
CREATE TABLE IF NOT EXISTS referrals (	id int NOT NULL,	name varchar(255) NOT NULL,	url varchar(255) NOT NULL);
CREATE TABLE IF NOT EXISTS `wallet` (	`id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,	`trc20_addr` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',	`cny_amount` DOUBLE NOT NULL DEFAULT '0',	PRIMARY KEY (`id`) USING BTREE,	UNIQUE INDEX `UNIQ` (`trc20_addr`) USING BTREE,	CONSTRAINT `wallet_id_foreign` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE) COLLATE='utf8mb4_unicode_ci' ENGINE=InnoDB;
