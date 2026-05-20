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
  1.2.3           -> <stable-dist-tag>  (default: staged)
  1.2.3-beta.1    -> beta
  1.2.3-rc.2      -> rc
  1.2.3-next.3    -> next
Prerelease detection looks at the extracted *version*, not the raw tag,
so monorepo-style tag prefixes don't false-positive on the `@` or `/`.
Prereleases derive their dist-tag from the suffix; `stable-dist-tag`
doesn't apply.

Monorepo / subpackage support:
  Set `package-path` to the directory holding the package's package.json,
  and `tag-pattern` to a regex whose first capture group is the version.
  Example for an `aptos-ts-sdk` subpackage:

    - uses: aptos-labs/actions/npm-publish@main
      with:
        package-path: packages/confidential-assets
        tag-pattern: '^@aptos-labs/confidential-assets@([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?)$'
        build-command: pnpm --filter @aptos-labs/confidential-assets build
        test-command:  pnpm --filter @aptos-labs/confidential-assets test

  `package-path` only affects the package.json version check and the
  final `npm publish` cwd. Build/test/install commands run from the repo
  root so monorepo filters (pnpm/turbo/nx) keep working as you'd expect.

Encodes two non-obvious requirements: do not pass `registry-url` to
setup-node (it writes an .npmrc that overrides OIDC auth and fails the
publish with a misleading 404), and pin Node 24+ so npm 11.5.1+ is
available (only npm 11+ authenticates publishes via OIDC; npm 10 only
signs provenance).


## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| package-path | Directory containing the package's package.json. Use for monorepo subpackages. The package.json version check and `npm publish` run from here; build/test/install commands still run from the repo root. | `false` | . |
| stable-dist-tag | npm dist-tag for stable releases. Defaults to `staged` to block auto-publish to `latest`; set to `latest` only as an explicit override. | `false` | staged |
| node-version | Node.js version. Must be 24+ for npm 11+ which supports OIDC publish auth. | `false` | 24 |
| install-command | Command to install dependencies. | `false` | pnpm install --frozen-lockfile |
| build-command | Command to build the package. | `false` | pnpm build |
| test-command | Command to run tests. Empty string skips. | `false` | pnpm test |
| lint-command | Lint/check command. Empty string skips. | `false` |  |
| typecheck-command | Typecheck command. Empty string skips. | `false` |  |
| required-declaration-files | Newline-separated list of .d.ts files that must exist after build. Empty skips check. | `false` |  |
| safe-chain | Install Aikido Safe Chain (malware proxy) before publishing. String `true`/`false`. | `false` | true |
| tag-pattern | Regex the release tag must match. The first capture group MUST capture the version (no leading `v`). Default matches `vMAJOR.MINOR.PATCH[-prerelease]`. For monorepo packages, override with something like `^@scope/pkg@([0-9]+\.[0-9]+\.[0-9]+(-.+)?)$`. | `false` | ^v([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?)$ |


## Outputs

| parameter | description |
| --- | --- |
| version | The version that was published (extracted from the tag, no `v` prefix). |
| dist-tag | The npm dist-tag the version was published under. |


## Runs

This action is a `composite` action.


