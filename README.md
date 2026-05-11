# dk-agentic

A personal toolkit of skills, prompts, and MCP server configs that follows me across repos and across coding agents.

The content is provider-agnostic. The wrapper today is Claude Code; Codex CLI and Gemini Code Assist adapters are stubs with notes on how they would wire in.

## Why this exists

When I started using Claude Code seriously across half a dozen personal repos, I noticed I was copy-pasting the same `.claude/` folder into every one of them. Each copy slowly drifted out of sync with the others. The fix was to put all the shared tooling into one repository and pull it into each consumer repo with a tiny `SessionStart` hook.

This repo is the public version of that pattern. I have a private equivalent at work; the design idea is the same.

There is a longer write-up of the pattern on my blog (linked once the post lands).

## Layout

```
dk-agentic/
  .claude-plugin/plugin.json       # Claude Code plugin manifest
  commands/                        # Claude Code slash commands
  scripts/                         # Claude Code launcher + example consumer settings
  skills/                          # Portable. Plain SKILL.md, any agent can read these.
  prompts/                         # Portable.
  mcp/                             # Portable. MCP server configs.
  hooks/                           # Portable. Validators, observers, notifiers as scripts.
  adapters/
    codex/                         # Notes on wiring the portable layer into Codex CLI
    gemini-code-assist/            # Notes on wiring it into Gemini Code Assist
  docs/
    using-third-party-skills.md    # How I vendor skills from other people I like
```

The provider-agnostic claim is about `skills/`, `prompts/`, `mcp/`, and `hooks/`. Those are plain markdown, JSON, or scripts that read structured input on stdin. Any agent that can invoke a shell command can use them. The Claude-specific bits (plugin manifest, slash commands, launcher, hook *wiring*) sit alongside but don't constrain what's underneath. See `hooks/README.md` for the split between the portable script and the agent-specific wiring.

## Quickstart for Claude Code

In a consumer repo, drop this into `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [{
      "hooks": [{
        "type": "command",
        "command": "bash -c \"test -d .claude-plugins/dk-agentic || git clone https://github.com/danfking/dk-agentic.git .claude-plugins/dk-agentic\"",
        "timeout": 30000
      }]
    }]
  }
}
```

Then add `.claude-plugins/` to that repo's `.gitignore`.

Open Claude Code in the repo, the plugin clones itself in. Launch with the plugin loaded:

```
claude --plugin-dir .claude-plugins/dk-agentic
```

If you'd rather have a wrapper that auto-pulls the plugin and relaunches Claude for you, source one of the launchers from `scripts/` into your shell profile:

```powershell
# PowerShell
. "$PWD\.claude-plugins\dk-agentic\scripts\dk-agentic.ps1"
```

```bash
# Bash / zsh
source ".claude-plugins/dk-agentic/scripts/dk-agentic.sh"
```

Then `dk-agentic` does the same thing as `claude --plugin-dir ...`, plus a `git pull` on the plugin first.

## Using the portable layer with other agents

See `adapters/codex/README.md` and `adapters/gemini-code-assist/README.md` for current mapping notes. Short version: skills and prompts are markdown, MCP configs are JSON, both layers move across agents with no transformation.

## Vendoring skills from other people

I cherry-pick skills from people whose work I like. The recipe is in `docs/using-third-party-skills.md`. The first vendored example here is Matt Pocock's `grill-me`.

## License

MIT. See `LICENSE`.
