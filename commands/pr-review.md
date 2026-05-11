---
description: Review a GitHub PR and post a structured review with inline comments.
model: sonnet
argument-hint: [pr-number-or-url]
---

You are reviewing a pull request on GitHub. Argument: $ARGUMENTS (a PR number, URL, or empty for the current branch's PR).

Steps:

1. Resolve the PR. If $ARGUMENTS is a number, use `gh pr view <n> --json ...`. If it's empty, use `gh pr view --json ...` for the current branch. If it's a URL, parse the number from it.
2. Fetch the diff: `gh pr diff <n>`. Read the description and any existing review comments via `gh pr view <n> --json title,body,reviews,comments`.
3. Read the changed files in their full context (not just the diff hunks). The diff shows what changed; the surrounding code shows whether the change is right.
4. Evaluate against this checklist:
   - Does the change do what the PR description says it does?
   - Are there obvious bugs, off-by-ones, or unhandled edge cases?
   - Are there security concerns: input validation, secret handling, injection vectors?
   - Does the code add complexity that the change doesn't need (premature abstractions, dead config, defensive code for impossible states)?
   - Are there missing tests for non-trivial logic, or tests that no longer assert anything meaningful?
   - Does it match the surrounding style and conventions in the repo?
5. Produce a structured review:
   - Summary: 2-3 sentences on what the PR does and the overall assessment.
   - Blocking issues: numbered list, each with file:line references and a suggested fix.
   - Non-blocking suggestions: numbered list, each with file:line references.
   - Questions: anything you genuinely don't understand and need the author to clarify.
6. Show me the review locally first. Only post it to GitHub (`gh pr review <n> --comment --body ...`) if I confirm.

Be direct. If a change is good, say so plainly. Don't pad the review with manufactured concerns.
