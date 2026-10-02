# Frontend Design Anti-Patterns Reference

This reference catalogs common visual tropes produced by LLMs and provides direct architectural remedies.

## 1. Typography

- **Anti-Pattern**: Defaulting to Inter or system sans-serif for every project regardless of brand context.
- **Remedy**: Select fonts that reflect product character (e.g. Plus Jakarta Sans, Outfit, Fraunces, JetBrains Mono, Syne, Instrument Serif) or match the existing brand design system.

## 2. Structural Composition

- **Anti-Pattern**: Wrapping every piece of information inside a rounded card, leading to "card-in-card" nesting.
- **Remedy**: Use open layouts, varying background surface tones, typographic hierarchy, and whitespace grids to separate sections naturally.

## 3. Color and Contrast

- **Anti-Pattern**: Flat purple-to-cyan gradient blobs and low-contrast muted gray text on colored backgrounds.
- **Remedy**: Use intentional, restrained color palettes with high-contrast text tokens meeting WCAG AA standards (4.5:1 ratio for normal text).
- **Anti-Pattern**: Pitch black (`#000000`) on harsh white (`#ffffff`).
- **Remedy**: Use tinted dark neutrals (e.g., slate `#020617`, zinc `#09090b`) to create rich, balanced depth.

## 4. Iconography & Badges

- **Anti-Pattern**: Placing a rounded-square colored icon tile above every single heading.
- **Remedy**: Integrate icons contextually next to action triggers, or rely on clear headings and semantic labels.

## 5. Motion and Animation

- **Anti-Pattern**: Exaggerated bounce, elastic overshoot, or slow floating animations.
- **Remedy**: Use crisp, fast easing curves (150ms-250ms) with `cubic-bezier(0.16, 1, 0.3, 1)` or linear fades to reinforce state changes.
