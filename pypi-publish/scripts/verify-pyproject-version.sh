#!/usr/bin/env bash
# Compare a static PEP 621 [project].version in pyproject.toml with the
# version extracted from the release tag. Dynamic versions are not supported.
#
# Usage (cwd must contain pyproject.toml):
#   EXPECTED=1.2.3 PACKAGE_PATH=. ./verify-pyproject-version.sh
#   ./verify-pyproject-version.sh 1.2.3
set -euo pipefail

EXPECTED="${1:-${EXPECTED:-}}"
PACKAGE_PATH="${PACKAGE_PATH:-.}"

if [ -z "$EXPECTED" ]; then
  echo "::error::Usage: verify-pyproject-version.sh <expected-version>"
  exit 1
fi

if [ ! -f pyproject.toml ]; then
  echo "::error::No pyproject.toml at '${PACKAGE_PATH}/pyproject.toml'"
  exit 1
fi

VERSION="$(python3 - <<'PY'
import pathlib
import sys
import tomllib

if sys.version_info < (3, 11):
    print(
        "::error::python3 3.11+ is required to read pyproject.toml (tomllib). "
        "Use a GitHub-hosted ubuntu runner.",
        file=sys.stderr,
    )
    sys.exit(1)

data = tomllib.loads(pathlib.Path("pyproject.toml").read_text())
project = data.get("project")
if not isinstance(project, dict):
    print(
        "::error::pyproject.toml is missing a [project] table; "
        "this action requires a static PEP 621 [project].version",
        file=sys.stderr,
    )
    sys.exit(1)

if "version" not in project:
    dynamic = project.get("dynamic") or []
    if isinstance(dynamic, list) and "version" in dynamic:
        print(
            "::error::pyproject.toml uses dynamic versioning; "
            "this action requires a static [project].version",
            file=sys.stderr,
        )
    else:
        print("::error::pyproject.toml [project].version is missing", file=sys.stderr)
    sys.exit(1)

version = project["version"]
if not isinstance(version, str) or not version.strip():
    print(
        "::error::pyproject.toml [project].version must be a non-empty string",
        file=sys.stderr,
    )
    sys.exit(1)
print(version)
PY
)"

if [ "$VERSION" != "$EXPECTED" ]; then
  echo "::error::pyproject.toml version ($VERSION) at ${PACKAGE_PATH}/ does not match tag version ($EXPECTED)"
  exit 1
fi

echo "pyproject.toml version $VERSION matches tag"
