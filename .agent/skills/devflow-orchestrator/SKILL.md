---
name: devflow-orchestrator
description: Orchestrator for an 8-phase software development lifecycle from requirements specification (PRD) to production release.
---

# DevFlow Orchestrator

This skill orchestrates software development tasks in a structured sequence, ensuring essential engineering steps are covered while scaling process overhead according to task complexity.

## Task Scale Matrix

- **Small Scale (Copy / Styling)**: Identify target files, apply direct modifications, verify rendering, and document changes.
- **Medium Scale (Single Feature)**: Define props/data contracts, implement logic, integrate components, and test end-to-end user flows.
- **Full Scale (New Application / Multi-Feature)**: Execute the complete 8-phase workflow sequentially.

## 8-Phase Development Workflow

### Phase 1: Requirements and PRD
- Define product objectives, target user personas, technical boundaries, and primary features.
- Create a concise specification document (`PRD.md`) for medium-to-large initiatives.

### Phase 2: Project Foundation
- Establish directory structure and configure project tooling (TypeScript, linters, formatters, build systems).
- Ensure the project runs locally using standard commands (e.g., `npm run dev`).

### Phase 3: Data and Architecture
- Design database schemas, entity relationships, and data models.
- Prepare migration scripts and enforce data integrity validation.

### Phase 4: Services and APIs
- Build backend services, REST/RPC endpoints, and authentication/authorization middleware.
- Enforce strict input validation on all endpoints to prevent malformed data.

### Phase 5: Frontend and User Interface
- Implement UI components, page routing, and state management connected to backend APIs.
- Provide comprehensive UI states: loading, empty dataset, error alerts, and success states.

### Phase 6: Testing
- Validate critical user flows (happy paths and failure edge cases).
- Run automated tests or structured manual verifications and record findings.

### Phase 7: Application Hardening
- Audit security vectors (input sanitization, environment variable protection, secret leaks).
- Optimize bundle size, asset loading, caching, and SEO readiness where applicable.

### Phase 8: Release and Handover
- Execute the production build command (`npm run build`) to ensure zero compilation errors.
- Document deployment procedures and required environment variables in `README.md`.

## Project Progress Tracking

For projects requiring sustained progress tracking, update these companion documents:
- `PROGRESS.md`: Phase status and completed/pending task checklists.
- `CHANGELOG.md`: Semantic version changelog entries.
