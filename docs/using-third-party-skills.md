# Using third-party skills

A lot of the highest-leverage skills I use were written by other people. This doc is the recipe for pulling them in cleanly: keeping attribution, pinning to a known-good version, and not surprising future-me when an upstream change breaks something.

## Three options, in order of preference

### 1. Vendor into this plugin's `skills/` folder (preferred)

Copy the skill folder verbatim into `dk-agentic/skills/<skill-name>/`. Add a `NOTICE.md` next to the `SKILL.md` recording:

- Original author
- Source URL
- Commit hash pinned at the time of copy
- License
- Date copied

Worked example: `skills/grill-me/`. The `NOTICE.md` there is the template.

**Pros:** offline-safe, works for everyone who clones `dk-agentic`, no extra network hops on session start, version is frozen until I deliberately update.

**Cons:** I have to remember to refresh it. Upstream improvements don't reach me automatically.

**License check:** the upstream skill's license must permit redistribution. MIT, Apache-2.0, BSD, and most CC variants are fine with attribution. AGPL or "no commercial use" terms need a closer read.

### 2. Drop into the per-user `~/.claude/skills/` folder

If a skill is something only I want, not something I'd ship in `dk-agentic` for others, put it in `~/.claude/skills/<skill-name>/`. Claude Code picks it up automatically across all sessions.

**When to use:** experimental skills, skills with non-redistributable content (private prompts, customer-specific context), or skills that are useful only because they reference my local file paths.

### 3. Chain a second `SessionStart` hook to clone an upstream repo

If I want a whole external skill collection (like `mattpocock/skills`) auto-cloned alongside `dk-agentic`, add a second hook to the consumer repo's `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c \"test -d .claude-plugins/dk-agentic || git clone https://github.com/danfking/dk-agentic.git .claude-plugins/dk-agentic\"",
            "timeout": 30000
          },
          {
            "type": "command",
            "command": "bash -c \"test -d .claude-plugins/mattpocock-skills || git clone https://github.com/mattpocock/skills.git .claude-plugins/mattpocock-skills\"",
            "timeout": 30000
          }
        ]
      }
    ]
  }
}
```

Then load both: `claude --plugin-dir .claude-plugins/dk-agentic --plugin-dir .claude-plugins/mattpocock-skills`.

**When to use:** the upstream collection is large, frequently updated, and I want all of it. Less common in practice, since I usually only want a handful of specific skills.

## Skills people I like

A running list of authors whose work I follow and vendor from. Not exhaustive; grows as I find more.

| Author        | Repo                                                                  | What I take                                          |
|---------------|-----------------------------------------------------------------------|------------------------------------------------------|
| Matt Pocock   | [mattpocock/skills](https://github.com/mattpocock/skills)             | `grill-me` so far. The whole `productivity/` set is worth a browse. |

Adding to this list when I vendor something. Drop me an issue if you have an author worth pointing at.
