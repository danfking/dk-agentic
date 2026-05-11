# Validators

Block unsafe actions before they happen. Exit 2 to refuse with a reason on stderr; exit 0 to allow. See `../README.md` for the full contract.

Currently shipping:

| Script           | Fires on                | What it blocks                                                 |
|------------------|-------------------------|----------------------------------------------------------------|
| `no-secrets.js`  | PreToolUse Write/Edit   | Sensitive file names, AWS/GitHub/Slack/Google tokens, PEM keys |
