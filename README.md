# dotfiles

@dalisoft dot-files for better productivity

## Features

- Lighting-Fast entering
- Fish + starship support
- fnm (nvm alternative) support
- n/vim and nano support
- On-demand commands
- Auto ENV and PATH for apps
- nFanCurve for Linux (NVIDIA GPU)
- Versioned OpenCode and Pi configuration

## Included configurations

### AI Agents

Configuration mostly should be compatible with 5 last previous versions.

| Name        | Reference                                                          | Version  | Compatible         |
| ----------- | ------------------------------------------------------------------ | -------- | ------------------ |
| Claude Code | [`.claude/settings.json`](.claude/settings.json)                   | v2.1.332 | v2.1.323 and later |
| CommandCode | [`.commandcode`](.commandcode)                                     | v1.93.0  | v1.89.0 and later  |
| OpenCode    | [`.config/opencode/opencode.json`](.config/opencode/opencode.json) | v2.3.2   | v2.2.1 and later   |
| Pi          | [`.pi/agent/settings.json`](.pi/agent/settings.json)               | v1.6.1   | v1.0.4 and later   |

### AI MCP Auth

| Agent      | Command                   | Guide                                                                             |
| ---------- | ------------------------- | --------------------------------------------------------------------------------- |
| `claude`   | `/mcp` command ->         | [Guide](https://code.claude.com/docs/en/mcp#authenticate-with-remote-mcp-servers) |
| `opencode` | `opencode mcp auth <mcp>` | [Guide](https://opencode.ai/docs/mcp-servers/#oauth)                              |
| `pi`       | `pi mcp login <mcp>`      | [Guide](https://docs.pi.dev/latest/mcp#authenticate-with-oauth)                   |

## License

Apache-2.0 License
