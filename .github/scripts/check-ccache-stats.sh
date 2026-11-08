#!/usr/bin/env bash
# Validate ccache statistics collected since the last `ccache --zero-stats`
# and add them to the GitHub job summary.
# Usage: check-ccache-stats.sh <title> <expected hits> <expected misses>
set -euo pipefail

title=$1
expected_hits=$2
expected_misses=$3

stats=$(ccache --print-stats)
stat() {
    echo "$stats" | awk -v key="$1" '$1 == key { print $2; found = 1 } END { if (!found) print 0 }'
}

hits=$(( $(stat direct_cache_hit) + $(stat preprocessed_cache_hit) ))
misses=$(stat cache_miss)

echo "ccache hits:   ${hits} (expected ${expected_hits})"
echo "ccache misses: ${misses} (expected ${expected_misses})"

if [ "$hits" -eq "$expected_hits" ] && [ "$misses" -eq "$expected_misses" ]; then
    result="✅"
    ok=1
else
    result="❌"
    ok=0
fi

cat >> "${GITHUB_STEP_SUMMARY:-/dev/null}" <<EOF
### ${result} ccache: ${title}

| | Actual | Expected |
|---|---:|---:|
| Hits | ${hits} | ${expected_hits} |
| Misses | ${misses} | ${expected_misses} |

EOF

if [ "$ok" -ne 1 ]; then
    echo "::error::Unexpected ccache statistics: ${hits} hits, ${misses} misses (expected ${expected_hits} hits, ${expected_misses} misses)"
    exit 1
fi
