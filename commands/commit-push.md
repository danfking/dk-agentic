---
description: Stage changes, write a Conventional Commits message, and push.
model: haiku
---

You are helping me commit and push the current changes.

Steps:

1. Run `git status` and `git diff --stat HEAD` (and `git diff` for files under ~200 lines) to understand what changed and why.
2. Group the changes by intent. If they span unrelated concerns, ask whether to split into multiple commits before staging.
3. Compose a Conventional Commits message:
   - First line: `type(scope): subject` in lowercase, under 72 characters. `type` is one of `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `build`, `ci`, `style`, `revert`. `scope` is optional and matches a folder or component name.
   - Blank line, then a body that explains *why* the change was needed, not what changed line-by-line.
   - If the change is breaking, add a `BREAKING CHANGE:` footer.
4. Show me the proposed message and the file list. Wait for approval unless I told you to skip confirmation.
5. Stage the specific files (no `git add -A` unless I asked for it). Commit. Push to the current branch's upstream, or set upstream if missing.

Do not skip git hooks. If a pre-commit hook fails, fix the underlying issue and create a new commit. Never use `--amend` or `--no-verify` without me asking.
