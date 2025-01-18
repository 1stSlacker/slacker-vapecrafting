Config = {}

-- Job Configuration
Config.RequiredJob = "vapeshop"  -- Change this to the job you want to restrict access

-- Harvesting Areas
Config.HarvestAreas = {
    {coords = vector3(380.5064, -813.487, 29.133), item = 'nicotine', label = 'Nicotine'},
--    {coords = vector3(110.0, 210.0, 310.0), item = 'vape', label = 'Nicotine'},
--    {coords = vector3(120.0, 220.0, 320.0), item = 'vape', label = 'Nicotine'},
--    {coords = vector3(130.0, 230.0, 330.0), item = 'vape', label = 'Nicotine'}
}

-- Crafting Station
Config.CraftingStation = {
    coords = vector4(382.41, -817.48, 29.16, 334.83),
    menuItems = {
        {
            label = 'Vape',
            item = 'vape',
            recipe = {
                {item = 'blackplastic', amount = 4},
				{item = 'vapebattery', amount = 2},
            }
        },
		{
            label = 'Pink Burst',
            item = 'vapejuice1',
            recipe = {
                {item = 'nicotine', amount = 4},
				{item = 'pinkflavor', amount = 2},
				{item = 'emptycoil', amount = 2},
            }
        },
    }
}