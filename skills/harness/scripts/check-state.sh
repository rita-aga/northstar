#!/bin/bash
# Check if there's an active plan in the correct state
# Usage: ./check-state.sh [required_state]
# Returns 0 if check passes, 1 if it fails

set -e

REQUIRED_STATE="${1:-IMPLEMENTING}"
PROGRESS_DIR="${2:-.progress}"

# Find the most recent non-archived plan
PLAN=$(ls -t "$PROGRESS_DIR"/*.md 2>/dev/null | grep -v archive | grep -v templates | head -1)

if [ -z "$PLAN" ]; then
    echo "[HARNESS] No active plan found in $PROGRESS_DIR/"
    echo "[HARNESS] Create a plan before making changes: .progress/YYYYMMDD_HHMMSS_task-name.md"
    exit 1
fi

echo "[HARNESS] Found plan: $PLAN"

# Extract current state from plan
STATE=$(grep -oP '^\*\*State:\*\*\s*\K\w+' "$PLAN" 2>/dev/null || echo "UNKNOWN")

echo "[HARNESS] Current state: $STATE"

# Check if state allows the operation
case "$REQUIRED_STATE" in
    "IMPLEMENTING")
        if [ "$STATE" != "IMPLEMENTING" ] && [ "$STATE" != "PLANNING" ]; then
            echo "[HARNESS] Cannot proceed: Plan state is $STATE, expected PLANNING or IMPLEMENTING"
            echo "[HARNESS] Complete GROUNDING and PLANNING phases first"
            exit 1
        fi
        ;;
    "VERIFYING")
        if [ "$STATE" != "VERIFYING" ] && [ "$STATE" != "IMPLEMENTING" ]; then
            echo "[HARNESS] Cannot verify: Plan state is $STATE, expected IMPLEMENTING or VERIFYING"
            exit 1
        fi
        ;;
    "COMPLETE")
        if [ "$STATE" != "VERIFYING" ] && [ "$STATE" != "COMPLETE" ]; then
            echo "[HARNESS] Cannot complete: Plan state is $STATE, expected VERIFYING or COMPLETE"
            exit 1
        fi
        ;;
esac

echo "[HARNESS] State check passed"
exit 0
