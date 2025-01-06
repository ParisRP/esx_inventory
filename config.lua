Config = {}

-- Clé pour ouvrir l'inventaire (par défaut : F2)
Config.InventoryKey = 289 -- F2

-- Notifications (ox_lib)
Config.UseNotifications = true -- true pour utiliser ox_lib pour les notifications

-- Options d'inventaire
Config.MaxWeight = 50 -- Poids maximum que peut porter un joueur
Config.MaxSlots = 20  -- Nombre maximum d'objets dans l'inventaire

-- Langues disponibles
Config.Locale = 'fr'

-- Configuration des objets
Config.Items = {
    bread = {
        label = 'Pain',
        weight = 1,
        usable = true,
        description = 'Un pain simple pour combler votre faim.'
    },
    water = {
        label = 'Eau',
        weight = 1,
        usable = true,
        description = 'Une bouteille d\'eau pour étancher votre soif.'
    }
}

-- Clés pour transférer des objets
Config.TransferDistance = 3.0 -- Distance maximale pour transférer des objets à un autre joueur
