# MCP server configs

`config.json` is a portable list of MCP servers I want available across agents. None of them are wired up by default. To use one:

- **Claude Code:** add an entry to `.claude-plugin/plugin.json` under `mcpServers` (or to your repo's `.mcp.json`).
- **Codex CLI:** copy into `~/.codex/config.toml` under `[mcp_servers]`. See `adapters/codex/README.md`.
- **Gemini Code Assist:** add to your IDE settings under `gemini.mcp.servers`. See `adapters/gemini-code-assist/README.md`.

The point of keeping the shared list here is that when I add a new MCP server I find useful, the config goes in one place rather than three.
