# Y4.3 — YandexBridge SDK Ready Type Coercion Hotfix

Fixes a real Web/Yandex runtime failure found in preview testing, on top of
the Y4.1/Y4.2 SDK-readiness/language work:

```
SDK Init. Version: v2. Is loader: true.
Yandex SDK initialized
SCRIPT ERROR: Invalid operands 'int' and 'bool' in operator '=='.
   at: refresh_yandex_sdk_ready (res://autoload/YandexBridge.gd:146)
```
(repeated on every retry)

## Root cause

`YandexBridge.refresh_yandex_sdk_ready()` did:

```gdscript
var result = JavaScriptBridge.eval(...)   # JS boolean, but Web export can
                                           # surface it to GDScript as int (1/0)
is_yandex_available = result == true      # int == bool -> runtime error in Godot 4.5
```

Because the comparison threw, `is_yandex_available` was never reliably set to
`true`, so every SDK-dependent path that gates on `_is_ysdk_ready()` /
`refresh_yandex_sdk_ready()` failed or looped: SDK language never applied,
`game_ready()`/`LoadingAPI.ready()` retried until timeout, `GameplayAPI.start()`
never ran, the gem shop stayed on endless "Loading price...", and rewarded
ads/cloud saves/unprocessed-purchase checks all treated the SDK as not ready.

The same unsafe pattern (`has_on != true`) existed once more, in
`_setup_platform_event_callbacks()`'s `ysdk.on` availability check.

## Fix

- Added `YandexBridge._variant_to_bool(value: Variant, default_value: bool = false) -> bool`,
  normalizing `TYPE_BOOL`, `TYPE_INT` (`!= 0`), `TYPE_FLOAT` (`not is_zero_approx`),
  `TYPE_STRING` (`"true"/"1"/"yes"/"y"`, case-insensitive), and any other type
  (falls back to `default_value`).
- `refresh_yandex_sdk_ready()`'s JS side now returns an explicit `1`/`0`
  instead of a raw JS boolean, and the GDScript side uses
  `is_yandex_available = _variant_to_bool(result, false)` instead of
  `result == true`.
- `_setup_platform_event_callbacks()`'s `has_on` check was changed the same
  way (JS returns `1`/`0`; GDScript uses `_variant_to_bool()`).
- Both JS snippets already wrapped their logic in `try/catch` returning a safe
  falsy value, so `refresh_yandex_sdk_ready()` cannot throw from either the JS
  or the GDScript side after this patch.
- `ClickerState.is_debug_visual_test_mode_enabled()` /
  `set_debug_visual_test_mode_enabled()` now also force debug visual test
  mode off whenever `Platform.get_platform_key() == "yandex"` and
  `BuildConfig.IS_DEBUG_BUILD` is `false` — a second, independent gate next to
  the existing F12-toggle guard in `ClickerScreen._input()`
  (`if not BuildConfig.IS_DEBUG_BUILD: return` before the F-key `match`).

No Yandex SDK script include, `YaGames.init()` HTML logic, product ids,
purchase/credit/consume/recovery logic, Yandex catalog mapping, `SaveManager`
schema, Android/RuStore flow, or gameplay balance was changed.

## Checklist

- [x] Log root cause confirmed — `int == bool` in
  `refresh_yandex_sdk_ready()` at the exact reported line.
- [x] `refresh_yandex_sdk_ready()` no longer compares int to bool — uses
  `_variant_to_bool()`.
- [x] `_variant_to_bool()` helper added, matching the required signature and
  type coverage (`bool`/`int`/`float`/`String`/default).
- [x] No unsafe JS-eval bool comparisons remain in `YandexBridge.gd` — audited
  every `JavaScriptBridge.eval()` call site; only `refresh_yandex_sdk_ready()`
  and the `ysdk.on` check compared eval results to bool literals, both fixed.
  `get_yandex_language()` and `get_yandex_runtime_debug_state()` already used
  `is String`/type checks, not bool comparisons — unchanged.
- [x] SDK ready emits after "Yandex SDK initialized" — `yandex_sdk_ready`
  signal/emission logic in `refresh_yandex_sdk_ready()` is otherwise
  unchanged (still guarded by `_sdk_ready_signal_emitted`), it just now
  receives a correctly-typed `is_yandex_available`.
- [x] No repeated `Invalid operands 'int' and 'bool'` — the comparison that
  caused it no longer exists.
- [x] Language applies from SDK — unchanged Y4.1/Y4.2 retry path in
  `ClickerScreen`, now actually reachable because
  `Platform.get_platform_language()` → `_is_ysdk_ready()` can report ready.
- [x] Ready no longer times out — `game_ready()`/`gameplay_start()` retry
  loops call `_is_ysdk_ready()`, which now returns `true` once the SDK is
  actually up instead of erroring every attempt.
- [x] Catalog does not stay loading forever — `load_payment_catalog()` gates
  on `_is_ysdk_ready()`; the existing Y4.1 9s catalog timeout is unchanged and
  still applies if the catalog genuinely never resolves.
- [x] Rewarded ad path no longer fails due to the SDK-ready check throwing —
  `show_rewarded_ad()`'s `_is_ysdk_ready()` gate and the existing Y4.1 7s
  timeout are both unchanged, now reachable without a runtime error.
- [x] Debug visual test mode is OFF for Web/Yandex release —
  `ClickerState._debug_visual_test_mode_allowed()` returns `false` whenever
  `Platform.get_platform_key() == "yandex"` and not `BuildConfig.IS_DEBUG_BUILD`,
  independent of the pre-existing F12/`IS_DEBUG_BUILD` input gate.
- [x] Purchase/consume/recovery unchanged — `purchase_product()`,
  `consume_purchase()`, `check_unprocessed_purchases()`, and their JS bodies
  were not touched.
- [x] Android/RuStore unchanged — no files under
  `scripts/platform/AndroidRuStorePlatform.gd` or Android ad/payment plugins
  were touched; this patch only touches `YandexBridge.gd` and
  `ClickerState.gd`'s debug-visual-test-mode getters/setters.

## What changed

| File | Change |
|---|---|
| `autoload/YandexBridge.gd` | Added `_variant_to_bool()`. `refresh_yandex_sdk_ready()`'s JS now returns `1`/`0`; GDScript uses `_variant_to_bool()` instead of `result == true`. `_setup_platform_event_callbacks()`'s `ysdk.on` check uses the same pattern instead of `has_on != true`. |
| `scripts/game/ClickerState.gd` | `is_debug_visual_test_mode_enabled()` / `set_debug_visual_test_mode_enabled()` now also gate off via new `_debug_visual_test_mode_allowed()` (`false` on Web/Yandex outside a debug build). |
| `README.md` | Added a Y4.3 entry to the Yandex Release Readiness list. |
| `AGENTS.md` | Added rules: never compare raw `JavaScriptBridge.eval()` results to bool literals; normalize via `_variant_to_bool()`; SDK-ready checks must never throw; Web/Yandex release must not run debug visual test mode; don't mix this hotfix with gameplay/payment changes. |
| `docs/validation/yandex_sdk_runtime_readiness_error_handling.md`, `docs/validation/yandex_sdk_language_authority.md`, `docs/validation/yandex_payments_catalog_price_display.md` | Added a short Y4.3 update note pointing here. |
| `docs/validation/yandex_sdk_ready_type_coercion_hotfix.md` | New (this file). |

## Design notes

- `_variant_to_bool()` lives on `YandexBridge` (not a shared/global util)
  because it exists specifically to normalize `JavaScriptBridge.eval()`
  results, and `YandexBridge` is the only place in the codebase that calls
  `JavaScriptBridge.eval()`.
- The JS side was changed to return `1`/`0` explicitly (rather than relying on
  `_variant_to_bool()` alone to paper over whatever JS-boolean marshalling
  Godot's Web export does) so the eval contract is unambiguous on both sides;
  `_variant_to_bool()` remains as defense-in-depth for any other value type
  that could arrive.
- The debug-visual-test-mode guard was added at the `ClickerState` getter/setter
  level (not just the existing `ClickerScreen._input()` F12 gate) so that any
  future call site that flips or reads `debug_visual_test_mode_enabled`
  — including a stray one that doesn't go through the F-key handler — cannot
  accidentally activate it on a live Yandex release build.

## Validation commands run

```bash
godot --headless --editor --quit
godot --headless --script res://scripts/tools/ValidateLocalizationDataFreshness.gd
godot --headless --script res://scripts/tools/ValidateLocalizationExport.gd
git status
git diff --stat
```

No localization keys were added or changed by this patch.

## Manual Yandex preview validation (not run — requires the Yandex console/preview)

1. Build a fresh Web export.
2. Upload the ZIP to a Yandex draft and open it through Yandex
   Preview/debug panel (not `file://`).
3. Confirm the log contains `Yandex SDK initialized`.
4. Confirm the log does **not** contain:
   - `Invalid operands 'int' and 'bool'`
   - `refresh_yandex_sdk_ready (res://autoload/YandexBridge.gd:146)`
   - a `game_ready`/ready timeout warning
   - `Debug visual test mode: ON`
5. Confirm the UI language follows `window.ysdk.environment.i18n.lang` (RU
   SDK language → RU UI, EN SDK language → EN UI).
6. Open the gem shop — confirm prices load or a proper catalog
   error/unavailable state appears, never endless "Loading price...".
7. Press the rewarded ad button — confirm it opens, or a graceful
   unavailable message appears and gameplay/audio resume.
8. Confirm a purchase still credits gems exactly once, is consumed, and
   unprocessed-purchase recovery still works (unchanged from Y4/Y4.1).

## Files inspected

`autoload/YandexBridge.gd`, `autoload/Platform.gd`,
`scripts/platform/WebYandexPlatform.gd`, `scenes/game/ClickerScreen.gd`,
`scenes/ui/GemPurchaseDialog.gd`, `scripts/game/ClickerState.gd`,
`scripts/game/BuildConfig.gd`, `export_presets.cfg`, `README.md`, `AGENTS.md`,
`docs/validation/yandex_sdk_runtime_readiness_error_handling.md`,
`docs/validation/yandex_sdk_language_authority.md`,
`docs/validation/yandex_payments_catalog_price_display.md`.
