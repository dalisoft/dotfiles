---
description: Version-audit the AI-agents section (Claude Code, OpenCode, Pi, CommandCode): versions, changelogs, floors, README sync, validation
---

Run the standard AI-agents audit cycle on this dotfiles repo, exactly as
defined in AGENTS.md (§Version oracles, §Compat floors, §Standard audit
cycle). Honor every standing constraint in AGENTS.md — especially the OpenCode
live-app protocol (pkill before editing `opencode.json`), the fish
insert-only rule, and "ask before behavior changes".

1. **Versions** — installed vs latest for Claude Code, OpenCode, Pi,
   CommandCode using the oracles in AGENTS.md.
2. **Changelogs** — for each version gap, pull the changelog/release notes and
   list config-relevant changes (new keys, removed keys, changed defaults,
   deprecations) plus notable fixes. Verify any key you consider pinning
   against the installed binary or schema first.
3. **Config impact** — migrate removed keys, evaluate new ones as decision
   points; do not change behavior defaults without asking.
4. **Floors + README** — floor = oldest of the last 10 releases per tool;
   update the README AI Agents table ("Version" = installed, "Compatible" =
   floor).
5. **Validation** — `python3 -m json.tool` on every changed JSON config,
   `fish -n .config/fish/config.fish`, then `git status`.
6. **Report** — versions table, changelog highlights per tool, floors rolled,
   validation results, decision points, uncommitted files.

$ARGUMENTS
