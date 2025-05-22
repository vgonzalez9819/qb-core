# Gear System

Standalone gear and stat system compatible with qb-inventory.

## Commands
- `/equipment` opens the equipment UI.
- `/gearstats` prints calculated stats in server console.

To equip gear items via **qb-inventory**, trigger the server event
`gear_system:server:useItem` when the item is right-clicked.

## Export
- `exports['gear_system']:getPlayerStats(source)` returns aggregated stats table for a player.
