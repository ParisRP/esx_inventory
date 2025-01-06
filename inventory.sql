-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS `users` (
    `identifier` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `inventory` TEXT DEFAULT '{}',
    PRIMARY KEY (`identifier`)
);

-- Table des objets (optionnelle)
CREATE TABLE IF NOT EXISTS `items` (
    `item_name` VARCHAR(100) NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `weight` INT NOT NULL DEFAULT 1,
    `type` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`item_name`)
);
