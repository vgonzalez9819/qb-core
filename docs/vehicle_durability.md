# Vehicle Durability and Repair System

This resource adds persistent vehicle hit points (HP) with a repair interface.
Players open the UI by typing `/repairveh`.

## Features
- Vehicles lose HP when damaged and become unusable at 0 HP.
- HP is stored in the `vehicle_durability` SQL table and persists across restarts.
- Normal players can repair only their own vehicles using a `repairkit` item.
- Mechanics (`job.name == 'mechanic'`) can repair any vehicle and apply upgrades.
- VIP vehicles (`vip = true` in the database) are not destroyed at 0 HP but require a 30‑minute cooldown before repair.
- Simple NUI interface shows the vehicle name, HP bar and VIP status.

## Commands
- **/repairveh** – Finds the nearest vehicle and opens the repair UI.

## Installation
1. Ensure `oxmysql` is installed and running.
2. Import the SQL from `qbcore.sql` to create the `vehicle_durability` table.
3. The client and server scripts are loaded automatically via `fxmanifest.lua`.
4. Place the included HTML files in your `html/repair` folder (already referenced by `fxmanifest`).

## Customisation
- Modify `server/vehicledurability/main.lua` for advanced material checks or pricing.
- Edit `html/repair/css/repair.css` and `html/repair/js/repair.js` to change the UI style or behaviour.

