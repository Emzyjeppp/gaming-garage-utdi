---
name: impeccable-design
description: Frontend design guidance and anti-pattern elimination based on Impeccable to prevent generic AI UI clichés, overused fonts, and nested card layouts.
---

# Impeccable Design

This skill eliminates predictable AI frontend generation patterns and elevates web interfaces into distinctive, intentional designs.

## AI Frontend Anti-Patterns to Eliminate

AI models consistently generate identical visual tropes unless explicitly guided. Avoid these defaults:

1. **Overused Typography**: Avoid defaulting to Inter, Roboto, Arial, or generic system sans for every project without brand rationale.
2. **Cliché Gradients**: Stop using generic purple-to-blue or neon violet background gradients.
3. **Nested Card Hell**: Do not wrap every section in a card, and never nest cards inside cards. Use negative space, subtle borders, or background tint shifts to separate content.
4. **Low-Contrast Gray on Colors**: Never place light gray text on vibrant or colored backgrounds. Ensure strict WCAG AA contrast.
5. **Pure Black/White**: Avoid `#000000` and flat `#808080`. Always use subtly tinted darks (e.g. slate, zinc with a hint of blue or warm stone).
6. **Dated Easing**: Avoid springy or bouncy easing curves; use clean cubic beziers for purposeful, subtle transitions.

For a comprehensive catalog of design anti-patterns, see [references/anti-patterns.md](file:///C:/Users/jefry/Downloads/devflow-rules/skills/impeccable-design/references/anti-patterns.md).

## Durable Product and Design Truth

When establishing a new interface or redesigning an existing surface:

1. **`PRODUCT.md`**: Record the target audience, user intent, functional constraints, tone of voice, and core workflows before writing CSS.
2. **`DESIGN.md`**: Document the visual system, typographic scale, color tokens, surface hierarchy, and component contracts.

## Design Modification Commands & Actions

Apply these focused adjustments when refining interfaces:

- **Critique**: Review layout for visual hierarchy, semantic grouping, and clarity.
- **Distill**: Strip unnecessary visual clutter, decorative wrappers, and extraneous dividers.
- **Bolder**: Increase typographic contrast, scale up key metrics, and sharpen visual rhythm.
- **Quieter**: Soften high-contrast borders, reduce font weights, and expand whitespace.
- **Harden**: Add edge-case handling for long text truncation, dynamic empty states, and viewport resizing.
- **Polish**: Align border radiuses, standardize spacing tokens, and verify interaction states (hover, focus, active).

## Quick Verification Checklist

- [ ] Typography fits the product personality rather than generic defaults.
- [ ] Content uses open layouts, rhythm, and spacing instead of endless nested card boxes.
- [ ] All text colors maintain accessible contrast against their background surfaces.
- [ ] Animations are subtle, purposeful, and respect reduced motion preferences.
