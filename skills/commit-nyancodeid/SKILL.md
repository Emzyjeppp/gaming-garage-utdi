---
name: commit-nyancodeid
description: Standardized Git commit message guidelines based on nyancodeid conventions with consistent types, scopes, subjects, and change descriptions.
---

# Commit Nyancodeid

This skill guides the construction of clear, concise Git commit messages adhering to semantic commit conventions adapted from nyancodeid guidelines.

## Commit Message Structure

A commit message consists of three parts: header (mandatory), body (optional), and footer (optional).

```text
<type>(<scope>): <subject>

<body>

<footer>
```

## Commit Types

| Type | Description and Usage |
|---|---|
| `feat` | Adds a new user-facing feature. |
| `fix` | Fixes a bug or software defect. |
| `refactor` | Code refactoring that neither fixes a bug nor adds a feature. |
| `perf` | Code changes aimed at improving execution performance. |
| `style` | Formatting, whitespace, semicolon adjustments (no logic alterations). |
| `test` | Adding or updating test suites. |
| `docs` | Documentation additions or updates. |
| `build` | Changes affecting build tooling or external dependencies. |
| `ci` | Modifications to CI/CD workflows and configuration scripts. |

## Writing Rules

1. **Header (First Line)**
   - Format: `<type>(<scope>): <subject>`
   - `scope`: Optional, indicates the affected module (e.g., `auth`, `ui`, `api`, `config`, `cart`).
   - `subject`: Use imperative mood, lowercase initial letter, no trailing period.
   - Limit header line to 100 characters maximum.

2. **Body (Detailed Description)**
   - Separate from the header with a single blank line.
   - Explain the motivation for the change and the contrast with previous behavior.
   - Limit body lines to 100 characters maximum.

3. **Footer (Breaking Changes & References)**
   - Use `BREAKING CHANGE:` followed by a space or newline for backward-incompatible modifications.
   - Include issue tracker references where applicable (e.g., `Closes #123`).

## Commit Message Examples

### Simple Commits
```text
feat(ui): add confirmation modal dialog component
fix(cart): correct percentage discount coupon calculation
docs(readme): add installation guide and environment variables
```

### Commit with Body and Breaking Change
```text
feat(api): update transaction endpoint response structure

wrap array payload inside pagination metadata and total summaries.

BREAKING CHANGE: response data is now structured under { items, meta }
```

### Revert Commit
```text
revert: feat(ui): add confirmation modal dialog component

This reverts commit 7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b.
```
