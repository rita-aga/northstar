# [Project] Styling Guide

> Visual language, design principles, and UI/UX guidelines.

---

## Design Philosophy

[Describe the overall aesthetic and feeling of the project. What emotions should the interface evoke? What design traditions or movements inspire it?]

**Key words:** [e.g., calm, bold, playful, premium, minimal, expressive]

---

## Core Principles

### 1. [Principle Name]
[Describe the first core principle. E.g., "Borderless Design" — no bold outlines, use transparency for hierarchy]

### 2. [Principle Name]
[Second principle. E.g., "Transparency Over Solidity" — light and airy through opacity, not white]

### 3. [Principle Name]
[Third principle. E.g., "Minimal Color Palette" — 2-3 accents max, rest is base tones]

### 4. [Principle Name]
[Fourth principle. E.g., "Editorial Layouts" — magazine-inspired typography and spacing]

---

## Constraints (DO NOT)

### Forbidden Patterns
- ❌ [Pattern to avoid — e.g., "Generic component libraries (shadcn, etc.)"]
- ❌ [Pattern to avoid — e.g., "Bold borders on buttons/inputs"]
- ❌ [Pattern to avoid — e.g., "Muddy or earthy tones"]
- ❌ [Pattern to avoid — e.g., "Heavy drop shadows"]
- ❌ [Pattern to avoid — e.g., "Cluttered layouts"]

### Avoid
- [Thing to generally avoid]
- [Thing to generally avoid]

---

## Color Palette

### Primary Accent
```
[Accent Color Name]
- Primary:    #[HEX]
- Hover:      #[HEX]
- Subtle:     #[HEX]20 (20% opacity)
- Glow:       #[HEX]40 (40% opacity for glows)
```

### Secondary Accent (if applicable)
```
[Secondary Color Name]
- Primary:    #[HEX]
- Hover:      #[HEX]
```

### Base Colors

**Light Mode:**
```
- Background:     #[HEX]
- Surface:        #[HEX] with [X]% opacity
- Surface-alt:    #[HEX]
- Text-primary:   #[HEX]
- Text-secondary: #[HEX]
- Text-muted:     #[HEX]
```

**Dark Mode:**
```
- Background:     #[HEX]
- Surface:        #[HEX] with [X]% opacity
- Surface-alt:    #[HEX]
- Text-primary:   #[HEX]
- Text-secondary: #[HEX]
- Text-muted:     #[HEX]
```

### Usage Rules
- [When to use accent color]
- [When to use base colors]
- [Any color restrictions]

---

## Typography

### Font Stack
```css
/* Primary */
font-family: '[Font Name]', [fallbacks];

/* Mono (for code) */
font-family: '[Mono Font]', monospace;
```

### Scale
```
Display:    [size]px
H1:         [size]px
H2:         [size]px
H3:         [size]px
Body:       [size]px
Caption:    [size]px
```

### Guidelines
- [Typography guideline]
- [Typography guideline]

---

## Components

### Cards & Surfaces
```css
/* Example card style */
.surface {
  background: [value];
  backdrop-filter: [blur amount];
  border: [border style or none];
  border-radius: [radius];
  box-shadow: [shadow];
}
```

### Buttons
```css
/* Primary button */
.button-primary {
  background: [value];
  color: [value];
  border: [value];
  border-radius: [value];
  /* ... */
}

/* Ghost/secondary button */
.button-ghost {
  /* ... */
}
```

### Inputs
```css
/* Input style */
.input {
  background: [value];
  border: [value];
  border-radius: [value];
  /* ... */
}
```

---

## Motion & Animation

### Principles
1. [Motion principle — e.g., "Purposeful motion — every animation serves UX"]
2. [Motion principle — e.g., "Spatial continuity — transitions show context"]
3. [Motion principle — e.g., "Micro-interactions — subtle feedback"]

### Timing
```css
--transition-fast: [X]ms ease;
--transition-normal: [X]ms ease;
--transition-slow: [X]ms ease-out;
```

### Allowed Animations
- [Allowed animation type]
- [Allowed animation type]
- [Allowed animation type]

### Forbidden
- ❌ [Animation to avoid]
- ❌ [Animation to avoid]

---

## Layout Patterns

### [Layout Pattern Name]
[Description of when and how to use this layout]

### [Layout Pattern Name]
[Description]

---

## Dark/Light Mode

### Light Mode
- [Light mode characteristics]

### Dark Mode
- [Dark mode characteristics]

### Switching
- [How mode switching should work]

---

## Inspirations & References

### Aesthetic References
- **[Reference Name]** — [What to take from it]
- **[Reference Name]** — [What to take from it]

### 2026 Trends to Consider
Based on current UI/UX research:

- **Liquid Glass** — translucent, fluid surfaces with depth
- **Micro-movements** — breathing elements, cursor proximity reactions
- **Scroll storytelling** — content unfolds as narrative
- **Glassmorphism** — frosted-glass effects with subtle layering
- **Spatial continuity** — transitions maintain sense of place
- **Bento Grid** — modular blocks of varying sizes

### What Sets [Project] Apart
- [Differentiator]
- [Differentiator]
- [Differentiator]

---

## Implementation Notes

### CSS Variables
```css
:root {
  /* Colors */
  --color-accent: #[HEX];
  --color-accent-hover: #[HEX];
  --color-background: #[HEX];
  --color-surface: [value];
  --color-text: #[HEX];
  --color-text-muted: #[HEX];

  /* Spacing */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 48px;

  /* Radii */
  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-xl: 24px;

  /* Transitions */
  --transition-fast: 150ms ease;
  --transition-normal: 200ms ease;
}

[data-theme="dark"] {
  /* Dark mode overrides */
}
```

### Tech Recommendations
- **CSS** — [Framework or approach]
- **Animations** — [Library recommendation]
- **Icons** — [Icon set]
- **Charts** — [Charting library if applicable]

---

*[Summary statement about how the interface should feel]*
