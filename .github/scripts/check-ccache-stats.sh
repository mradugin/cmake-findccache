#!/usr/bin/env bash
# Validate ccache statistics collected since the last `ccache --zero-stats`.
# Usage: check-ccache-stats.sh <expected hits> <expected misses>
set -euo pipefail

expected_hits=$1
expected_misses=$2

stats=$(ccache --print-stats)
stat() {
    echo "$stats" | awk -v key="$1" '$1 == key { print $2; found = 1 } END { if (!found) print 0 }'
}

hits=$(( $(stat direct_cache_hit) + $(stat preprocessed_cache_hit) ))
misses=$(stat cache_miss)

echo "ccache hits:   ${hits} (expected ${expected_hits})"
echo "ccache misses: ${misses} (expected ${expected_misses})"

if [ "$hits" -ne "$expected_hits" ] || [ "$misses" -ne "$expected_misses" ]; then
    echo "::error::Unexpected ccache statistics: ${hits} hits, ${misses} misses (expected ${expected_hits} hits, ${expected_misses} misses)"
    exit 1
fi
