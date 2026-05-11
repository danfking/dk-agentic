# Codex CLI adapter

Status: stub. Notes only, no automation yet.

The portable layer in `dk-agentic` (`skills/`, `prompts/`, `mcp/`) is plain markdown and JSON, so most of it ports to Codex CLI with a small amount of glue. This file records what the glue looks like today.

## What maps cleanly

**MCP servers.** Codex CLI reads MCP server config from `~/.codex/config.toml` under the `[mcp_servers]` table. The shape of `mcp/config.json` here can be transcribed directly. Example:

```toml
# ~/.codex/config.toml
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]
```

is the TOML equivalent of:

```json
// dk-agentic/mcp/config.json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

A short `scripts/sync-mcp-to-codex.ps1` could automate this, but I haven't written one yet.

**Skills as instructions.** Codex CLI reads `AGENTS.md` from the repo root for context. To use a skill from `dk-agentic/skills/<name>/SKILL.md`, either:

- Copy the body into your repo's `AGENTS.md` under a section heading, or
- Reference it explicitly with a relative path: `See @.claude-plugins/dk-agentic/skills/grill-me/SKILL.md for the grill-me workflow.`

Codex resolves `@<path>` references at chat time.

## What doesn't map yet

**Slash commands.** Claude Code's `commands/` folder has no Codex equivalent. Codex's own slash commands aren't user-extensible the same way. The closest workaround is to prompt Codex with the command body inline or to bind a shell alias that runs `codex exec` with a canned prompt.

**SessionStart hooks.** Codex CLI doesn't have an equivalent of Claude Code's hooks. The "auto-clone on first open" pattern has to happen manually or via a wrapper shell function.

## What I'd build if I cared more

A small `scripts/dk-agentic-codex` wrapper that, on first run in a repo, clones `dk-agentic` into `.dk-agentic/` (note: not `.claude-plugins/`, since that's Claude-specific) and merges the MCP config into `~/.codex/config.toml`. Out of scope for now.
