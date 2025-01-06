-- Create the 'items' table to store all available items in the game (esx_inventory)
CREATE TABLE IF NOT EXISTS `items` (
  `name` VARCHAR(50) NOT NULL,            -- Unique identifier for the item (e.g., "health_potion")
  `label` VARCHAR(100) NOT NULL,          -- Display name for the item (e.g., "Health Potion")
  `description` TEXT,                     -- Optional: Description of the item
  `type` VARCHAR(50) NOT NULL,            -- Item type (e.g., "consumable", "weapon", "clothing")
  `weight` INT(11) DEFAULT 1,             -- Optional: Item weight (relevant for inventory systems with weight management)
  PRIMARY KEY (`name`)
);

-- Create the 'inventory_logs' table to track changes to the player's inventory
CREATE TABLE IF NOT EXISTS `inventory_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(50) NOT NULL,      -- Player identifier (e.g., Steam ID or license)
  `action` VARCHAR(50) NOT NULL,          -- Action type (e.g., "added", "removed")
  `item_name` VARCHAR(50) NOT NULL,       -- Item name (e.g., "health_potion")
  `quantity` INT NOT NULL,                -- Quantity of the item added or removed
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of when the event happened
);

-- Create the 'user_inventory_items' table to store individual items and quantities for each player
CREATE TABLE IF NOT EXISTS `user_inventory_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(50) NOT NULL,      -- Player identifier (e.g., Steam ID or license)
  `item_name` VARCHAR(50) NOT NULL,       -- Item name (should match the 'items.name')
  `quantity` INT NOT NULL,                -- Quantity of the item (number of that item the player has)
  FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE,
  FOREIGN KEY (`item_name`) REFERENCES `items` (`name`) ON DELETE CASCADE
);

-- Create the 'user_inventory' table to store a JSON field of the player's inventory (for easier access, optional)
CREATE TABLE IF NOT EXISTS `user_inventory` (
  `identifier` VARCHAR(50) NOT NULL,      -- Player identifier (e.g., Steam ID or license)
  `inventory` JSON NOT NULL,             -- Player's inventory stored as JSON (can store items in the player's inventory here)
  PRIMARY KEY (`identifier`)
);

-- Create the 'user_jobs' table to store job-related data for players (e.g., job name, grade, salary, etc.)
CREATE TABLE IF NOT EXISTS `user_jobs` (
  `identifier` VARCHAR(50) NOT NULL,      -- Player identifier (e.g., Steam ID or license)
  `job_name` VARCHAR(50) NOT NULL,        -- Job name (e.g., "police", "mechanic", etc.)
  `grade` INT NOT NULL,                   -- Job grade (rank or level within the job)
  `salary` INT NOT NULL,                  -- Job salary (in-game money)
  PRIMARY KEY (`identifier`, `job_name`)  -- Unique key by identifier and job name
);

-- Create the 'user_inventory' table to store player items (for item management)
-- This stores items separately from JSON storage (relational approach)
CREATE TABLE IF NOT EXISTS `user_inventory` (
  `identifier` VARCHAR(50) NOT NULL,      -- Player identifier (e.g., Steam ID or license)
  `item_name` VARCHAR(50) NOT NULL,       -- Item name (should match the 'items.name')
  `quantity` INT NOT NULL,                -- Quantity of the item (number of that item the player has)
  PRIMARY KEY (`identifier`, `item_name`) -- Ensure no duplicate items for a player
);
