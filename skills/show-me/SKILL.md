---
name: show-me
description: Render visual/design work as a self-contained comparison page (before/after screenshot grid, or an options matrix on a live mini-mock of the real UI) with the exact values to apply. Use for "show me", "show me the options", "compare these", "which looks better", "before/after", "let me see the difference", or any design choice needing a visual. NOT for doing the redesign (premium-landing-design).
---

# Show Me

Visual decision-makers decide fastest when he can see and compare, not read prose. When a change has been made, or a set of directions needs picking, do not describe it in text - render it as a self-contained visual comparison page. Built from real design-review sessions (before/after feed cards, before/after brand color, the 5-palette options matrix).

Core rule: **every visual decision gets a page that shows the real thing in context, carries the exact values to enact each option, and ends with "tell me which and I apply it."**

## Two modes - pick by the question

**Mode A - Before / After** (a change already made or proposed):
- Two-column grid, right = before, left = after (or top/bottom on narrow). Real screenshots of the actual UI, captured headless.
- Label each side with what it is + the one value that changed (e.g. "קרם #F8F4F0" → "אינדיגו #4F46E5").
- One line above stating the delta in plain words.

**Mode B - Options matrix** (a decision between N directions):
- Each option rendered as a **live mini-mock of the REAL target surface** - not abstract swatches. Recreate the actual component (post card, nav tab, button, sidebar) as a small self-contained block, then instantiate it once per option driven by CSS variables.
- Each option carries: a name (Hebrew + English), a "fit" tag, a one-line rationale, and the **exact config to apply** (the JSON/values, copy-pasteable).
- Mark 1-2 recommendations and say why. Offer that options can be mixed.

The mini-mock-in-context is the whole point. Swatches alone fail - a color/font/spacing choice only reads once it is on the thing it will live on. See `references/recipes.md` for the `<template>` + JS-loop technique that renders N in-context mocks DRY.

## Delivery - Artifact vs local HTML

- **Artifact** (hosted, shareable, rendered on claude.ai): use when the page is fully self-contained - pure CSS/Canvas mocks, NO external or local images. The Artifact CSP blocks external hosts and local file paths, so screenshots load only when published with the page (the Artifact tool's `files` param) or inlined as data: URIs. Best for Mode B option matrices (CSS-driven mocks). Load the artifact-design skill first per its own instructions.
- **Local HTML + `open`**: use when the page references local screenshot PNGs (Mode A before/after almost always does). Write to the scratchpad dir, reference the PNGs by relative filename (keep HTML and PNGs in the same folder), then `open` it. This is how the before/after grids shipped.

Decision: has screenshots → local HTML + open. Pure CSS mocks → Artifact.

## Capturing the screenshots (Mode A)

Full recipe in `references/recipes.md`. Key points:
- Drive a real logged-in state when the surface is behind auth (mint a magic-link token or use saved test creds; dismiss blocking modals first).
- Scroll the page in viewport steps BEFORE capturing, or IntersectionObserver-revealed sections shoot empty.
- `clip` to the region that shows the change; save PNGs to the scratchpad, never the repo root.
- Capture the before FIRST (before editing) - it cannot be recreated after the change lands.

## Always close with action

The page exists to decide. It must carry the exact enact-config for each option (the `brandColors` JSON, the font values, the class change) and the reply must end with a one-line "tell me a number / which one, and I apply it + show the real result." A comparison the user cannot act on wastes the trip.

## Craft (inherit from artifact-design)

Keep the page chrome neutral so the content pops; the options/screenshots are the color, not the frame. RTL + Hebrew labels for Hebrew/RTL surfaces (hex codes stay LTR, `dir="ltr"` + `tabular-nums` on code/numbers). Balance headings, ~65ch text, real content never lorem. One page, no horizontal body scroll (wide mocks get their own `overflow-x:auto`).

## Reference

- `references/recipes.md` - copy-paste skeletons: the before/after grid, the options-matrix `<template>`+loop with CSS-var mocks, and the playwright screenshot-capture snippet with the scroll-for-reveals and login gotchas.
