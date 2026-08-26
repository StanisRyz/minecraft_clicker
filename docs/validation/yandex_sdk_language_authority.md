**Update (Y4.3):** fixed a `JavaScriptBridge.eval()` bool/int interop bug in
`YandexBridge.refresh_yandex_sdk_ready()` that prevented the SDK from ever
being reported ready, which in turn blocked the SDK language path documented
below. Language-authority logic itself is unchanged. See
`docs/validation/yandex_sdk_ready_type_coercion_hotfix.md`.

# Y4.2 — Yandex SDK Language Authority

Fixes a Web/Yandex moderation gap: automatic language detection through the
Yandex SDK could be permanently blocked by a saved
`state.language_manually_selected = true` flag — set whenever the player
used the Settings language toggle, and persisted/restored from save data.
Since it's saved forever, any player/tester who ever changed language
manually would have SDK language ignored on every future Web session.

No gameplay balance, save schema, Yandex SDK init code, Yandex
payments/catalog logic, rewarded ads, Yandex Player save flow,
Android/RuStore account/cloud logic, AuthGate/AccountWindow behavior, or
backend Cloud Function/API code was changed.

## Checklist

- [x] Web/Yandex ignores saved `language_manually_selected` —
  `ClickerScreen._apply_startup_language()` branches on
  `Platform.get_platform_key() == "yandex"` first; on Web/Yandex it clears
  the flag (and saves if it was set) and always calls
  `_apply_startup_language_when_platform_ready()`, never returning early
  because of a saved manual selection.
- [x] Web/Yandex applies SDK `ru` — unchanged normalization path
  (`LocalizationManager.normalize_supported_language()`), now always
  reached on Web/Yandex regardless of the manual flag.
- [x] Web/Yandex applies SDK `en` — same path as above.
- [x] Old save with `language_manually_selected = true` does not block SDK
  language — the Web/Yandex branch in `_apply_startup_language()` clears the
  flag before the retry loop runs, so a pre-Y4.2 Yandex save with the flag
  set behaves exactly like a fresh save.
- [x] Settings language row is hidden on Web/Yandex —
  `SettingsWindow._ready()` only calls `_create_language_row()` when
  `Platform.get_platform_key() != "yandex"`. `_refresh_static_labels()`,
  `_update_language_button()`, and `refresh_view()` were already null-safe
  (`if _language_label:` / `if _language_button == null: return`), so no
  further changes were needed there.
- [x] Settings language row still exists on Android/Local —
  `Platform.get_platform_key()` returns `"android_rustore"` /
  `"local_debug"` there, so the gate is a no-op and the row is created as
  before.
- [x] Android manual language behavior unchanged — non-Yandex branch of
  `_apply_startup_language()` / `_apply_startup_language_when_platform_ready()`
  / `_on_language_manually_changed()` is byte-for-byte the pre-Y4.2 logic.
- [x] Yandex SDK retry from Y4.1 preserved — `_apply_startup_language_when_platform_ready()`
  still retries up to `STARTUP_LANGUAGE_MAX_RETRY_ATTEMPTS` every
  `STARTUP_LANGUAGE_RETRY_DELAY_SEC` and falls back to the saved language
  with a toast after ~8s if the SDK never reports one.
- [x] Gameplay/payment/save/ad logic unchanged — only
  `ClickerScreen.gd`'s language functions and `SettingsWindow.gd`'s row
  creation were touched.

## What changed

| File | Change |
|---|---|
| `scenes/game/ClickerScreen.gd` | `_apply_startup_language()`: added a Web/Yandex-first branch that clears `state.language_manually_selected` (saving if it changed) and always calls `_apply_startup_language_when_platform_ready()`, never returning early on a saved manual flag. Non-Yandex behavior unchanged. `_apply_startup_language_when_platform_ready()`: the early `if state.language_manually_selected: return` guard now only applies on non-Yandex platforms; when a Web/Yandex platform language resolves, `state.language_manually_selected` is explicitly reset to `false` (and saved if either the language or the flag changed), so future starts keep trusting the SDK instead of the saved language. `_on_language_manually_changed()`: on Web/Yandex, resets `state.language_manually_selected = false` and ignores the change instead of persisting it (safety net if the hidden toggle is ever reached). |
| `scenes/ui/SettingsWindow.gd` | `_ready()` now only calls `_create_language_row()` when `Platform.get_platform_key() != "yandex"`, so the manual language row/button are never created on Web/Yandex. No other UI wiring changed — `_language_label`/`_language_button` were already null-checked everywhere they're used. |
| `docs/validation/yandex_sdk_language_authority.md` | New (this file). |
| `docs/validation/yandex_sdk_runtime_readiness_error_handling.md` | Added a note that Y4.2 makes SDK language authoritative on Web/Yandex; the Y4.1 retry loop itself is unchanged. |
| `docs/validation/yandex_release_audit_platform_separation.md` | Updated the Language section with a Y4.2 update block. |
| `README.md` | Updated the Web/Yandex bullet list and added a Y4.2 follow-up entry. |
| `AGENTS.md` | Updated the Web/Yandex language rule and added a rule against exposing the manual toggle on Web/Yandex. |

## Design notes

- The platform check lives at the top of `_apply_startup_language()` rather
  than inside `_apply_startup_language_when_platform_ready()` alone, because
  the manual-flag short-circuit in the outer function
  (`if state.language_manually_selected: LocalizationManager.set_language(...); return`)
  was the actual bug — it could return before ever calling the
  platform-ready path. Web/Yandex now skips that short-circuit entirely.
- `_apply_startup_language_when_platform_ready()` still keeps its own
  manual-flag guard for the retry-in-progress case, but it's now gated to
  `not is_yandex` so a manual selection still blocks retries on
  Android/Local (unchanged) but never on Web/Yandex.
- No save-schema change: `language_manually_selected` remains a normal
  field on `ClickerState`/the save adapter. Y4.2 only changes when the
  *game* trusts it, not how it's persisted — Android/Local saves round-trip
  exactly as before, and Yandex saves keep the field (now effectively
  ignored on Web at startup) so no migration or format change was needed.
- Hiding the row (not just disabling the button) was used for Web/Yandex
  per the task's stated moderation preference — a disabled-but-visible
  language toggle next to an SDK-driven language is more likely to read as
  broken/confusing than a settings panel that simply doesn't offer the
  option.

## Validation commands run

```bash
godot --headless --editor --quit
godot --headless --script res://scripts/tools/ValidateLocalizationDataFreshness.gd
godot --headless --script res://scripts/tools/ValidateLocalizationExport.gd
git status
git diff --stat
```

No localization keys were added or changed by this patch, so
`GenerateLocalizationData.gd` was not run.

## Manual Yandex preview validation (not run — requires the Yandex console/preview)

1. Build a fresh Web export.
2. Run it through the Yandex preview/debug panel, not `file://`.
3. Confirm `window.ysdk` exists, `window.ysdkReady === true`, and
   `window.ysdk.environment.i18n.lang` has the expected value.
4. Test with SDK language `ru` — confirm the UI becomes Russian
   automatically.
5. Test with SDK language `en` — confirm the UI becomes English
   automatically.
6. Load an old save where `language_manually_selected = true` was set by a
   previous manual language change — confirm it no longer blocks SDK
   language on startup.
7. Open Settings on Web/Yandex — confirm the manual language row/button is
   not present.
8. Open Settings on Android/Local — confirm the manual language row/button
   is still present and still works.
9. Confirm payments/catalog/ads/save behavior is unchanged on Web/Yandex.

## Files inspected

`scenes/game/ClickerScreen.gd`, `scenes/ui/SettingsWindow.gd`,
`scenes/ui/SettingsWindow.tscn`, `scripts/game/ClickerState.gd`,
`scripts/game/save/ClickerStateSaveAdapter.gd`,
`scripts/ui/LocalizationManager.gd`, `autoload/Platform.gd`,
`autoload/YandexBridge.gd`, `scripts/platform/WebYandexPlatform.gd`,
`localization/game_text.csv`, `scripts/ui/LocalizationData.gd`, `README.md`,
`AGENTS.md`, `docs/validation/yandex_sdk_runtime_readiness_error_handling.md`,
`docs/validation/yandex_release_audit_platform_separation.md`.
