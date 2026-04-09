# Releasing

This public repo is populated from the private source workspace.

The `main` branch files in this repo are maintained directly here. The private export script, or the CI pipeline that calls it, only refreshes the Pages output and stages the PDF release asset.

## Automated publishing (CI)

This is the normal path.

1. Push or merge to `main` in the private source repo `itiquette/the-linux-command-line-sv-private-source`.
2. `.github/workflows/publish.yml` there builds Swedish HTML + PDF, force-refreshes the `pages` branch of this repo with sanitized, JS-free HTML, and creates a dated release `build-YYYYMMDD-<7sha>` plus refreshes the rolling `latest` release with the PDF asset.
3. `.github/workflows/pages.yml` in this repo runs integrity and pa11y gates on the pushed `pages` content, then deploys to GitHub Pages.

Requirements:

- Secret `PUBLIC_REPO_TOKEN` in the private source repo: fine-grained PAT with `contents:write` on this repo.
- On this repo: Settings > Pages > Source = **GitHub Actions**.

PRs on the private source trigger `.github/workflows/pullrequest.yml`, which builds and uploads the sanitized HTML + PDF as a review artifact. No deploys or releases on PRs.

## First-time local setup

1. In this public repo, create the first local commit on `main`.
2. Turn `../kommandoraden-i-linux-pages-worktree` into a real `pages` branch worktree:

   ```bash
   ./scripts/init-pages-worktree.sh
   ```

3. In `../the-linux-command-line-sv-private-source`, run:

   ```bash
   ./scripts/export_public.sh
   ```

4. Review the refreshed Pages content in `../kommandoraden-i-linux-pages-worktree` and the staged PDF in `../the-linux-command-line-sv-private-source/out/public-release/`.

## Normal local update flow

1. Edit `README.md`, `PERMISSIONS.md`, `RELEASING.md`, helper scripts, and any other `main` branch files directly in this public repo as needed.
2. Work in `../the-linux-command-line-sv-private-source` for translation source changes.
3. Build Swedish outputs and export the public-safe files:

   ```bash
   ./scripts/export_public.sh
   ```

4. Review the refreshed files in:
   - `../kommandoraden-i-linux-pages-worktree`
   - `../the-linux-command-line-sv-private-source/out/public-release/kommandoraden-i-linux.pdf`
5. Commit any `main` branch changes in this public repo.
6. Commit the refreshed HTML on the `pages` branch.
7. Create or update a release in the public repo and upload `../the-linux-command-line-sv-private-source/out/public-release/kommandoraden-i-linux.pdf` as the PDF asset.
8. Publish or push later if desired.

## Publication openness checks

- Keep the public HTML edition static and JavaScript-free.
- Do not ship external runtime assets such as CDN-hosted stylesheets, scripts, or webfonts.
- Keep third-party notices up to date in [`THIRD_PARTY.md`](THIRD_PARTY.md) when publication assets change.

## Accessibility and standards checks

- Treat the public HTML edition as targeting `WCAG 2.2 AA`-level good practice.
- Keep the HTML edition keyboard-usable with visible focus states and a working skip link.
- Preserve reduced-motion support and avoid JavaScript-dependent interaction.
- Check zoom and reflow behavior on narrow screens and at high zoom.
- Keep link styling visible without depending on color alone.
- Review figure alt text and captions so they describe the content instead of falling back to filenames or placeholder text.
- Validate the generated HTML structure after export when making theme or source-markup changes, for example:

  ```bash
  xmllint --html --noout ../kommandoraden-i-linux-pages-worktree/index.html
  ```

- Run the automated accessibility check against the exported Pages output:

  ```bash
  ./scripts/check-pages-a11y.sh
  ```

- Perform periodic manual checks with a browser, keyboard-only navigation, and assistive technology when practical.

## Safety rule

Do not copy `book/`, `*.adoc`, translation notes, original inputs, or QA material into the public repo.

## Svenska

Det här publika arkivet fylls på från den privata källarbetsytan.

Filerna på `main`-grenen i det här arkivet underhålls direkt här. Det privata exportskriptet, eller CI-pipelinen som anropar det, uppdaterar bara Pages-utmatningen och förbereder PDF-artefakten.

### Automatisk publicering (CI)

Detta är normalflödet.

1. Pusha eller mergea till `main` i det privata källarkivet `itiquette/the-linux-command-line-sv-private-source`.
2. `.github/workflows/publish.yml` där bygger svensk HTML + PDF, force-uppdaterar `pages`-grenen i det här arkivet med saniterad JS-fri HTML, och skapar en daterad release `build-YYYYMMDD-<7sha>` samt uppdaterar den rullande `latest`-releasen med PDF-artefakten.
3. `.github/workflows/pages.yml` i det här arkivet kör integritets- och pa11y-kontroller på den pushade `pages`-grenen och deployar sedan till GitHub Pages.

Förutsättningar:

- Secret `PUBLIC_REPO_TOKEN` i det privata källarkivet: fine-grained PAT med `contents:write` på det här arkivet.
- I det här arkivet: Settings > Pages > Source = **GitHub Actions**.

PR:er i det privata källarkivet triggar `.github/workflows/pullrequest.yml`, som bygger och laddar upp saniterad HTML + PDF som en granskningsartefakt. Inga deployer eller releaser sker på PR.

### Första lokala uppsättningen

1. Skapa den första lokala incheckningen på `main` i det här publika arkivet.
2. Gör om `../kommandoraden-i-linux-pages-worktree` till en riktig worktree för `pages`-grenen:

   ```bash
   ./scripts/init-pages-worktree.sh
   ```

3. Kör följande i `../the-linux-command-line-sv-private-source`:

   ```bash
   ./scripts/export_public.sh
   ```

4. Granska den uppdaterade Pages-utmatningen i `../kommandoraden-i-linux-pages-worktree` och den förberedda PDF-filen i `../the-linux-command-line-sv-private-source/out/public-release/`.

### Normalt lokalt uppdateringsflöde

1. Redigera `README.md`, `PERMISSIONS.md`, `RELEASING.md`, hjälpskript och andra filer på `main`-grenen direkt i det här publika arkivet vid behov.
2. Arbeta i `../the-linux-command-line-sv-private-source` för ändringar i översättningskällan.
3. Bygg de svenska utgåvorna och exportera de filer som är säkra att publicera:

   ```bash
   ./scripts/export_public.sh
   ```

4. Granska de uppdaterade filerna i:
   - `../kommandoraden-i-linux-pages-worktree`
   - `../the-linux-command-line-sv-private-source/out/public-release/kommandoraden-i-linux.pdf`
5. Checka in eventuella ändringar på `main`-grenen i det här publika arkivet.
6. Checka in den uppdaterade HTML-utmatningen på `pages`-grenen.
7. Skapa eller uppdatera en utgåva i det publika arkivet och ladda upp `../the-linux-command-line-sv-private-source/out/public-release/kommandoraden-i-linux.pdf` som PDF-artefakt.
8. Publicera eller pusha senare om du vill.

### Kontroller för öppen publicering

- Håll den publika HTML-utgåvan statisk och fri från JavaScript.
- Publicera inte externa runtime-resurser som CDN-hostade stilmallar, skript eller webbtypsnitt.
- Håll tredjepartsnotiserna uppdaterade i [`THIRD_PARTY.md`](THIRD_PARTY.md) när publiceringsresurser ändras.

### Kontroller för tillgänglighet och standarder

- Behandla den publika HTML-utgåvan som en utgåva som siktar på god praxis i nivå med `WCAG 2.2 AA`.
- Håll HTML-utgåvan användbar med tangentbord, med synliga fokusmarkeringar och en fungerande hoppa-till-innehållet-länk.
- Bevara stöd för minskad rörelse och undvik interaktion som kräver JavaScript.
- Kontrollera zoom och reflow på smala skärmar och vid hög zoom.
- Se till att länkar är visuellt tydliga utan att enbart förlita sig på färg.
- Granska alt-texter och bildtexter för figurer så att de beskriver innehållet i stället för att falla tillbaka på filnamn eller platshållartext.
- Validera strukturen i den genererade HTML-filen efter export när tema eller källmarkup ändras, till exempel:

  ```bash
  xmllint --html --noout ../kommandoraden-i-linux-pages-worktree/index.html
  ```

- Kör den automatiserade tillgänglighetskontrollen mot den exporterade Pages-utmatningen:

  ```bash
  ./scripts/check-pages-a11y.sh
  ```

- Gör återkommande manuella kontroller i webbläsare, med tangentbordsnavigering och med hjälpmedel när det är praktiskt möjligt.

### Säkerhetsregel

Kopiera inte in `book/`, `*.adoc`, översättningsanteckningar, ursprungsfiler eller QA-material i det publika arkivet.
