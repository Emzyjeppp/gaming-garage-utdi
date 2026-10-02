# Gaming Garage UTDI

Official web landing page for the Gaming Garage laboratory ecosystem at Universitas Teknologi Digital Indonesia (UTDI), developed in partnership with HP Inc. under the Faculty of Information Technology (FTI).

## Original Source & Attribution

- **Original Template**: Cinematic VFX 28
- **Source URL**: [https://www.aura.build/templates/cinematic-vfx-28](https://www.aura.build/templates/cinematic-vfx-28)
- **Adaptation & Customization**: Redesigned and refactored into a modular frontend architecture featuring the official Valorant Agent color palette, structured tournament modules, curriculum academy details, and institutional co-branding.

## Key Features

- **Responsive Modular Architecture**: Clean separation between semantic HTML, custom stylesheet (`css/styles.css`), and modular JavaScript interactions (`js/main.js`).
- **Valorant Agent Color Palette**: Themed with official dark slate (`#0F1923`), pitch dark (`#0B1015`), radiant coral-red (`#FF4655`), ice cyan (`#4BE8FF`), tactical gold (`#B59A57`), and electric purple (`#8055FF`).
- **Interactive 3D Flip Cards**: Symmetrical tournament grid for Mobile Legends, Tekken 8, eFootball/PES, and Valorant with hardware specs and rules on card flip.
- **Flex Accordion Curriculum**: Interactive expanding modules highlighting Game Developer Academy, Esports Management, and HP Global Certification.
- **Visual Effects**: Custom CSS glitch text loader, running marquee banner, diagonal wipe hover transitions, and glassmorphism panels.

## Project Structure

```text
Gaming Garage UTDI/
|-- .gitignore                  # Environment and artifact exclusions
|-- README.md                   # Project documentation and attribution
|-- index.html                  # Main production landing page
|-- generated-page.html         # Synced preview page
|-- About.txt                   # Source data and institutional facts
|-- css/
|   `-- styles.css              # Custom animations, 3D transforms, and theme styling
|-- js/
|   `-- main.js                 # Loader logic, drawer navigation, and event listeners
|-- skills/                     # Project skills and engineering guidelines
`-- .agent/                     # Assistant rules and skill definitions
```

## Getting Started

1. Clone or download the repository.
2. Open `index.html` directly in any modern web browser or serve via a local web server (e.g. Live Server on port 5500).

```bash
# Using Python built-in server
python -m http.server 5500

# Or open index.html directly
start index.html
```

## Credits & License

- **Institutions**: Fakultas Teknologi Informasi (FTI) UTDI & HP Inc.
- **Design Inspiration**: [Aura Build (Cinematic VFX 28)](https://www.aura.build/templates/cinematic-vfx-28)
- **Asset Sources**: Riot Games / Valorant media kit, Lucide icons, and Google Fonts.
