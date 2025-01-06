CREATE TABLE IF NOT EXISTS `users` (
  `identifier` VARCHAR(50) NOT NULL,              -- Identifiant unique du joueur (ex: SteamID)
  `inventory` JSON NOT NULL,                     -- Inventaire du joueur, stocké en format JSON
  PRIMARY KEY (`identifier`)
);
CREATE TABLE IF NOT EXISTS `items` (
  `name` VARCHAR(50) NOT NULL,                    -- Nom unique de l'objet (par exemple 'health_potion')
  `label` VARCHAR(100) NOT NULL,                  -- Nom affiché (par exemple 'Potion de Santé')
  `description` TEXT,                             -- Description de l'objet
  `type` VARCHAR(50) NOT NULL,                    -- Type d'objet (ex: 'consommable', 'arme')
  `weight` INT DEFAULT 1,                         -- Poids de l'objet
  PRIMARY KEY (`name`)
);
CREATE TABLE IF NOT EXISTS `user_inventory_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY, 
  `identifier` VARCHAR(50) NOT NULL,              -- Identifiant du joueur
  `item_name` VARCHAR(50) NOT NULL,               -- Nom de l'objet
  `quantity` INT NOT NULL,                        -- Quantité de cet objet dans l'inventaire
  FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE,
  FOREIGN KEY (`item_name`) REFERENCES `items` (`name`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `user_inventory_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(50) NOT NULL,              -- Identifiant du joueur
  `action` VARCHAR(50) NOT NULL,                  -- Type d'action ('ajouté', 'retiré', 'transféré')
  `item_name` VARCHAR(50) NOT NULL,               -- Nom de l'objet
  `quantity` INT NOT NULL,                        -- Quantité ajoutée ou retirée
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Heure de l'action
);
CREATE TABLE IF NOT EXISTS `user_inventory_weapons` (
  `identifier` VARCHAR(50) NOT NULL,              -- Identifiant du joueur
  `weapon_name` VARCHAR(50) NOT NULL,             -- Nom de l'arme
  `ammo` INT NOT NULL,                            -- Quantité de munitions
  PRIMARY KEY (`identifier`, `weapon_name`)
);
CREATE TABLE IF NOT EXISTS `user_inventory_attachments` (
  `identifier` VARCHAR(50) NOT NULL,              -- Identifiant du joueur
  `weapon_name` VARCHAR(50) NOT NULL,             -- Nom de l'arme
  `attachment_name` VARCHAR(50) NOT NULL,         -- Nom de l'accessoire de l'arme
  PRIMARY KEY (`identifier`, `weapon_name`, `attachment_name`)
);
