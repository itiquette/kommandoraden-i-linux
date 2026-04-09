# Releasing

## Svenska

Det här publika arkivet fylls på från en privat källarbetsyta via CI.
Den privata källarbetsytan innehåller AsciiDoc-källan för översättningen.
Vi får enligt överenskommelse med upphovsrättsinnehavaren bara distribuera genererade HTML- och PDF-utgåvor — se [`PERMISSIONS.md`](PERMISSIONS.md).
Filerna på `main`-grenen i det här arkivet underhålls direkt här.

### Publicering

CI i den privata källarbetsytan force-uppdaterar `pages`-grenen i det här arkivet och publicerar PDF:en som release-artefakt.
`.github/workflows/pages.yml` i det här arkivet kör integritets- och pa11y-kontroller på `pages`-grenen och deployar sedan till GitHub Pages.

Förutsättning på det här arkivet: Settings > Pages > Source = **GitHub Actions**.

Detaljer om det privata bygg- och exportflödet, inklusive vilka secrets och PAT-rättigheter som krävs där, finns i README:n i det privata källarkivet.

## English

This public repo is populated from a private source workspace via CI.
The private source workspace holds the AsciiDoc translation source.
Per agreement with the copyright holder we may only distribute generated HTML and PDF editions — see [`PERMISSIONS.md`](PERMISSIONS.md).
The `main` branch files in this repo are maintained directly here.

### Publishing

CI in the private source workspace force-refreshes the `pages` branch of this repo with sanitized, JS-free HTML and publishes the PDF as a release asset.
`.github/workflows/pages.yml` in this repo runs integrity and pa11y gates on the `pages` branch and then deploys to GitHub Pages.

Requirement on this repo: Settings > Pages > Source = **GitHub Actions**.

Details about the private build and export flow, including the secrets and PAT permissions required there, live in the README of the private source repo.
