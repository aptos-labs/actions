## Description

Publishes a Python package to PyPI using OIDC trusted publishing — no
PYPI_API_TOKEN required. After install, the action runs `uv audit --locked`
so a release cannot ship with known lockfile advisories. Set
`audit-command` to empty to skip.

Requires `actions/checkout` to have run earlier in the same job, and the
calling job must declare `permissions: { id-token: write }` so OIDC tokens
can be minted. The project's trusted publisher on PyPI should point at the
caller's repository and workflow filename (NOT this action), so each
consuming package configures its own per-package trust relationship.

Why composite, not a reusable workflow: with a reusable workflow, GitHub's
OIDC token reports `job_workflow_ref` as the *called* workflow's file in
this repo. PyPI's trusted publisher would then need to match
`aptos-labs/actions` + that workflow, and every consuming package would
share the same trust subject. With a composite action, `job_workflow_ref`
stays as the *caller's* workflow.

PyPI has no npm-style dist-tag. Protection against accidental production
uploads belongs on the caller's GitHub Environment (the python-sdk uses
`environment: pypi`). Point `repository-url` at TestPyPI when you want a
non-production index.

Monorepo / subpackage support:
  Set `package-path` to the directory holding the package's pyproject.toml
  and `tag-pattern` to a regex whose first capture group is the version.
  `package-path` is the single cwd for the version check, all commands
  (install/audit/build/test/lint), and the built `dist/` that is uploaded.

  Example for a nested package:

    - uses: aptos-labs/actions/pypi-publish@main
      with:
        package-path: packages/foo
        tag-pattern: '^foo-v([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?)$'

Requires a static PEP 621 `[project].version` (dynamic versions are
rejected) and a committed `uv.lock` for the default install/audit
commands. `uv audit` needs uv 0.12+ (`uv-version`, or
`tool.uv.required-version` in pyproject.toml).

Known-advisory call-out: `aptos-labs/aptos-python-sdk` currently fails a
default `uv audit --locked` on transitive `ecdsa` CVE-2024-23342 (no fix
version). Adopters with unfixed findings must ignore specific IDs, clean
the tree, or set `audit-command: ""` until the advisory is gone.


## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| package-path | Directory containing the package's pyproject.toml. The single cwd for the version check, all commands (install/audit/lint/build/test), and the built dist/ uploaded to PyPI. Defaults to repo root. | `false` | . |
| python-version | Python version to install. Must satisfy the package's requires-python. | `false` | 3.12 |
| uv-version | Pin uv to a specific version for reproducibility. Empty (default) lets astral-sh/setup-uv use tool.uv.required-version from pyproject.toml, then the latest uv. uv 0.12+ is required for the default `uv audit` command. | `false` |  |
| install-command | Command to install dependencies from the committed lockfile. | `false` | uv sync --locked |
| audit-command | Command to audit the locked dependency graph after install. Empty string skips. Defaults to `uv audit --locked` so publishes fail on known advisories; set to empty to skip. | `false` | uv audit --locked |
| build-command | Command to build sdist/wheel into dist/. | `false` | uv build |
| test-command | Command to run tests. Empty string skips. Default is empty because Python test runners vary (unittest, pytest, behave). | `false` |  |
| lint-command | Lint/check command. Empty string skips. | `false` |  |
| safe-chain | Install Aikido Safe Chain (malware proxy) before installing dependencies. String `true`/`false`. | `false` | true |
| tag-pattern | Regex the release tag must match. The first capture group MUST capture the version (no leading `v`). Default matches `vMAJOR.MINOR.PATCH[-prerelease]`. | `false` | ^v([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?)$ |
| repository-url | PEP 503 upload endpoint. Default is production PyPI. Set to `https://test.pypi.org/legacy/` for TestPyPI. | `false` | https://upload.pypi.org/legacy/ |
| skip-existing | Do not fail if this version's distributions already exist on the index. String `true`/`false`. | `false` | false |


## Outputs

| parameter | description |
| --- | --- |
| version | The version that was published (extracted from the tag, no `v` prefix). |


## Runs

This action is a `composite` action.


