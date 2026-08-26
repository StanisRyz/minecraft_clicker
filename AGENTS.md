# AGENTS.md

Development rules for AI coding agents working on this repository.

## Project scope

- Godot 4.5.1, GDScript, Web/Yandex Games idle clicker.
- Web is the only release target. Do not add Android, native mobile, or other
  export targets without an explicit request.
- The project is in release-candidate cleanup. Prefer small, focused,
  individually testable patches.
- Focus on QoL, polish, and release blockers. Do not add major gameplay systems
  or change balance constants unless explicitly requested.
- Preserve the current architecture; avoid broad rewrites.
- Do not modify `scripts/tools/BalanceAuditReport.gd` unless explicitly requested.

## Platform architecture

- `autoload/Platform.gd` selects exactly two implementations:
  - Web export -> `scripts/platform/WebYandexPlatform.gd`.
  - Editor/non-Web -> `scripts/platform/LocalDebugPlatform.gd`.
- Gameplay and UI call the `Platform` autoload, never `YandexBridge` directly.
- `WebYandexPlatform` delegates Web operations to `autoload/YandexBridge.gd`;
  preserve its signal forwarding and public method contracts.
- Yandex SDK services cover ads, payments, Yandex Player saves, platform
  language, and loading/gameplay lifecycle notifications.
- LocalDebug may simulate ads and payments only when debug features are enabled.
  Production code must never grant fake rewards.
- Legacy backend/account UI and save code is currently inert outside the removed
  native-mobile path. Do not activate it on Web or couple it to Yandex saves;
  remove it only in a dedicated cleanup task.

## Web/Yandex release rules

- Keep the sole `Web` export preset writing to `builds/web/index.html`.
- Preserve `web/yandex_shell.html`, `/sdk.js`, `YaGames.init()`, and the desktop
  backdrop packaging flow in `tools/package_yandex_web.py`.
- Use a release export: `godot --headless --export-release "Web" builds/web/index.html`.
- Package with `python tools/package_yandex_web.py`; `index.html` must be at the
  archive root and exported paths must be ASCII-only.
- Test via HTTP or the Yandex Games preview cabinet, never `file://`.
- Preserve the Web viewport override
  `window/size/viewport_height.web=1280` and the 720x1280 Web canvas.

## Yandex lifecycle and ads

- `LoadingAPI.ready()` is called only after `ClickerScreen.startup_completed`.
- Gameplay start goes through `ClickerScreen.notify_yandex_game_ready()` and
  `_try_resume_yandex_gameplay()`; ad or visibility handlers must not call
  `GameplayAPI.start()` directly.
- Before an ad, add the runtime pause reason, pause audio, and stop gameplay.
  Clear the reason and use safe resume logic on close/error.
- Rewarded rewards are granted only from the rewarded callback. Close/error
  without reward grants nothing, and duplicate callbacks must not double-grant.
- Fullscreen ads grant no reward and must not interrupt unsafe UI states.
- Preserve page visibility pause handling and `YandexBridge.is_ad_in_progress()`
  checks before resuming gameplay.

## Payments and saves

- Web payments use `ysdk.getPayments()` and the Yandex catalog.
- Never grant paid rewards without a non-empty purchase token.
- Deduplicate through `ClickerState.is_purchase_processed()` /
  `mark_purchase_processed()` and persist processed tokens.
- Consumable order: grant, update UI, save locally, flush Yandex cloud save,
  then consume the purchase.
- Cancel/error grants nothing and must clear pending payment/pause state.
- Yandex Player data and local saves must remain compatible with existing saves.
- Save field names are Save System v1 contracts and must not be renamed without
  migration. BigNumber fields need absent-key handling when added.
- Flush important economy changes, purchases, ad rewards, task claims, prestige,
  and settings/language changes.

## Zone and enemy contract

- `ZoneConfig.ZONE_COUNT = 10`.
- Each zone has 5 stages; the visual/content cycle repeats every 50 stages.
- Real stage numbers remain infinite.
- Each active zone owns one same-numbered background folder and one
  same-numbered `boss_01` folder.
- Preserve cycle HP/reward scaling and boss-every-5-stages behavior.
- Keep the existing non-boss enemy pools unchanged until the separate T2
  enemy-pool simplification.

## Code organization

- Config files contain static data only: no runtime player state, SaveManager
  calls, or scene references.
- Pure formulas belong in `scripts/game/calculators/`; save serialization in
  `scripts/game/save/`; UI formatting in `scripts/game/presentation/`.
- Use GDScript only. Do not add external plugins or assets without approval.
- Keep asset paths ASCII-only and register new assets in the appropriate catalog.
- Missing image assets must fall back safely and never crash.

## UI and localization

- Use Control-based layouts, containers, and anchors.
- Supported layouts are 720x1600 editor/default and 720x1280 Web; preserve
  proportions with `canvas_items`, `keep`, and fractional scaling.
- Do not resize fixed textured windows to fit content. Prefer shorter text,
  spacing/font adjustments, hiding optional controls, or internal scrolling.
- All player-visible text belongs in `localization/game_text.csv` and must use
  `LocalizationManager.tr_key()` or `format_key()`.
- Russian is the safe fallback; English remains supported.
- After localization changes, regenerate and commit `scripts/ui/LocalizationData.gd`.

## Release safety

- Debug features must be gated by `BuildConfig.is_debug_features_enabled()` or
  the existing debug-build guard. F12/debug shortcuts and fake monetization must
  not work in production.
- Do not expose Reset Progress in production UI.
- Preserve audio multi-reason pauses (`ad`, `platform`, `payment`, `hidden`) and
  Web autoplay behavior.
- Before release, validate headless project load, localization, Web export,
  saves, ads, purchases, both locales, and supported viewport sizes.
