Config = {
	lang = "FR",

	Debug = true,

	PlateName = "Location",

--  The Logo of the Notifications
	textureDict = "CHAR_BANK_MAZE",

	BlipMap = {
		{ x = -1032.6223, y = -2729.5947, z = 20.1314 }
	},

	-- sets near the ped so when the player enter in the 1 M radius they can open the menu
	PositionArea = {
		vector3(-1034.8305, -2733.0974, 20.1692)
	},

	PosPed = {
		{ x = -1034.5335, y = -2732.4450, z = 19.1692, a = 151.5 }
	},

	Cars = {
		vehicles = {
			-- Model you enter the spawn name abd label you enter the name that will be shown on the menu.
			-- You can add as many as you wish.
			{ model = "blista", label = "Blista", price = 500 },
		}
	},

	TwoWheels = {
		vehicles = {
			-- Model you enter the spawn name abd label you enter the name that will be shown on the menu.
			-- You can add as many as you wish.
			{ model = "faggio", label = "Faggio", price = 200 },
		}
	},

	--Vehicle Spawn Position
	VehiclePosition = {
		x = -1032.6223,
		y = -2729.5947,
		z = 20.1314,
		heading = 240.00
	},
}

Language = {}

-- Script Created by YOMAN1792
