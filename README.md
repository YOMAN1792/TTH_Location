# TTH_Location

## Description

**TTH_Location** is a lightweight and highly optimized FiveM script that integrates a vehicle rental system into your server using **ESX** and **ox_lib**. It allows players to rent vehicles (cars, bikes, etc.) seamlessly and efficiently.

**Key Highlights:**

- **Ultra-Optimized Performance:** The rental menu operates at a near-zero **0.00 ms** impact during regular use. The only minor spike (around **0.01 ms**) occurs during the very first vehicle spawn after a server restart, as the engine loads necessary assets. Afterwards, spawns are virtually impact-free.
- **No Idle Overhead:** The script remains dormant until the rental menu is opened, ensuring no unnecessary background processing.
- **Fully Configurable:** Easily customize vehicle categories, pricing, and spawn locations via the `config.lua` file.
- **Seamless ESX Integration:** Designed to work flawlessly with the **ESX** framework for handling player transactions and data.

Whether you're running a busy RP server or a small community, TTH_Location delivers an efficient rental experience without compromising performance.

---

## Features

- **Vehicle Rental System:** Rent cars, bikes, and more directly in-game.
- **Customizable Configuration:** Tailor vehicle types, prices, and spawn points with ease.
- **Dynamic Menu UI:** Powered by **ox_lib**, offering a modern and interactive interface.
- **Optimized Performance:** Maintains near-zero resource usage during normal operation.
- **Seamless ESX Integration:** Handles billing and player data reliably.

---

## Dependencies

This script requires the following dependencies:

- [**ox_lib**](https://github.com/overextended/ox_lib)
- [**oxmysql**](https://github.com/overextended/oxmysql)
- [**es_extended**](https://github.com/esx-framework/esx_core)
- **OneSync** (required for optimal entity handling)

---

## Installation

Follow these steps to install **TTH_Location**:

1. **Download** the latest release of the script.
2. **Extract** the files to a location on your PC.
3. **Rename** the folder to remove the `main-` prefix, if present.
4. Place the script in your **resources** folder within your FiveM server directory.
5. Add the following line to your `server.cfg` or `resources.cfg` file:

    ```bash
    ensure TTH_Location
    ```

6. **Restart** your server.
7. **Enjoy** the seamless vehicle rental functionality in-game!

---

## Configuration

Customize the script through the `config.lua` file:

```lua
Config = {}

Config.Cars = {
    vehicles = {
        { model = 'adder', label = 'Adder', price = 500 },
        { model = 'zentorno', label = 'Zentorno', price = 800 }
    }
}

Config.TwoWheels = {
    vehicles = {
        { model = 'bati', label = 'Bati 801', price = 200 },
        { model = 'pcj', label = 'PCJ 600', price = 150 }
    }
}

Config.VehiclePosition = vector3(100.0, 200.0, 300.0)
Config.PlateName = 'RENTAL'
```

You can also adjust debug settings, UI strings, and other behaviors as needed.

---

## Usage

- **Interact with a Ped:** Approach the designated NPC or point on the map to open the rental menu.
- **Choose a Vehicle:** Select your desired vehicle based on category and price.
- **Rent a Vehicle:** Once the rental fee is deducted, your chosen vehicle spawns instantly at the designated location.

---

## Performance

- **Near-Zero Impact:** The script maintains **0.00 ms** resource usage during normal operation.
- **Minimal Spike:** A negligible spike of around **0.01 ms** occurs during the first vehicle spawn after a restart, as the engine loads necessary assets. After that, performance remains consistently optimal.
- **Efficient Idle State:** No background processes run when the menu is inactive, ensuring smooth performance even on high-population servers.

---

## Contribution

Contributions are welcome! To contribute:

1. Fork the repository.
2. Make your changes (features, bug fixes, optimizations).
3. Submit a Pull Request with a clear explanation of your updates.

---

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## Support

If you have any questions or issues, reach out to **YOMAN1792** on our [Discord server](https://discord.gg/GTT6cRjAtv). I'm happy to help!

---

### Additional Notes

- **Debugging:** If you're encountering issues, enable `Config.Debug = true` in `config.lua` for additional debug output.
- **Plug-and-Play:** Designed to integrate seamlessly without modifying ESX core files.
