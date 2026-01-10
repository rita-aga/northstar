#!/bin/bash
# Northstar Pre-Push Review Hook
# Reviews changes before pushing to remote

BASE=${1:-main}
BRANCH=$(git branch --show-current)
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
PROGRESS_DIR="$REPO_ROOT/.progress"

echo "[REVIEW] Reviewing $BASE..$BRANCH"
echo ""

# 1. Check plan state
PLAN=$(ls -t "$PROGRESS_DIR"/*.md 2>/dev/null | grep -v archive | grep -v templates | head -1)
if [ -n "$PLAN" ]; then
    STATE=$(grep -oP '^\*\*State:\*\*\s*\K\w+' "$PLAN" 2>/dev/null || grep -oE 'State:\s*\w+' "$PLAN" 2>/dev/null | head -1 | sed 's/State:\s*//')
    echo "[REVIEW] Current plan: $(basename "$PLAN")"
    echo "[REVIEW] Plan state: ${STATE:-UNKNOWN}"

    if [ "$STATE" != "VERIFYING" ] && [ "$STATE" != "COMPLETE" ]; then
        echo "[REVIEW] WARNING: Plan not in VERIFYING or COMPLETE state"
    fi
else
    echo "[REVIEW] NOTE: No active plan found"
fi
echo ""

# 2. Get diff for analysis
DIFF=$(git diff "$BASE"..."$BRANCH" 2>/dev/null || git diff HEAD~5..HEAD)

# 3. Count new TODOs
NEW_TODOS=$(echo "$DIFF" | grep -c '^\+.*TODO' 2>/dev/null || echo "0")
NEW_FIXMES=$(echo "$DIFF" | grep -c '^\+.*FIXME' 2>/dev/null || echo "0")

echo "[REVIEW] New placeholders:"
echo "  TODOs: $NEW_TODOS"
echo "  FIXMEs: $NEW_FIXMES"

if [ "$NEW_TODOS" -gt 0 ] || [ "$NEW_FIXMES" -gt 0 ]; then
    echo "[REVIEW] WARNING: New placeholders added - consider resolving before push"
fi
echo ""

# 4. Check if vision files modified
if echo "$DIFF" | grep -q '^diff.*\.vision/'; then
    echo "[REVIEW] WARNING: .vision/ files modified"
    echo "[REVIEW] These are long-lived documents - verify changes are intentional"
fi

# 5. List changed files
CHANGED_FILES=$(git diff --name-only "$BASE"..."$BRANCH" 2>/dev/null || git diff --name-only HEAD~5..HEAD)
FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')

echo "[REVIEW] Files changed: $FILE_COUNT"
echo "$CHANGED_FILES" | head -20
if [ "$FILE_COUNT" -gt 20 ]; then
    echo "  ... and $((FILE_COUNT - 20)) more"
fi
echo ""

# 6. Check for large additions
ADDITIONS=$(git diff --stat "$BASE"..."$BRANCH" 2>/dev/null | tail -1 || echo "")
echo "[REVIEW] Change summary: $ADDITIONS"
echo ""

# 7. Summary
echo "[REVIEW] Pre-push review complete"
echo ""
echo "Remember:"
echo "  - Run tests locally before pushing"
echo "  - CI will run automatically after push"
echo "  - If CI fails, fix locally and push again"
