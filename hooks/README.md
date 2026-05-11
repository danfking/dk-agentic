# Hooks

Deterministic, side-effect-light scripts that fire on agent lifecycle events. Useful for blocking unsafe actions, collecting metrics, or notifying you that something happened.

## What's portable, what isn't

The **scripts** here are portable. Each one reads a structured event on stdin, decides something, and signals the result via exit code (and optionally stdout/stderr). That contract has nothing agent-specific in it.

The **wiring** that says "fire this script on event X with matcher Y" lives in each adapter, since every agent expresses lifecycle events differently. For Claude Code that means a `hooks` block in `.claude/settings.json` or in the plugin manifest. See `adapters/codex/README.md` and `adapters/gemini-code-assist/README.md` for the equivalents (or absence).

## Layout

```
hooks/
  validators/      # Block unsafe actions. Exit 2 to refuse, exit 0 to allow.
  observers/       # Record what happened. Stdout/stderr ignored. Exit 0 always.
  notifiers/       # Side-effectful: chime, push, slack. Best-effort.
```

The split is by *intent*, not by lifecycle event. A single PreToolUse event might fan out to a validator AND an observer; the wiring decides.

## The contract

Each kind has a slightly different contract because the failure modes are different.

### Validators (block on failure)

```
stdin:    JSON envelope from the agent (tool name, tool input, transcript path, ...)
stdout:   ignored
stderr:   human-readable reason if blocking
exit 0:   allow the action
exit 2:   block the action; agent shows the stderr message back to the user and the model
exit !=2: treat as agent error, fail loud (don't silently allow)
```

Any non-trivial validator should also produce a one-line audit log so you can later answer "why did this get blocked yesterday?".

### Observers (always allow)

```
stdin:    JSON envelope
stdout:   ignored
stderr:   ignored
exit 0:   always (even if recording fails). Observers must not block the agent.
```

### Notifiers (best-effort)

```
stdin:    JSON envelope
stdout:   ignored
stderr:   logged at debug level
exit 0:   always
```

## Starter: `validators/no-secrets.js`

Blocks `Write`/`Edit`/`MultiEdit` calls that target obvious credential file names (`.env`, `.pem`, `id_rsa`, etc.) or whose content matches well-known secret shapes (AWS access keys, GitHub tokens, generic `api_key = "..."` assignments, PEM private keys).

False positive rate is non-zero by design. Adjust the patterns in the script if your project legitimately writes one of these shapes.

## Wiring it into Claude Code

Hooks are opt-in. None of these fire automatically when you install `dk-agentic`. To enable `no-secrets` in a consumer repo, add to that repo's `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "node ${CLAUDE_PLUGIN_ROOT}/hooks/validators/no-secrets.js"
          }
        ]
      }
    ]
  }
}
```

To enable it for every repo on your machine, put the same block in `~/.claude/settings.json` instead. To enable it for everyone who uses the `dk-agentic` plugin in a given repo, lift it into the SessionStart-cloned plugin's own configuration once you've decided that the false-positive cost is worth the safety floor.

## Why opt-in

A blocking hook is an experience choice. If the plugin enabled `no-secrets` automatically the first time someone installed it, they'd hit a refused write before they understood why, and the wiring would feel hostile. Better to make the snippet copy-pasteable and let people light it up deliberately.
