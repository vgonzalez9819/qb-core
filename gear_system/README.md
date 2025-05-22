# Gear System

Standalone gear and stat system compatible with qb-inventory.

## Commands
- `/equipment` opens the equipment UI.
- `/gearstats` prints calculated stats in server console.

## Integrating with qb-inventory
Register your gear items as usable in qb-inventory and trigger the event
`gear_system:server:useItem` when they are used (right clicked). Example:

```lua
AddEventHandler('qb-inventory:server:useItem', function(source, item)
    if Config.Equipment[item.name] then
        TriggerEvent('gear_system:server:useItem', source, item.name, item.info)
    end
end)
```

## Export
- `exports['gear_system']:getPlayerStats(source)` returns aggregated stats table for a player.
