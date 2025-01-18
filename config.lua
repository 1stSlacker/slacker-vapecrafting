Config = {}

-- Job Configuration
Config.RequiredJob = "mechanic"  -- Change this to the job you want to restrict access

-- Harvesting Areas
Config.HarvestAreas = {
    {coords = vector3(168.8171, -241.1275, 49.7421), item = 'nicotine', label = 'Nicotine'},
--    {coords = vector3(110.0, 210.0, 310.0), item = 'vape', label = 'Vape'},
--    {coords = vector3(120.0, 220.0, 320.0), item = 'vape', label = 'Vape'},
--    {coords = vector3(130.0, 230.0, 330.0), item = 'vape', label = 'Vape'}
}

-- Crafting Station
Config.CraftingStation = {
    prop = 'prop_protest_table_01',
    coords = vector4(vector4(172.61, -174.51, 54.27, 70.39)),
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