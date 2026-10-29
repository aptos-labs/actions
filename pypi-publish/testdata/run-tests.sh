#!/usr/bin/env bash
# Local/CI checks for pypi-publish helpers and the default uv audit gate.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/pypi-publish/scripts/verify-pyproject-version.sh"
CLEAN="$ROOT/pypi-publish/testdata/clean"
CASES="$(mktemp -d)"
trap 'rm -rf "$CASES"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

pass() {
  echo "PASS: $*"
}

# --- version script -------------------------------------------------------

if ! (cd "$CLEAN" && EXPECTED=0.0.0 PACKAGE_PATH=pypi-publish/testdata/clean bash "$SCRIPT"); then
  fail "clean fixture version 0.0.0 should match"
fi
pass "clean fixture version matches"

if (cd "$CLEAN" && EXPECTED=9.9.9 PACKAGE_PATH=pypi-publish/testdata/clean bash "$SCRIPT") >/dev/null 2>&1; then
  fail "mismatched version should fail"
fi
pass "mismatched version fails"

mkdir -p "$CASES/empty"
if (cd "$CASES/empty" && EXPECTED=1.0.0 PACKAGE_PATH=missing bash "$SCRIPT") >/dev/null 2>&1; then
  fail "missing pyproject.toml should fail"
fi
pass "missing pyproject.toml fails"

mkdir -p "$CASES/noproject"
cat > "$CASES/noproject/pyproject.toml" <<'EOF'
[tool.poetry]
name = "x"
version = "1.0.0"
EOF
if (cd "$CASES/noproject" && EXPECTED=1.0.0 PACKAGE_PATH=noproject bash "$SCRIPT") >/dev/null 2>&1; then
  fail "poetry-only pyproject should fail"
fi
pass "missing [project] table fails"

mkdir -p "$CASES/dynamic"
cat > "$CASES/dynamic/pyproject.toml" <<'EOF'
[project]
name = "x"
dynamic = ["version"]
requires-python = ">=3.12"
EOF
if (cd "$CASES/dynamic" && EXPECTED=1.0.0 PACKAGE_PATH=dynamic bash "$SCRIPT") >/dev/null 2>&1; then
  fail "dynamic version should fail"
fi
pass "dynamic version fails"

mkdir -p "$CASES/ok"
cat > "$CASES/ok/pyproject.toml" <<'EOF'
[project]
name = "x"
version = "1.2.3-rc.1"
requires-python = ">=3.12"
EOF
if ! (cd "$CASES/ok" && EXPECTED=1.2.3-rc.1 PACKAGE_PATH=ok bash "$SCRIPT"); then
  fail "prerelease PEP 621 version should match"
fi
pass "prerelease version matches"

mkdir -p "$CASES/intver"
cat > "$CASES/intver/pyproject.toml" <<'EOF'
[project]
name = "x"
version = 1
requires-python = ">=3.12"
EOF
if (cd "$CASES/intver" && EXPECTED=1 PACKAGE_PATH=intver bash "$SCRIPT") >/dev/null 2>&1; then
  fail "integer [project].version should fail"
fi
pass "non-string [project].version fails"

# Default tag-pattern used by pypi-publish (must capture version, no leading v).
PATTERN='^v([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?)$'
assert_tag() {
  local tag="$1"
  local expected="$2"
  if [[ ! "$tag" =~ $PATTERN ]]; then
    fail "tag '$tag' should match default tag-pattern"
  fi
  if [ "${BASH_REMATCH[1]}" != "$expected" ]; then
    fail "tag '$tag' captured '${BASH_REMATCH[1]}', expected '$expected'"
  fi
}
assert_tag "v1.2.3" "1.2.3"
assert_tag "v1.2.3-rc.1" "1.2.3-rc.1"
if [[ "main" =~ $PATTERN ]]; then
  fail "branch name 'main' must not match default tag-pattern"
fi
if [[ "v1.2.3rc1" =~ $PATTERN ]]; then
  fail "PEP 440 'v1.2.3rc1' (no hyphen) is not in the default tag-pattern; callers must override"
fi
pass "default tag-pattern extracts versions and rejects non-tags"

# --- uv audit gate --------------------------------------------------------

if ! command -v uv >/dev/null 2>&1; then
  fail "uv is required on PATH"
fi

if ! (cd "$CLEAN" && uv lock --check && uv sync --locked && uv audit --locked); then
  fail "clean fixture must have a current lockfile and a clean uv audit"
fi
pass "clean fixture uv audit is clean"

VULN="$CASES/vuln"
mkdir -p "$VULN"
cat > "$VULN/pyproject.toml" <<'EOF'
[project]
name = "uv-audit-should-fail"
version = "0.0.0"
requires-python = ">=3.12"
dependencies = ["pyjwt==2.3.0"]

[tool.uv]
package = false
EOF

if ! (cd "$VULN" && uv lock >/dev/null); then
  fail "could not lock known-vulnerable pin pyjwt==2.3.0"
fi

set +e
(cd "$VULN" && uv audit --locked >/dev/null 2>&1)
status=$?
set -e
if [ "$status" -eq 0 ]; then
  fail "uv audit should fail on pyjwt==2.3.0"
fi
pass "uv audit fails on a known-vulnerable pin (exit $status)"

echo "All pypi-publish testdata checks passed."
