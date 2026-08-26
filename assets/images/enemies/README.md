# Enemy Image Assets

Enemy images are loaded by `EnemyAssetCatalog` and displayed via `ImageSlot` in `GameField`.

## Folder format

```
enemies/
  common/
    enemy_01/
      healthy.png
      hit.png
      wounded.png
      defeated.png
    enemy_02/
      healthy.png  ...
    enemy_03/ ...
  zone_01/
    boss_01/ ...
  zone_02/ ...
  zone_03/ ...
  zone_04/ ...
```

## Non-boss enemy pool mapping

All non-boss encounters use one global enemy pool. Elite encounters reuse the
selected common enemy and remain a gameplay modifier. Bosses are unique per zone.

| Pool folder | Slots              |
|-------------|--------------------|
| common      | enemy_01–enemy_15  |

Normal selection is independent of level and zone. Only `zone_01` through
`zone_10` exist for boss assets.

Empty folders use `.gitkeep` until real PNG assets are added.

## Enemy folder mapping

| Folder   | Type                                  |
|----------|---------------------------------------|
| common/enemy_## | Shared non-boss enemy slot      |
| boss_01          | Boss — unique per gameplay zone |

## Required state files per enemy folder

| File         | When shown                        | Fallback color |
|--------------|-----------------------------------|----------------|
| healthy.png  | HP > 50%                          | White          |
| hit.png      | 0.3 s after manual click/autoclick | Blue           |
| wounded.png  | HP ≤ 50%                          | Red            |
| defeated.png | On defeat / transition lock        | Black          |

## Fallback chain

1. Exact enemy image: `enemies/common/enemy_01/healthy.png`
2. If missing → default enemy image: `enemy.default.healthy` (GameAssetCatalog)
3. If missing → placeholder color (white/blue/red/black)

Missing files never crash the game.
