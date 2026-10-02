---
name: dealtech-ui
description: Guidance for selecting and adapting concrete UI components based on DealTech UI element, section, and page hierarchies.
---

# DealTech UI

This skill guides AI coding assistants in selecting, adapting, and integrating concrete web UI components without enforcing unwanted tech stack changes.

## Core Principles

1. **Component Hierarchy**: Structure UI into three distinct layers:
   - `elements/`: Standalone atomic components (Button, Input, Badge, Switch).
   - `sections/`: Composed layout blocks (Hero, Features, Pricing, Testimonials, Footer).
   - `pages/`: Full page compositions combining sections, elements, and routing.
2. **Adaptation Over Copy-Pasting**: Extract visual structure, layout patterns, and interaction models, then translate them cleanly into the target project stack and styling conventions.
3. **Behavioral Separation**: Maintain strict distinction between action triggers (`<button>`) and navigation links (`<a>`).

## Component Integration Workflow

1. **Analyze Interface Requirements**
   - Determine whether the task requires a single element, a layout section, or a full page structure.
   - Inspect the active project framework (React, Vue, Svelte, Blade, static HTML) and styling setup (Tailwind CSS, CSS Modules, vanilla CSS).

2. **Select Component Variant**
   - Choose the variant that closely matches business goals and data requirements.
   - Assess required external assets (icon libraries, animation packages, utility classes).

3. **Adapt and Refactor Code**
   - Align component names, prop types, and directory locations with the project architecture.
   - Replace placeholder text, brand logos, mock illustrations, and dummy links with real application data.
   - If the project uses Tailwind CSS and the reference uses custom CSS, convert selectors to standard Tailwind utility classes.

4. **Verify Accessibility and Responsiveness**
   - Ensure clear focus indicators on interactive elements.
   - Verify layout stability across mobile, tablet, and desktop viewports.
   - Ensure text contrast meets standard readability thresholds.

## Integration Checklist

- [ ] Sizing, color schemes, and states (default, hover, active, disabled) are implemented.
- [ ] Icon-only buttons contain descriptive `aria-label` attributes.
- [ ] Responsive containers prevent unintended horizontal scrollbars.
- [ ] All local asset imports and icon packages are validated and operational.
