# Y5.1 — Russian-Only User-Facing Text Audit

## Scope and result

Inspected the localization manager/data, gameplay state, presentation helpers,
shop runtime/configs, task/config sources, and UI paths. Russian is now the
safe default and fallback language; English translations remain in
`localization/game_text.csv` for supported non-Yandex use.

## Changes

- `LocalizationManager.DEFAULT_LANGUAGE` and its initial language are `ru`.
  Unsupported SDK or saved language values normalize to Russian. Missing Russian
  text no longer falls through to English.
- Save-state language defaults also use Russian.
- Core gameplay status messages, shop runtime messages, ability descriptions,
  and enemy-name fallbacks use Russian direct fallbacks where a localization key
  is not practical.
- Filled the previously empty Russian shop entries for Boss Retry and Task
  Reward Boost. `LocalizationData.gd` is regenerated from the CSV.

## Hardcoded English audit

`ValidateNoUserFacingEnglish.gd` scans the core runtime/presentation files for
string literals containing likely English phrases. It ignores comments, paths,
debug logs, internal ids, and accepted technical abbreviations (`DPS`, `HP`,
`CD`). It is intentionally lightweight; localization keys and config ids remain
English because they are internal data, not UI output.

## Manual Yandex RU preview

1. Build a fresh Web export and open Yandex Preview with Russian SDK language.
2. Open gameplay, upgrades, partners, settlement, prestige, shop, gem dialog,
   settings, tasks, offline reward, and rewarded-ad states.
3. Confirm normal UI/status text contains no English phrases.
4. Verify ads, purchases, saves, and rewards still complete normally.
