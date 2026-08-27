# Clicker Template

A reusable Godot Web/Yandex Games idle-clicker template. Web is the only
release target, and Yandex Player provides cloud saves.

Progression is a fixed 10-zone, 5-stage-per-zone cycle (50 stages, repeating
visually and content-wise) while real stage progression stays infinite. All
non-boss encounters share the same 15 common enemies; each zone has its own
boss. Elite enemies are a gameplay modifier on top of the common pool, not a
separate asset category. The template has exactly 18 partner slots and 6 buildings.

## Reskinning for a new game

Theme content is separated from gameplay code. Building a new themed game on
this template is primarily:

1. Replacing image assets (backgrounds, enemies, bosses, partners, buildings,
   abilities, prestige, tasks, shop, branding).
2. Editing `localization/game_text.csv` (all player-facing text).
3. Updating a small amount of project/release metadata (app name, icon,
   Yandex product ids).

See `docs/TEMPLATE_CONTENT_CONTRACT.md` for the full replacement checklist,
and `AGENTS.md` for the rules that keep gameplay code theme-neutral.
