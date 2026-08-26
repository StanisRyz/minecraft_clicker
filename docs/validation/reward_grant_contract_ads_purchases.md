# Y4.4 — Reward Grant Contract: Ads and Purchases

## Root issue

The shop rewarded-ad helper read a balance fallback instead of the
`rewarded_gems_ad` shop product, and the callback treated failed grants as
successful rewards. Y4.4 makes state-level grant contracts explicit and only
does UI, audio, save, and cloud work after a successful grant.

## Files inspected

- `scenes/game/ClickerScreen.gd`
- `scripts/game/ClickerState.gd`
- `scripts/game/runtime/ShopRuntime.gd`
- `scripts/game/config/ShopConfig.gd`
- `scripts/game/config/GemPurchaseConfig.gd`
- `scripts/game/BalanceConfig.gd`
- `scripts/game/save/ClickerStateSaveAdapter.gd`
- `scenes/ui/ShopPanel.gd`
- `scenes/ui/RewardedAdBanner.gd`
- `scenes/ui/GemPurchaseDialog.gd`

## Contracts verified

- Shop rewarded gems reads `ShopConfig.rewarded_gems_ad.reward_gems` (+3),
  falling back to `BalanceConfig.SHOP_REWARDED_GEMS_AD_REWARD` only if absent.
- Banner `all_damage_x2`, `gems_5`, and `gold_x4` use the existing damage,
  gems, gold, and duration constants in `BalanceConfig`. The persisted
  `rewarded_ad_gold_x2_expires_at` name is retained for save compatibility;
  the current gold multiplier is x4.
- Unknown banner reward ids and unknown paid products return failed results and
  grant nothing. Paid amounts come from `GemPurchaseConfig`: 25, 150, 500,
  and 1500.
- Purchase ids remain serialized by `ClickerStateSaveAdapter`, reject empty
  ids, deduplicate, and retain only the configured maximum.

## Callback and persistence audit

- Shop gems, banner gems/buffs, and offline x3 save and request a cloud flush
  after a successful rewarded callback.
- Paid purchase order remains: validate token → dedupe → pending-product
  validation → mark token → grant → UI → save/cloud flush → consume.
- Recovery rejects an empty purchase id before any grant. Valid recovered
  purchases are marked, granted, saved/cloud-flushed, then consumed.
- Close, error, and timeout paths grant nothing; existing pause handlers resume
  audio/gameplay and clear the shop button pressed state where applicable.

## Automated validation

`scripts/tools/ValidateRewardGrantContract.gd` checks shop +3, banner +5,
each paid product, unknown paid-product safety, and duplicate/empty token
behavior.

```sh
godot --headless --script res://scripts/tools/ValidateRewardGrantContract.gd
```

## Manual Yandex Preview checklist

1. Watch the shop rewarded ad and confirm gems increase by +3.
2. Claim each banner reward: gems +5, all damage x2, gold x4.
3. Claim offline x3 and confirm pending offline gold is tripled.
4. Purchase each paid product and confirm +25, +150, +500, and +1500 gems.
5. Reload after a paid purchase and confirm its token cannot grant twice.
6. Close, fail, or allow a rewarded ad to timeout; confirm no reward is
   granted, the shop button resets, and audio/gameplay resume.
