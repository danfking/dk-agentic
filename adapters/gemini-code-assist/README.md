# Gemini Code Assist adapter

Status: stub. Notes only, no automation yet.

Gemini Code Assist runs inside VS Code or JetBrains rather than as a standalone CLI, which makes the integration story noticeably different from Claude Code or Codex CLI. Some of the portable layer here still translates; some doesn't.

## What maps cleanly

**Context files.** Gemini Code Assist reads `GEMINI.md` at the repo root for project-level context. The contents of any `dk-agentic/skills/<name>/SKILL.md` can be pasted into a section of `GEMINI.md`, or referenced by file path.

**MCP servers.** Recent versions of Gemini Code Assist support MCP via the IDE settings (`gemini.mcp.servers` in VS Code's `settings.json`). The shape is similar to `mcp/config.json` here. Worth checking the current docs for the exact key.

## What doesn't map

**Slash commands.** No equivalent. The Claude Code `commands/` folder is unused on this side.

**SessionStart hooks.** No equivalent. The plugin-fetch-on-first-open pattern doesn't apply; the IDE extension manages its own lifecycle.

**Launcher scripts.** Same, no shell-side wrapper needed.

## What I'd build if I cared more

A minimal `GEMINI.md` template at the repo root that points at `dk-agentic/skills/` for context, plus a checked-in VS Code workspace settings file with the MCP servers populated from `mcp/config.json`. Out of scope for now.
