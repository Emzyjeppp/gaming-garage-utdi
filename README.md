# Gaming Garage UTDI

Official web landing page for the Gaming Garage laboratory ecosystem at Universitas Teknologi Digital Indonesia (UTDI), developed through a strategic partnership between the Faculty of Information Technology (FTI) and HP Inc.

## Live Demo

- **Production URL**: [https://jeppp.is-a.dev/gaming-garage-utdi/](https://jeppp.is-a.dev/gaming-garage-utdi/)
- **Fallback URL**: [https://emzyjeppp.github.io/gaming-garage-utdi/](https://emzyjeppp.github.io/gaming-garage-utdi/)

## Original Source & Attribution

- **Original Template**: Cinematic VFX 28
- **Source URL**: [https://www.aura.build/templates/cinematic-vfx-28](https://www.aura.build/templates/cinematic-vfx-28)
- **Adaptation & Customization**: Redesigned and refactored from a monolithic template into a clean, modular frontend architecture. Styled with the official Valorant Agent color palette, structured tournament modules, and institutional co-branding for UTDI and HP Inc.

## Design & Color Tokens (Valorant Agent Palette)

| Token Name | Hex Code | Purpose & Usage |
|---|---|---|
| Dark Slate | `#0F1923` | Main body background |
| Pitch Dark | `#0B1015` | Section footers and loader background |
| Card Surface | `#141C24` | Surface background for modules and cards |
| Light Off-White | `#ECE8E1` | Primary text and headings |
| Tactical Gray | `#768079` | Secondary text, borders, and metadata |
| Radiant Coral-Red | `#FF4655` | Primary CTA buttons, badges, and active glowing states |
| Deep Wine | `#53212B` | Ambient radial gradients and dark badge fills |
| Ice Cyan | `#4BE8FF` | Jett/Yoru fighting tournament accents |
| Tactical Gold | `#B59A57` | Cypher sports tournament accents |
| Electric Purple | `#8055FF` | Reyna tactical FPS accents |

## Key Features

- **Clean Modular Frontend**: Separated into semantic markup (`index.html`), custom CSS animation engine (`css/styles.css`), and modular JavaScript interactions (`js/main.js`).
- **3D Flip Tournament Cards**: Responsive 4-column grid featuring Mobile Legends, Tekken 8, eFootball/PES, and Valorant with hardware specs, rules, and registration links on flip.
- **Flex Accordion Curriculum**: Interactive expanding modules for Game Developer Academy, Esports Management, and HP Global Certification.
- **Open Recruitment Showcase**: 4-division community structure for competitive players, game developers, social media managers, and event organizers.
- **Performance Optimizations**: Removed unused font requests, eliminated inline JavaScript handlers, and enabled responsive viewport scaling.

## Project Structure

```text
gaming-garage-utdi/
|-- .gitignore          # Environment variables and local cache exclusions
|-- README.md           # Documentation, live demo, and source attribution
|-- index.html          # Production semantic landing page
|-- css/
|   `-- styles.css      # Core stylesheet, animations, 3D transforms, and theme tokens
`-- js/
    `-- main.js         # Loader lifecycle, drawer navigation, and UI event handlers
```

## Local Development

Open `index.html` directly in your browser or run a local static server:

```bash
# Using Python
python -m http.server 5500

# Using Node.js (npx)
npx serve .

# Or open directly on Windows
start index.html
```

## Credits & Links

- **Official Instagram**: [@gaminggarage.utdi](https://www.instagram.com/gaminggarage.utdi/)
- **Institutions**: Fakultas Teknologi Informasi (FTI) UTDI & HP Inc.
- **Original Template**: [Aura Build (Cinematic VFX 28)](https://www.aura.build/templates/cinematic-vfx-28)
- **Visual Assets**: Riot Games / Valorant media kit, Lucide icons, and Google Fonts.
