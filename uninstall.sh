#!/bin/bash
# Northstar Uninstall
# Remove Northstar workflow from a project
# Usage: ./uninstall.sh [target-directory]

set -e

TARGET="${1:-.}"

# Resolve to absolute path
if [ ! -d "$TARGET" ]; then
    echo "Error: Target directory '$TARGET' does not exist"
    exit 1
fi
TARGET=$(cd "$TARGET" && pwd)

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║       Northstar Uninstall                ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Target: $TARGET"
echo ""

# Confirm
read -p "This will remove Northstar files. Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Removing Northstar files..."

# Remove hooks
if [ -f "$TARGET/.claude/hooks/check-plan-reminder.sh" ]; then
    rm "$TARGET/.claude/hooks/check-plan-reminder.sh"
    echo "  ✓ Removed check-plan-reminder.sh"
fi
if [ -f "$TARGET/.claude/hooks/pre-commit.sh" ]; then
    rm "$TARGET/.claude/hooks/pre-commit.sh"
    echo "  ✓ Removed pre-commit.sh"
fi
if [ -f "$TARGET/.claude/hooks/pre-push-review.sh" ]; then
    rm "$TARGET/.claude/hooks/pre-push-review.sh"
    echo "  ✓ Removed pre-push-review.sh"
fi

# Remove command
if [ -f "$TARGET/.claude/commands/remind.md" ]; then
    rm "$TARGET/.claude/commands/remind.md"
    echo "  ✓ Removed remind.md"
fi

# Remove plan template (keep existing plans)
if [ -f "$TARGET/.progress/templates/plan.md" ]; then
    rm "$TARGET/.progress/templates/plan.md"
    echo "  ✓ Removed plan template"
fi

# Remove CI workflows
if [ -f "$TARGET/.github/workflows/review.yml" ]; then
    rm "$TARGET/.github/workflows/review.yml"
    echo "  ✓ Removed review.yml"
fi
if [ -f "$TARGET/.github/workflows/auto-fix-ci.yml" ]; then
    rm "$TARGET/.github/workflows/auto-fix-ci.yml"
    echo "  ✓ Removed auto-fix-ci.yml"
fi

# Remove skills
if [ -d "$TARGET/skills/harness" ]; then
    rm -rf "$TARGET/skills/harness"
    echo "  ✓ Removed harness skill"
fi

echo ""
echo "NOTE: The following are NOT removed (may contain your data):"
echo "  - .claude/settings.json (may have other hooks)"
echo "  - .progress/*.md (your task plans)"
echo "  - .vision/*.md (your vision documents)"
echo ""
echo "Uninstall complete."
