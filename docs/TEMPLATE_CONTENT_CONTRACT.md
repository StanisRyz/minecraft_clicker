# Template Content Contract

This project is a reusable Web/Yandex idle-clicker template. Gameplay code
(configs, mechanics, balance, ids) is theme-neutral. To ship a new themed
game from this template, replace only the content below — no gameplay-code
renaming should be required.

## 1. Core gameplay assets (fixed contract, do not change counts)

| Asset | Count | Path pattern |
|---|---|---|
| Zone backgrounds | 10 | `assets/images/backgrounds/...` (see `BackgroundAssetCatalog.gd`) |
| Common enemies × 4 states (healthy/hit/wounded/defeated) | 15 | `assets/images/enemies/common/enemy_NN/<state>.png` |
| Zone bosses × 4 states | 10 | `assets/images/enemies/zone_NN/boss_01/<state>.png` |

Elite enemies are a gameplay modifier (stat multiplier + visual tint/effect),
not a separate asset category — they reuse the 15 common enemy assets.

## 2. Other art to replace

- Partner icons: `assets/images/partners/partner_NN/partner.png` (18 partners)
- Shared skill rank icons: `assets/images/partners/Skills/skillN.png`
- Building icons: `assets/images/buildings/building_01.png` … `building_06.png` (6 buildings)
- Ability icons: `assets/images/abilities/<ability_id>/icon.png`
- Prestige icons: `assets/images/prestige/prestige.png`,
  `assets/images/prestige/talent_01.png` … `talent_06.png`
- Task icons: `assets/images/tasks/...`
- Shop product icons: `assets/images/shop/...`
- Branding/UI chrome (icon, boot splash, sheets, buttons) as desired

All of the above are resolved through `scripts/ui/GameAssetCatalog.gd` (plus
`BackgroundAssetCatalog.gd`, `EnemyAssetCatalog.gd`, `StageNavigationAssetCatalog.gd`).
Asset keys and slot filenames are stable; only the image content should change.

## 3. Text

- Edit `localization/game_text.csv` (the `en` and `ru` columns). This is the
  single source of truth for every player-facing string: zone/boss/partner/
  building names, task titles, shop copy, ability/skill text, UI labels.
- After editing the CSV, regenerate the built-in fallback with:
  `godot --headless --script res://scripts/tools/GenerateLocalizationData.gd`
- Gameplay configs (`ZoneConfig`, `PartnerConfig`, `SettlementConfig`,
  `TaskConfig`, `ShopConfig`, `AbilityConfig`, `HeroSkillConfig`,
  `PartnerSkillConfig`, `PrestigeConfig`) only hold stable ids, mechanics,
  balance values, and localization-key helpers — they do not need to change
  for a reskin.

## 4. Project/release metadata

- `project.godot` → `config/name` (window/app title)
- App icon / boot splash (`config/icon`, `boot_splash/image`)
- Yandex Games: create the required purchase products in the new Yandex
  Games project using the existing product ids (`gems_25`, `gems_150`,
  `gems_500`, `gems_1500`, plus the in-game shop product ids in
  `ShopConfig.gd`). Product ids are stable and must not be renamed.
- Build/export remains Web-only (`godot --headless --export-release "Web" ...`).

## 5. What should NOT change for a reskin

- Stable ids: ability ids, task ids, shop product ids, Yandex purchase ids,
  save field names, bonus types, localization key patterns.
- The 10-zone / 5-stage-per-zone / 50-stage repeating cycle, and the fixed
  15-common-enemy / 10-boss asset contract.
