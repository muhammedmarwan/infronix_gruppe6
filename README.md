# 💼 Infronix Gruppe 6 Collection Job

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Ready-green.svg)](https://fivem.net/)
[![QBX](https://img.shields.io/badge/Framework-QBX-orange.svg)](https://github.com/Qbox-project/qbx_core)
[![Version](https://img.shields.io/badge/Version-2.2.0-brightgreen.svg)]()

---

## 🌟 Overview

<img width="1920" height="1080" alt="infronix_gruppe6-tablet" src="https://github.com/user-attachments/assets/615d5719-5214-4522-a69d-3583857fa85b" />

A **fully immersive Gruppe 6 security job system** for QBX-based FiveM servers.  
This script provides a **realistic two-phase collection route** with **loan agreements** and **cash pickups**, featuring a **custom tablet UI with fingerprint lock screen**, **GPS waypoint system**, **uniform management**, and **skill-based minigames**.  
Fully optimized for **ox_lib**, **ox_target**, and **ox_inventory**, featuring **persistent route tracking** and integrated uniform enforcement.

---

## ✨ Key Features

- 🔒 **Immersive Tablet Interface (GPS Item)**  
  - Futuristic lock screen with fingerprint authentication.  
  - Real-time clock display on lock screen.  
  - Employee name display and route tracking.  
  - GPS waypoint integration with one-click navigation.
  - Persistent route state across opening/closing the tablet.

- 📋 **Two-Phase Collection System**  
  - **Phase 1: Loan Route** - Collect loan agreements from bank locations.  
  - **Phase 2: Cash Route** - Pick up cash cases from ATM locations.  
  - Sequential stop completion ensures players follow the intended route.  
  - Return to depot between phases to collect wages and start the next phase.

- 👔 **Uniform & Clothing System**  
  - Gender-specific Gruppe 6 uniforms defined in `uniforms.lua`.  
  - Automatic clothing save/restore when changing into/out of uniform.  
  - Optional uniform requirement before starting a schedule (`Config.RequireUniformBeforeWork`).  
  - In-game outfit copying tool (`/copyoutfit`) for easy customization.

- 🎮 **Skill-Based Minigames**  
  - Uses `ox_lib` skill checks for internal interactions.  
  - Adjustable difficulty (easy/medium/hard).  
  - Configurable sequence length and toggleable in config.

- 💰 **Configurable Payouts & Cooldowns**  
  - Separate payments for Loan and Cash phases (e.g., $2,250 + $3,500).  
  - Customizable cooldowns for taking schedules and completing full jobs.  
  - Notifications for cooldown remaining time.

- 🎨 **Visual Feedback**  
  - Dynamic 3D markers at active locations (color-coded by phase).  
  - Map blips for Depot and active waypoints.  
  - Debug mode to visualize PolyZones and detailed logging.

---

## 📋 Requirements

| Dependency | Purpose |
|------------|---------|
| [qbx_core](https://github.com/Qbox-project/qbx_core) | Core Framework |
| [ox_lib](https://github.com/overextended/ox_lib) | UI, Skillchecks, Notifications |
| [ox_target](https://github.com/overextended/ox_target) | Interaction System |
| [ox_inventory](https://github.com/overextended/ox_inventory) | Inventory & Item Management |
| [oxmysql](https://github.com/overextended/oxmysql) | Database Management |
| [PolyZone](https://github.com/mkafrin/PolyZone) | Zone Management |

---

## 🚀 Installation

### 1️⃣ Download & Extract

Place the resource into your server's `resources` folder:
`[server-data]/resources/[jobs]/infronix_gruppe6/`

### 2️⃣ Item Setup

Add the GPS item to `ox_inventory/data/items.lua`:

```lua
['g6_route_gps'] = {
    label = 'Gruppe 6 Route GPS',
    weight = 300,
    stack = false,
    close = true,
    description = 'Digital route sheet with GPS navigation for Gruppe 6 employees'
},
```

Place the item image (`g6_route_gps.png`) in `ox_inventory/web/images/`.

### 3️⃣ Job Configuration

Ensure you have the `gruppe6` job defined in your framework's job system. Example for `qbx_core`:

```lua
['gruppe6'] = {
    label = 'Gruppe 6',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 50 },
        ['1'] = { name = 'Security Officer', payment = 100 },
        ['2'] = { name = 'Supervisor', payment = 150 },
    },
},
```

### 4️⃣ Server Config

Add to your `server.cfg`:
```cfg
ensure infronix_gruppe6
```

---

## ⚙️ Configuration

The script is highly customizable via `config.lua`.

### 🎯 Key Settings

```lua
Config.JobRequired = false       -- true = must have job 'gruppe6' | false = public access
Config.RequireOnDuty = false     -- Require player to be on-duty
Config.RequireUniformBeforeWork = true -- Must change at depot before taking schedule
Config.LoanPayout = 2250         -- Payout for Phase 1
Config.CashPayout = 3500         -- Payout for Phase 2
Config.LoanRouteCount = 5        -- Stops in Phase 1
Config.CashRouteCount = 7        -- Stops in Phase 2
```

### 👔 Uniform Setup (`uniforms.lua`)

Use the built-in command to generate outfit code for your server:
1. Dress your character in the desired Gruppe 6 outfit.
2. Run `/copyoutfit male` or `/copyoutfit female`.
3. Open F8 console, copy the code block.
4. Replace the existing data in `uniforms.lua`.

---

## 🎮 How to Play

1. **Start Duty**: Head to the Gruppe 6 Depot and clock in (if required).
2. **Equip Uniform**: Use the depot menu to change into your work gear.
3. **Request Schedule**: Interact with the depot terminal to receive your route.
4. **Collect Loan Agreements**: Follow the GPS to bank locations and collect documents.
5. **Return to Depot**: Collect your Phase 1 pay and start the **Cash Phase**.
6. **Collect Cash**: Visit ATM locations, pick up cash cases, and load them into your vehicle.
7. **Final Payout**: Return to the depot one last time to collect your final wages.

---

## 🔧 Commands

| Command | Description |
|---------|-------------|
| `/copyoutfit male` | Generates outfit code for male peds in F8 console |
| `/copyoutfit female` | Generates outfit code for female peds in F8 console |

---

## 🎨 UI Customization

- **Tablet Design**: Edit `html/style.css` to change colors, fonts, and animations.
- **Background**: Replace `html/lockscreen.png` to customize the tablet's wallpaper.
- **Logo**: Customize `html/sechslogo.png` for branding.

---

## 📊 Performance

- **Resmon**: ~0.01ms (idle) / ~0.03ms (active markers/zones)
- **Networking**: Event-driven architecture with minimal server overhead.

---

## 📝 Credits

- **Author**: Marwan
- **Repository**: [infronix_gruppe6](https://github.com/muhammedmarwan/infronix_gruppe6)

- ⛔⛔ORIGINAL Author: https://github.com/MnCLosSantos/mnc-gruppe6.git

---

## 📜 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
