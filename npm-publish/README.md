## Description

Publishes an npm package using OIDC trusted publishing — no NPM_TOKEN
required. By default CI never auto-publishes to `latest`; stable releases
land on the `staged` dist-tag and you promote them manually with
`npm dist-tag add <pkg>@<version> latest`.

Requires `actions/checkout` to have run earlier in the same job, and the
calling job must declare `permissions: { id-token: write }` so OIDC tokens
can be minted. The package's trusted publisher on npmjs.com should point
at the caller's repository and workflow filename (NOT this action), so
each consuming package configures its own per-package trust relationship.

How the dist-tag is computed:
  v4.1.0          -> <stable-dist-tag>  (default: staged)
  v4.1.0-beta.1   -> beta
  v5.0.0-rc.2     -> rc
  v4.1.0-next.3   -> next
Prereleases (tags with a `-suffix`) always derive their dist-tag from
the suffix; `stable-dist-tag` does not apply.

Encodes two non-obvious requirements: do not pass `registry-url` to
setup-node (it writes an .npmrc that overrides OIDC auth and fails the
publish with a misleading 404), and pin Node 24+ so npm 11.5.1+ is
available (only npm 11+ authenticates publishes via OIDC; npm 10 only
signs provenance).


## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| stable-dist-tag | npm dist-tag for stable releases. Defaults to `staged` to block auto-publish to `latest`; set to `latest` only as an explicit override. | `false` | staged |
| node-version | Node.js version. Must be 24+ for npm 11+ which supports OIDC publish auth. | `false` | 24 |
| install-command | Command to install dependencies. | `false` | pnpm install --frozen-lockfile |
| build-command | Command to build the package. | `false` | pnpm build |
| test-command | Command to run tests. Empty string skips. | `false` | pnpm test |
| lint-command | Lint/check command. Empty string skips. | `false` |  |
| typecheck-command | Typecheck command. Empty string skips. | `false` |  |
| required-declaration-files | Newline-separated list of .d.ts files that must exist after build. Empty skips check. | `false` |  |
| safe-chain | Install Aikido Safe Chain (malware proxy) before publishing. String `true`/`false`. | `false` | true |
| tag-pattern | Regex the release tag must match. | `false` | ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ |


## Outputs

| parameter | description |
| --- | --- |
| version | The version that was published (no `v` prefix). |
| dist-tag | The npm dist-tag the version was published under. |


## Runs

This action is a `composite` action.


