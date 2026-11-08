#!/usr/bin/env bash
# Add cmake, ccache and compiler versions to the GitHub job summary.
# Compiler information is taken from the CMake File API toolchains reply,
# i.e. the compiler actually selected by the generator / toolset.
# The query file <build dir>/.cmake/api/v1/query/toolchains-v1 must exist before configuring.
# Usage: environment-summary.sh <build dir>
set -euo pipefail

build_dir=$1

row() {
    echo "| $1 | $2 | \`$3\` |"
}

{
    echo "### Environment"
    echo
    echo "| Tool | Version | Path |"
    echo "|---|---|---|"
    row cmake  "$(cmake --version | head -n 1 | sed 's/^cmake version //')"  "$(command -v cmake)"
    row ccache "$(ccache --version | head -n 1 | sed 's/^ccache version //')" "$(command -v ccache)"
    reply=$(ls "$build_dir"/.cmake/api/v1/reply/toolchains-v1-*.json 2>/dev/null | head -n 1 || true)
    if [ -n "$reply" ]; then
        jq -r '.toolchains[] | "| \(.language) compiler | \(.compiler.id // "") \(.compiler.version // "") | `\(.compiler.path // "")` |"' "$reply" | tr -d '\r'
    fi
    echo
} >> "${GITHUB_STEP_SUMMARY:-/dev/stdout}"
