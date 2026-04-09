# Build Tools

These files mirror the build and publication tooling used in the private source workspace.

They are published for transparency and reuse, but they are not sufficient to rebuild the Swedish edition from this public repository because:

- the AsciiDoc translation source is private
- the original source inputs are private
- the dedicated PDF font directory is not mirrored here; the public repo only includes the self-hosted HTML font assets needed for the reading edition, while the private source workspace remains authoritative for the PDF build

The custom HTML stylesheet used for the public reading edition is included under `build-tools/site/`.
The published HTML edition is static, does not ship JavaScript, and uses self-hosted libre webfonts.
