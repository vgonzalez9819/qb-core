# Gear System Overview

This document provides examples for creating gear items with metadata and generating randomized stats.

## Example Item Metadata
```lua
local meta = exports['gear-system']:CreateItemMetadata('helmet', 'rare', {
    weapon_damage = {min = 5, max = 10},
    armor = {min = 2, max = 5}
})
```
The returned table can be passed as the `info` when giving an item through the inventory API.

Fields:
- `slot_type` – gear slot type from `Config.GearSlots`
- `rarity` – rarity key from `Config.Rarities`
- `durability` – starting durability value
- `stats` – dictionary of rolled stat values
```
{ slot_type = 'helmet', rarity = 'rare', durability = 100, stats = { weapon_damage = 7, armor = 3 } }
```

Use this metadata when adding the item so players receive randomized bonuses.
