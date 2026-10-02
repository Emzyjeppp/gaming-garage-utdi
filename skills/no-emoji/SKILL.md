---
name: no-emoji
description: Standards prohibiting emojis and decorative unicode symbols, with solutions using plain text, status badges, and inline SVG icons.
---

# No Emoji

This skill enforces strict rules against the use of emojis and decorative unicode characters across codebases, user interfaces, documentation, branch names, and commit messages.

## Scope of Restriction

Emojis and decorative symbols must not be used in:
1. **User Interfaces**: Headings, body text, form placeholders, badges, toasts, alerts, and empty states.
2. **Code and Attributes**: `alt`, `title`, `aria-label`, function names, variable identifiers, code comments, and terminal log outputs.
3. **Documentation and Repository**: README files, PR descriptions, commit messages, and filenames.

Characters such as unicode checkmarks, crosses, decorative stars, or symbol arrows are also prohibited when used as makeshift UI icons.

## Recommended Alternatives

| Visual Requirement | Applied Alternative |
|---|---|
| Navigation / Action icons | Inline SVG (`<svg>`) or project icon libraries (Lucide, Heroicons). See examples in [references/svg-icons.md](file:///C:/Users/jefry/Downloads/devflow-rules/skills/no-emoji/references/svg-icons.md). |
| Status indicators (success / error) | Text-based badges ("Success", "Failed", "Pending") with appropriate CSS styling. |
| Detail lists | Standard Markdown bullet points (`-`) or HTML `<ul>` / `<li>` elements. |
| Progress indicators | Descriptive status text ("Loading data...") or CSS animation spinners. |

## Exceptions

Emojis are permitted only under these specific conditions:
1. The user explicitly requests specific emojis.
2. The text displays raw, dynamic user-generated content from database storage.
3. Legacy files already employ emojis consistently and the current task is not style normalization.

## Verification

To check files in a Windows PowerShell environment:

```powershell
Select-String -Path .\path\to\file -Pattern '[\p{Cs}\u2190-\u27BF\u2B00-\u2BFF\uFE0F]'
```

Or using ripgrep:

```bash
rg -n '[\x{1F300}-\x{1FAFF}\x{2190}-\x{27BF}\x{2B00}-\x{2BFF}\x{FE0F}]' .
```
