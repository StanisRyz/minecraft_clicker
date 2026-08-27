# AGENTS.md

Development rules for AI coding agents working on this repository.

## Scope

- Godot 4.5.1, GDScript, Web/Yandex Games idle clicker.
- Web is the only release target. Keep patches small and release-focused.
- Preserve the current architecture and balance unless explicitly requested.
- Do not modify `scripts/tools/BalanceAuditReport.gd` unless explicitly requested.

## Platform

- `autoload/Platform.gd` selects exactly two implementations:
  - Web -> `scripts/platform/WebYandexPlatform.gd`.
  - Editor/non-Web -> `scripts/platform/LocalDebugPlatform.gd`.
- Gameplay and UI call `Platform`, never `YandexBridge` directly.
- The Yandex SDK owns ads, payments, Yandex Player saves, platform language,
  and loading/gameplay lifecycle notifications.
- LocalDebug simulations must remain debug-gated and must never grant fake
  production rewards.
- Web/Yandex has no custom account, login, or backend subsystem. Yandex Player
  is the cloud-save source.
- Platform exposes only active Web/Yandex and LocalDebug services. Do not
  reintroduce custom backend auth or cloud storage without an explicit requirement.

## Web release

- Keep the sole `Web` preset exporting to `builds/web/index.html`.
- Preserve `web/yandex_shell.html`, `/sdk.js`, `YaGames.init()`, and
  `tools/package_yandex_web.py`.
- Export with `godot --headless --export-release "Web" builds/web/index.html`,
  package with `python tools/package_yandex_web.py`, and test over HTTP.
- Preserve the 720x1280 Web canvas and 720x1600 editor/default layout.

## Runtime safety

- Route Yandex lifecycle resume through `ClickerScreen` safe-resume logic.
- Pause gameplay and audio before ads; grant rewarded benefits only from the
  reward callback. Fullscreen ads grant nothing.
- Require non-empty purchase tokens, deduplicate processed purchases, persist
  important economy changes, and preserve Save System v1 field compatibility.
- Keep all player-visible text localized in Russian and English. Regenerate
  `scripts/ui/LocalizationData.gd` after localization changes.
- Debug shortcuts and fake monetization must use the existing debug guards.

## Gameplay contract

- Keep 10 zones, 5 stages per zone, the repeating 50-stage visual/content cycle,
  infinite real stage progression, 10 backgrounds, and 10 bosses.
- All non-boss encounters use the same 15 common enemy assets.
- Elite is a gameplay modifier, not a separate asset category; bosses remain zone-specific.
- Keep exactly 18 partner slots; reskins use Partner 1 through Partner 18 only.
- Use GDScript and ASCII-only asset paths. Missing image assets must fail safely.

## Template content contract

This repo is a reusable template: gameplay configs hold stable ids,
mechanics, balance values, and localization-key helpers only. Player-facing
themed text (zone/boss/partner/building/task/shop/ability/skill/prestige
names and descriptions) belongs in `localization/game_text.csv`, not in
GDScript string literals. Asset filenames use stable slot names (e.g.
`building_01.png`, `enemy_01/healthy.png`), never theme-specific names.
Reskinning into a new themed game must not require renaming gameplay-code
identifiers, adding new theme-specific fallback strings in code, or changing
the 10 backgrounds / 15 common enemies / 10 bosses / 18 partners / 6 buildings
asset contract. See
`docs/TEMPLATE_CONTENT_CONTRACT.md` for the replacement checklist.
