---
name: commit-conv
description: Compose Conventional Commits messages from a diff. Focuses the body on why the change was made, not a line-by-line restatement of what changed.
model: haiku
---

# Commit message helper (Conventional Commits)

Use this skill when the user wants a commit message written from a staged or unstaged diff.

## Format

```
type(scope): subject

Body explaining *why* the change was needed.
Multiple paragraphs OK.

BREAKING CHANGE: <only if applicable>
```

## Rules

- `type` is one of: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `build`, `ci`, `style`, `revert`.
- `scope` is optional. Use a folder name, component name, or feature area. Lowercase. Skip if it would be vague.
- Subject line: imperative mood ("add X", not "added X"), under 72 characters, no trailing period.
- Body: wrap at ~72 chars, blank line after the subject. Explain motivation, not mechanics. The diff already shows the mechanics.
- If the diff spans unrelated concerns, ask the user whether to split before composing.

## Anti-patterns to avoid

- "Updated files." Too vague to be useful.
- Restating the diff in prose ("Changed line 42 to call foo() instead of bar()"). The reader has the diff.
- Mentioning the AI assistant or the tool used to write the commit.
- Marketing language ("improved", "enhanced", "optimized") without saying what got better and how you'd measure it.

## Procedure

1. Inspect the diff: `git diff --staged` if anything is staged, otherwise `git diff`.
2. Identify the dominant intent. If multiple intents, surface that to the user before continuing.
3. Pick a `type` and (optionally) `scope` from the change's scope of impact.
4. Draft the subject line. Keep it under 72 characters.
5. Draft the body. Lead with the *why*. If the change is a fix, name the symptom and root cause briefly.
6. Show the user the message before committing. Wait for approval.
