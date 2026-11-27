# AGENTS.md — AI-agents section maintenance rules

Rules for maintaining the AI-agents section of this dotfiles repo. These rules
apply to any agent working in this repository. The runnable version of the
audit cycle is available as `/update-ai-agents` in every bundled agent:

- Pi: `.pi/prompts/update-ai-agents.md`
- Claude Code: `.claude/commands/update-ai-agents.md`
- OpenCode: `.opencode/commands/update-ai-agents.md`
- CommandCode: `.commandcode/commands/update-ai-agents.md`

## Scope

Four coding-agent tools, one shell, one table:

| Tool        | Config of record                                                 | Docs / schema                                                   |
| ----------- | ---------------------------------------------------------------- | --------------------------------------------------------------- |
| Claude Code | `.claude/settings.json` (symlinked to `~/.claude/settings.json`) | docs.claude.com `settings-reference.md` / `env-vars.md`         |
| OpenCode    | `.config/opencode/opencode.json` (+ `cli.json`)                  | `opencode.ai/config.json`, GitHub releases `anomalyco/opencode` |
| Pi          | `.pi/agent/settings.json` + `.pi/agent/models.json`              | `pi.dev/schemas`, GitHub `earendil-works/pi`                    |
| CommandCode | `.commandcode/settings.json` + `.commandcode/config.json`        | npm package `command-code`                                      |
| fish        | `.config/fish/config.fish`                                       | —                                                               |
| README      | `README.md` → AI Agents table                                    | —                                                               |

Other repo areas are out of scope unless asked.

## Standing constraints (do not violate)

1. **Fish skeleton is authoritative** — insert-only into the
   semantically-closest existing section; never reorganize or renumber the
   file (see git `7ad00c6`).
2. **OpenCode live-app protocol** — `pkill -f opencode` before any
   `opencode.json` edit; the `opencode serve --service` process rewrites the
   file from in-memory/db state and will clobber concurrent edits.
3. **No secrets in dotfiles** — no API keys, tokens, or auth files. Auth
   lives outside the repo (e.g. `~/.local/share/opencode/auth.json`).
4. **Context caps** — active models capped at 272K context / 244K compaction;
   keep catalog-declared output limits; set explicit `"disabled": false` on
   active models. Leave service-resurrected OpenCode models alone if they are
   ≤272K.
5. **Code Mode = MCP-tools-only** everywhere: Pi `codemode: {mode: "on"}`,
   CommandCode `"codemode": "mcp"`, Claude `ENABLE_TOOL_SEARCH=1` (+ Code Mode
   `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE=1`).
6. **OpenCode provider keepers**: `opencode-go` + `zai-coding-plan` only.
   Zen (`opencode` provider ID) and console account-synced models bypass
   config — gate via `opencode auth logout "OpenCode Console"` in an
   interactive terminal, never via config keys.
7. **Deprecation sweep** — on every audit, drop keys the new release removed
   (already removed upstream: `enabled_providers`, `disabled_providers`,
   singular `provider`, `small_model`,
   `experimental.background_compaction`). Watch `experimental.policies`.
8. **Privacy posture** — telemetry and nonessential traffic stay off in all
   four tools (`DISABLE_TELEMETRY=1`,
   `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`, Pi/CommandCode equivalents).
9. **Validate before finishing** — `python3 -m json.tool` every changed JSON
   file, `fish -n .config/fish/config.fish`, then report `git status`.
10. **Ask before behavior changes** — new upstream defaults are reported as
    decision points, never silently pinned.

## Version oracles

| Tool        | "Latest" source                                                                              |
| ----------- | -------------------------------------------------------------------------------------------- |
| Claude Code | `brew info --cask claude-code@latest` + npm `@anthropic-ai/claude-code` + official CHANGELOG |
| OpenCode    | brew tap `anomalyco/opencode-v2` + GitHub releases API (NOT npm)                             |
| Pi          | `pi --version` vs GitHub releases `earendil-works/pi`                                        |
| CommandCode | `npm view command-code version` (bun global install)                                         |

## Compat floors

`README.md` "Compatible" column = oldest of the **last 10 releases** of each
tool. Roll it forward whenever the 10th-newest release changes. Current floors
and installed versions are maintained in the README table; this file does not
duplicate them.

## Standard audit cycle (the "again" ritual)

1. **Versions** — compare installed vs latest for all four tools.
2. **Changelogs** — for every version gap, pull the changelog / release notes
   and extract config-relevant items: new keys, removed keys, changed
   defaults, deprecations, plus notable fixes worth telling the user.
3. **Config impact** — per finding, decide: pin a new key, migrate a removed
   key, or "no impact". Verify new keys exist in the installed binary before
   pinning (grep the binary/schema; never guess key names).
4. **Floors** — recompute from the last 10 releases; roll the README table
   ("Version" = installed, "Compatible" = floor).
5. **Validation** — JSON-parse all four configs, `fish -n`, `git status`.
6. **Report** — versions table, changelog highlights, floors rolled, decision
   points. Leave uncommitted changes listed for the user to commit.
