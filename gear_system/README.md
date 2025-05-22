# Gear System

Standalone gear and stat system compatible with qb-inventory.

The equipment panel is shown whenever qb-inventory opens and allows dropping
items onto the appropriate slot boxes. Inventory items must trigger
`startGearDrag(itemName)` on drag start so the gear script knows which item is
being placed.

## Commands
- `/equipment` opens the equipment UI if qb-inventory isn't used.
- `/gearstats` prints calculated stats in server console.

## Export
- `exports['gear_system']:getPlayerStats(source)` returns aggregated stats table for a player.
