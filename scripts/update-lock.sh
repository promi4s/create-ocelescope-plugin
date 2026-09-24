#!/usr/bin/env bash
# Regenerates template/uv.lock.jinja and template/requirements.txt.jinja.
#
# Usage:
#   scripts/update-lock.sh                                # upgrade all dependencies
#   scripts/update-lock.sh --upgrade-package ocelescope   # only upgrade ocelescope
#   scripts/update-lock.sh --no-upgrade                   # just re-resolve (e.g. after editing pyproject.toml.jinja)
set -euo pipefail

cd "$(dirname "$0")/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

args=("$@")
if [[ ${#args[@]} -eq 0 ]]; then
  args=(--upgrade)
elif [[ ${args[0]} == --no-upgrade ]]; then
  args=("${args[@]:1}")
fi

# Render a throwaway plugin whose project name is "plugin-template"
uvx copier copy --quiet --defaults --data plugin_label="Plugin Template" . "$tmp/plugin"

cd "$tmp/plugin"
uv lock "${args[@]}"
uv export --format requirements.txt --output-file requirements.txt --quiet
cd - >/dev/null

# Copy back, turning the project name into the template variable again
sed 's/^name = "plugin-template"$/name = "{{ project_name }}"/' \
  "$tmp/plugin/uv.lock" >template/uv.lock.jinja
sed 's/# via plugin-template$/# via {{ project_name }}/' \
  "$tmp/plugin/requirements.txt" >template/requirements.txt.jinja

echo "Updated template/uv.lock.jinja and template/requirements.txt.jinja"
git --no-pager diff --stat -- template/uv.lock.jinja template/requirements.txt.jinja
