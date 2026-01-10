#!/bin/bash
# Verify test gate for harness workflow
# Usage: ./verify-tests.sh [project_dir]
# Returns 0 if all gates pass, 1 if any fail

set -e

PROJECT_DIR="${1:-.}"
FAILED=0

echo "[GATE] Running verification checks..."

# 1. Tests must pass
if [ -f "$PROJECT_DIR/package.json" ]; then
    echo "[GATE] Running tests..."
    if cd "$PROJECT_DIR" && (bun test 2>/dev/null || npm test 2>/dev/null); then
        echo "[GATE] ✓ Tests passed"
    else
        echo "[GATE] ✗ Tests failed"
        FAILED=1
    fi
fi

# 2. Typecheck must pass (if TypeScript project)
if [ -f "$PROJECT_DIR/tsconfig.json" ]; then
    echo "[GATE] Running typecheck..."
    if cd "$PROJECT_DIR" && (bun run typecheck 2>/dev/null || npx tsc --noEmit 2>/dev/null); then
        echo "[GATE] ✓ Typecheck passed"
    else
        echo "[GATE] ✗ Typecheck failed"
        FAILED=1
    fi
fi

# 3. Check for console.log in production code
echo "[GATE] Checking for debug statements..."
CONSOLE_LOGS=$(find "$PROJECT_DIR/src" -name "*.ts" -o -name "*.tsx" 2>/dev/null | \
    xargs grep -l 'console.log' 2>/dev/null | \
    grep -v '.test.' | grep -v 'spec.' | grep -v '__tests__' || true)

if [ -n "$CONSOLE_LOGS" ]; then
    echo "[GATE] ⚠ console.log found in production files:"
    echo "$CONSOLE_LOGS"
    # Warning only, not failure
fi

# 4. Check for TODO/FIXME/HACK
echo "[GATE] Checking for placeholders..."
PLACEHOLDERS=$(find "$PROJECT_DIR/src" -name "*.ts" -o -name "*.tsx" 2>/dev/null | \
    xargs grep -l 'TODO\|FIXME\|HACK\|XXX' 2>/dev/null || true)

if [ -n "$PLACEHOLDERS" ]; then
    echo "[GATE] ⚠ Placeholders found in files:"
    echo "$PLACEHOLDERS"
    # Warning only, not failure (some TODOs are intentional)
fi

# Report results
echo ""
if [ $FAILED -eq 0 ]; then
    echo "[GATE] ✓ All verification gates passed"
    exit 0
else
    echo "[GATE] ✗ Verification failed - fix issues before completing"
    exit 1
fi
