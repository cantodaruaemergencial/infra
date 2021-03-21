CREATE TABLE `person` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `social_name` varchar(256),
  `birthdate` datetime NOT NULL,
  `mother_name` varchar(256) NOT NULL,
  `birth_place` varchar(256) NOT NULL,
  `skin_color_id` int NOT NULL,
  `gender_id` int NOT NULL,
  `childrens` int NOT NULL,
  `has_habitation` bool NOT NULL,
  `homeless_time` varchar(256) NOT NULL,
  `emergency_aid` bool NOT NULL,
  `pbh_basket` bool NOT NULL,
  `unique_register` bool NOT NULL,
  `has_general_register` bool NOT NULL,
  `general_register` varchar(32),
  `has_cpf` bool NOT NULL,
  `cpf` varchar(11),
  `has_ctps` bool NOT NULL,
  `has_birth_certificate` bool NOT NULL,
  `marital_status_id` int NOT NULL,
  `school_training_id` int NOT NULL,
  `reference_location` varchar(256) NOT NULL,
  `occupation` varchar(256) NOT NULL,
  `profession` varchar(256) NOT NULL,
  `contact_phone` varchar(128),
  `reference_address` varchar(512),
  `demands` varchar(1024),
  `observation` varchar(1024),
  `created_by` varchar(128) NOT NULL,
  `createt_time` datetime NOT NULL
);

CREATE TABLE `entrance` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `person_id` int,
  `date` datetime
);

CREATE TABLE `attendance` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `service_id` int,
  `entrance_id` int
);

CREATE TABLE `service` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `service` varchar(256) UNIQUE NOT NULL
);

CREATE TABLE `skin_color` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `skin_color` varchar(256) UNIQUE NOT NULL
);

CREATE TABLE `gender` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `gender` varchar(256) UNIQUE NOT NULL
);

CREATE TABLE `marital_status` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `marital_status` varchar(256) UNIQUE NOT NULL
);

CREATE TABLE `school_training` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `school_training` varchar(256) UNIQUE NOT NULL
);

CREATE TABLE `benefit` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `benefit` varchar(256) UNIQUE NOT NULL
);

CREATE TABLE `person_benefit` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `benefit_id` int NOT NULL
);

CREATE TABLE `external_service` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `external_service` varchar(256) UNIQUE NOT NULL
);

CREATE TABLE `person_external_service` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `external_service_id` int NOT NULL
);

ALTER TABLE `person` ADD FOREIGN KEY (`skin_color_id`) REFERENCES `skin_color` (`id`);

ALTER TABLE `person` ADD FOREIGN KEY (`gender_id`) REFERENCES `gender` (`id`);

ALTER TABLE `person` ADD FOREIGN KEY (`marital_status_id`) REFERENCES `marital_status` (`id`);

ALTER TABLE `person` ADD FOREIGN KEY (`school_training_id`) REFERENCES `school_training` (`id`);

ALTER TABLE `entrance` ADD FOREIGN KEY (`person_id`) REFERENCES `person` (`id`);

ALTER TABLE `attendance` ADD FOREIGN KEY (`service_id`) REFERENCES `service` (`id`);

ALTER TABLE `attendance` ADD FOREIGN KEY (`entrance_id`) REFERENCES `entrance` (`id`);

ALTER TABLE `person_benefit` ADD FOREIGN KEY (`person_id`) REFERENCES `person` (`id`);

ALTER TABLE `person_benefit` ADD FOREIGN KEY (`benefit_id`) REFERENCES `benefit` (`id`);

ALTER TABLE `person_external_service` ADD FOREIGN KEY (`person_id`) REFERENCES `person` (`id`);

ALTER TABLE `person_external_service` ADD FOREIGN KEY (`external_service_id`) REFERENCES `external_service` (`id`);

CREATE UNIQUE INDEX `entrance_index_0` ON `entrance` (`person_id`, `date`);

CREATE UNIQUE INDEX `person_benefit_index_1` ON `person_benefit` (`person_id`, `benefit_id`);

CREATE UNIQUE INDEX `person_external_service_index_2` ON `person_external_service` (`person_id`, `external_service_id`);
