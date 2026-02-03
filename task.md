Refactor the entire design system to a true AMOLED-first, fully monochromatic modern UI.

Core visual goals:

Prioritize pure black (#000000) for backgrounds wherever possible (AMOLED-friendly).

Remove washed-out dark grays. Replace them with:

Transparent blacks (e.g. rgba(0,0,0,0.6–0.9))

Deep near-blacks (e.g. #050505, #0A0A0A) only when separation is needed.

Eliminate unnecessary color accents. The system should be black, white, and grayscale only.

Foreground surfaces (cards, sheets, modals, bottom bars):

Use translucent black layers instead of solid gray blocks.

Prefer blur + transparency if supported.

Light mode requirements:

Keep it strictly monochrome (white, off-white, gray, black).

Avoid pure black text on pure white everywhere — introduce subtle contrast hierarchy.

Maintain parity with dark mode structure (same spacing, hierarchy, semantics).

Typography overhaul (very important):

Fix overuse of bold — everything should NOT be bold.

Apply a clear type hierarchy:

Headings: medium/bold only where emphasis is needed.

Body text: regular or light weight.

Secondary/meta text: lighter weight + slightly reduced opacity.

Introduce intentional letter spacing:

Uppercase labels → slightly increased tracking.

Body text → neutral, readable spacing.

Use italics only for semantic meaning (quotes, emphasis), not decoration.

Ensure consistent font sizes, line heights, and rhythm across screens.

Design system rules:

Define clear tokens for:

Backgrounds

Surface layers

Text hierarchy

Dividers and borders (subtle, low-contrast)

Reduce visual noise:

Remove unnecessary borders

Prefer spacing and contrast over lines

Make the UI feel sleek, minimal, modern, and intentional.

Outcome expected:

A full design refurbishment for both dark and light modes

Consistent AMOLED aesthetic

Cleaner hierarchy

More premium, modern, and calm UI

Do not add new colors or decorative styles.
Optimize for readability, contrast, and minimalism.