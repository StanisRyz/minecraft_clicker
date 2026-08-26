# Enemy Image Assets

Enemy images are loaded by `EnemyAssetCatalog` and displayed via `ImageSlot` in `GameField`.

## Folder format

```
enemies/
  zone_01/
    enemy_01/
      healthy.png
      hit.png
      wounded.png
      defeated.png
    enemy_02/
      healthy.png  ...
    enemy_03/ ...
    elite_01/ ...
    boss_01/ ...
  zone_02/ ...
  zone_03/ ...
  zone_04/ ...
```

## Non-boss enemy pool mapping

All levels use one global normal pool. The active normal slots and temporary
elite pool share `zone_01`; bosses remain unique per gameplay zone.

| Pool folder | Normal slots       | Elite slots       |
|-------------|--------------------|-------------------|
| zone_01     | enemy_01–enemy_15  | elite_01–elite_04 |

Normal selection is independent of level and zone. Non-boss files under
`zone_11` and `zone_17` are inactive legacy assets.

Empty folders use `.gitkeep` until real PNG assets are added.

## Enemy folder mapping

| Folder   | Type                                  |
|----------|---------------------------------------|
| enemy_## | Global normal enemy slot              |
| elite_## | Temporary elite-pool slot             |
| boss_01  | Boss — unique per gameplay zone       |

## Required state files per enemy folder

| File         | When shown                        | Fallback color |
|--------------|-----------------------------------|----------------|
| healthy.png  | HP > 50%                          | White          |
| hit.png      | 0.3 s after manual click/autoclick | Blue           |
| wounded.png  | HP ≤ 50%                          | Red            |
| defeated.png | On defeat / transition lock        | Black          |

## Fallback chain

1. Exact enemy image: `enemies/zone_01/enemy_01/healthy.png`
2. If missing → default enemy image: `enemy.default.healthy` (GameAssetCatalog)
3. If missing → placeholder color (white/blue/red/black)

Missing files never crash the game.
