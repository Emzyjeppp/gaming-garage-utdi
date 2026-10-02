# Channel-Specific Writing Guidance

Tone, length, and detail should be tailored to the medium and reader intent to communicate technical information effectively.

## 1. User Interfaces (UI)

- **Button Labels**: Use specific imperative verbs (e.g., "Save", "Submit", "Update", "Delete").
- **Form Validation**: State the specific issue and immediate remedy directly (e.g., "Use at least 8 characters").
- **Status / Toast Notifications**: Summarize the outcome succinctly (e.g., "Profile settings updated").
- **Empty States**: Explain why data is missing and provide an immediate next action (e.g., "No transactions found. Create a new transaction to get started.").

## 2. Technical Documentation and Guides

- Structure instructions in chronological steps.
- Keep each step focused on a single actionable command or task.
- Provide self-contained code snippets that can be copied and executed directly.
- Document expected terminal outputs or visual feedback.

## 3. Architecture Decision Records (ADR) and Reports

- Begin with a concise context summary.
- Objectively present considered options along with practical trade-offs.
- State the chosen direction and the core rationale behind it.
- Outline known constraints and future mitigation paths.

## 4. Commit Messages and Code Comments

- Explain *why* a change was made rather than reiterating *what* the syntax does.
- Maintain strict semantic commit type conventions.
