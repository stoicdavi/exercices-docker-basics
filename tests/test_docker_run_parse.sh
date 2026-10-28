#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/docker_run_parse.sh
source "$REPO_ROOT/tests/lib/docker_run_parse.sh"

assert_equal() {
  if [ "$1" != "$2" ]; then
    printf 'FAIL: expected <%s>, got <%s>\n' "$1" "$2"
    exit 1
  fi
}

assert_equal "" "$(docker_run_env_flags 'docker run -p 5001:5001 frontend')"
assert_equal 'REQUEST_ORIGIN=http://localhost:5001' \
  "$(docker_run_env_flags 'docker run -d -e REQUEST_ORIGIN=http://localhost:5001 -p 8080:8080 backend')"
assert_equal $'FIRST=one\nSECOND=two\nTHIRD=three\nINHERITED\nEMPTY=' \
  "$(docker_run_env_flags 'docker run -e FIRST=one --env SECOND=two --env=THIRD=three -e INHERITED -e EMPTY= backend')"
assert_equal $'FIRST=one\nSECOND=two' \
  "$(docker_run_env_flags "docker run -e 'FIRST=one' --env=\"SECOND=two\" backend")"
assert_equal 'BEFORE=yes' \
  "$(docker_run_env_flags 'docker run --name example -v /tmp:/data -e BEFORE=yes backend -e AFTER=no')"
assert_equal "" "$(docker_run_env_flags 'docker run backend --env=AFTER=no')"
assert_equal $'backend\t8080:8080\t0' \
  "$(docker_run_parse 'docker run -e REQUEST_ORIGIN=http://localhost:5001 -p 8080:8080 backend -p 9000:9000')"
assert_equal $'frontend\t\t1' "$(docker_run_parse 'docker run -P frontend')"

echo "All parser tests passed"
