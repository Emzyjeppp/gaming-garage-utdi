---
name: ponytail-lean
description: Software engineering simplicity principles to eliminate over-engineering, prioritize standard libraries, and enforce YAGNI.
---

# Ponytail Lean

This skill establishes a minimal, practical mindset in code implementation: solving problems with the simplest workable solution without speculative abstractions.

## Core Tenets

1. **YAGNI (You Aren't Gonna Need It)**: Do not write code or architectural abstractions for unrequested, hypothetical future requirements.
2. **Standard Library First**: Prioritize runtime standard library functions before reaching for third-party packages.
3. **Platform First**: Utilize native browser features, semantic HTML5, modern CSS, and database engines before adding custom JavaScript layers.
4. **Avoid Premature Abstraction**: Do not build factories, wrapper classes, or generic interfaces for single concrete implementations.

## Solution Decision Ladder

Before writing new code or installing a package, evaluate these seven tiers in order:

1. **Relevance**: Is this capability explicitly requested or essential for core function? If not, eliminate it.
2. **Reuse**: Are there existing helpers, components, or types in the repository that fulfill this?
3. **Standard Library**: Can this be solved using runtime built-ins (e.g., `fetch`, `URL`, `crypto`, `Intl`)?
4. **Platform Capabilities**: Can native HTML/CSS features resolve this (e.g., `<dialog>`, `<details>`, CSS Grid, Flexbox, native form validation)?
5. **Installed Packages**: If an external library is required, use packages already present in `package.json`.
6. **Concise Custom Code**: Write a small, clear function (10-30 lines) focused on the specific task instead of adding a large package.
7. **New External Dependency**: Add a new dependency only when manual implementation incurs disproportionate security or complexity risks.

## Anti-Overengineering Practices

- Avoid scattering code across dozens of micro-files when a cohesive, readable single file suffices.
- Avoid introducing complex state management libraries when localized state or simple prop passing solves the problem.
- Prioritize code clarity; minimal code does not mean dense one-liners that harm maintainability.
- Leave `// TODO:` markers only for deliberate, documented technical deferrals with defined constraints.
