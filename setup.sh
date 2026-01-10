#!/bin/bash
# Northstar Setup
# Install disciplined development workflow into any project
# Usage: ./setup.sh [target-directory]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-.}"

# Resolve to absolute path
if [ ! -d "$TARGET" ]; then
    echo "Error: Target directory '$TARGET' does not exist"
    exit 1
fi
TARGET=$(cd "$TARGET" && pwd)

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║       Northstar Installation             ║"
echo "╠══════════════════════════════════════════╣"
echo "║  Disciplined development workflow        ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Target: $TARGET"
echo ""

# Create directories
echo "[1/6] Creating directories..."
mkdir -p "$TARGET/.progress/templates"
mkdir -p "$TARGET/.progress/archive"
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.claude/hooks"
echo "  ✓ Directories created"

# Copy plan template
echo "[2/6] Installing plan template..."
cp "$SCRIPT_DIR/templates/.progress/templates/plan.md" "$TARGET/.progress/templates/"
echo "  ✓ Plan template installed"

# Copy commands
echo "[3/6] Installing commands..."
cp "$SCRIPT_DIR/templates/.claude/commands/remind.md" "$TARGET/.claude/commands/"
cp "$SCRIPT_DIR/templates/.claude/commands/no-cap.md" "$TARGET/.claude/commands/"
echo "  ✓ /remind and /no-cap commands installed"

# Copy hooks
echo "[4/6] Installing hooks..."
cp "$SCRIPT_DIR/templates/.claude/hooks/check-plan-reminder.sh" "$TARGET/.claude/hooks/"
cp "$SCRIPT_DIR/templates/.claude/hooks/pre-commit.sh" "$TARGET/.claude/hooks/"
cp "$SCRIPT_DIR/templates/.claude/hooks/pre-push-review.sh" "$TARGET/.claude/hooks/"
chmod +x "$TARGET/.claude/hooks/"*.sh
echo "  ✓ Hooks installed"

# Handle settings.json
echo "[5/6] Configuring hooks..."
if [ -f "$TARGET/.claude/settings.json" ]; then
    echo "  ⚠️  .claude/settings.json exists"
    echo "  Manual merge may be needed. Reference:"
    echo "  $SCRIPT_DIR/templates/.claude/settings.json"
else
    cp "$SCRIPT_DIR/templates/.claude/settings.json" "$TARGET/.claude/"
    echo "  ✓ Hook configuration installed"
fi

# Optional components
echo "[6/6] Optional components..."
echo ""

# CI Workflow
read -p "  Install GitHub Actions CI workflow? (y/n) " -n 1 -r INSTALL_CI
echo ""
if [[ $INSTALL_CI =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/review.yml" "$TARGET/.github/workflows/"
    cp "$SCRIPT_DIR/templates/.github/workflows/auto-fix-ci.yml" "$TARGET/.github/workflows/"
    echo "  ✓ CI workflows installed"
    echo "  NOTE: Add ANTHROPIC_API_KEY to GitHub secrets"
fi

# Vision directory
read -p "  Create .vision/ with CONSTRAINTS template? (y/n) " -n 1 -r INSTALL_VISION
echo ""
if [[ $INSTALL_VISION =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.vision"
    cp "$SCRIPT_DIR/templates/.vision/CONSTRAINTS.md" "$TARGET/.vision/"
    echo "  ✓ .vision/ created with CONSTRAINTS template"
fi

# Skills (for projects that use Letta/skills)
read -p "  Install /harness skill? (y/n) " -n 1 -r INSTALL_SKILLS
echo ""
if [[ $INSTALL_SKILLS =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/skills/harness/templates"
    mkdir -p "$TARGET/skills/harness/scripts"
    cp "$SCRIPT_DIR/skills/harness/SKILL.md" "$TARGET/skills/harness/"
    cp "$SCRIPT_DIR/skills/harness/templates/plan.md" "$TARGET/skills/harness/templates/"
    cp "$SCRIPT_DIR/skills/harness/scripts/"*.sh "$TARGET/skills/harness/scripts/" 2>/dev/null || true
    chmod +x "$TARGET/skills/harness/scripts/"*.sh 2>/dev/null || true
    echo "  ✓ /harness skill installed"
fi

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║       Installation Complete!             ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "What's installed:"
echo "  .progress/templates/plan.md    - Task plan template"
echo "  .claude/commands/remind.md     - /remind command"
echo "  .claude/commands/no-cap.md     - /no-cap verification command"
echo "  .claude/hooks/*.sh             - Pre-commit and reminder hooks"
echo "  .claude/settings.json          - Hook configuration"
if [[ $INSTALL_CI =~ ^[Yy]$ ]]; then
    echo "  .github/workflows/*.yml        - CI review and auto-fix"
fi
if [[ $INSTALL_VISION =~ ^[Yy]$ ]]; then
    echo "  .vision/CONSTRAINTS.md         - Project constraints template"
fi
if [[ $INSTALL_SKILLS =~ ^[Yy]$ ]]; then
    echo "  skills/harness/                - /harness skill"
fi
echo ""
echo "Next steps:"
echo "  1. Test with: /remind"
echo "  2. Start a task: Create .progress/YYYYMMDD_HHMMSS_task-name.md"
echo "  3. Optional: Add vision docs to .vision/"
echo ""
