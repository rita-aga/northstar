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
echo "[1/7] Creating directories..."
mkdir -p "$TARGET/.progress/templates"
mkdir -p "$TARGET/.progress/archive"
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.claude/hooks"
echo "  ✓ Directories created"

# Copy plan template
echo "[2/7] Installing plan template..."
cp "$SCRIPT_DIR/templates/.progress/templates/plan.md" "$TARGET/.progress/templates/"
echo "  ✓ Plan template installed"

# Copy commands
echo "[3/7] Installing commands..."
cp "$SCRIPT_DIR/templates/.claude/commands/remind.md" "$TARGET/.claude/commands/"
cp "$SCRIPT_DIR/templates/.claude/commands/no-cap.md" "$TARGET/.claude/commands/"
echo "  ✓ /remind and /no-cap commands installed"

# Copy hooks
echo "[4/7] Installing hooks..."
cp "$SCRIPT_DIR/templates/.claude/hooks/check-plan-reminder.sh" "$TARGET/.claude/hooks/"
cp "$SCRIPT_DIR/templates/.claude/hooks/pre-commit.sh" "$TARGET/.claude/hooks/"
cp "$SCRIPT_DIR/templates/.claude/hooks/pre-push-review.sh" "$TARGET/.claude/hooks/"
chmod +x "$TARGET/.claude/hooks/"*.sh
echo "  ✓ Hooks installed"

# Handle settings.json
echo "[5/7] Configuring hooks..."
if [ -f "$TARGET/.claude/settings.json" ]; then
    echo "  ⚠️  .claude/settings.json exists"
    echo "  Manual merge may be needed. Reference:"
    echo "  $SCRIPT_DIR/templates/.claude/settings.json"
else
    cp "$SCRIPT_DIR/templates/.claude/settings.json" "$TARGET/.claude/"
    echo "  ✓ Hook configuration installed"
fi

# Vision directory
echo "[6/7] Vision documents..."
read -p "  Create .vision/ with templates? (y/n) " -n 1 -r INSTALL_VISION
echo ""
if [[ $INSTALL_VISION =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.vision"
    cp "$SCRIPT_DIR/templates/.vision/CONSTRAINTS.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/NORTHSTAR.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/PHILOSOPHY.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/ARCHITECTURE.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/UX.md" "$TARGET/.vision/"
    echo "  ✓ .vision/ created with all templates"
fi

# GitHub Integration
echo "[7/7] GitHub integration..."
echo ""

# CI Workflows
read -p "  Install CI workflows (lint/test/build)? (y/n) " -n 1 -r INSTALL_CI
echo ""
if [[ $INSTALL_CI =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/ci.yml" "$TARGET/.github/workflows/"
    echo "  ✓ CI workflow installed (ci.yml)"
fi

# Claude Review & Auto-fix
read -p "  Install Claude code review & auto-fix? (y/n) " -n 1 -r INSTALL_REVIEW
echo ""
if [[ $INSTALL_REVIEW =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/review.yml" "$TARGET/.github/workflows/"
    cp "$SCRIPT_DIR/templates/.github/workflows/auto-fix-ci.yml" "$TARGET/.github/workflows/"
    echo "  ✓ Claude review & auto-fix installed"
    echo "  NOTE: Add ANTHROPIC_API_KEY to GitHub secrets"
fi

# Dependabot
read -p "  Install Dependabot (automated dependency updates)? (y/n) " -n 1 -r INSTALL_DEPENDABOT
echo ""
if [[ $INSTALL_DEPENDABOT =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/dependabot.yml" "$TARGET/.github/"
    cp "$SCRIPT_DIR/templates/.github/workflows/dependabot-auto-merge.yml" "$TARGET/.github/workflows/"
    echo "  ✓ Dependabot installed (uncomment relevant ecosystems in dependabot.yml)"
fi

# CodeQL Security Scanning
read -p "  Install CodeQL security scanning? (y/n) " -n 1 -r INSTALL_CODEQL
echo ""
if [[ $INSTALL_CODEQL =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/codeql.yml" "$TARGET/.github/workflows/"
    echo "  ✓ CodeQL installed (configure languages in codeql.yml)"
fi

# PR & Issue Templates
read -p "  Install PR & issue templates? (y/n) " -n 1 -r INSTALL_TEMPLATES
echo ""
if [[ $INSTALL_TEMPLATES =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.github/ISSUE_TEMPLATE"
    cp "$SCRIPT_DIR/templates/.github/PULL_REQUEST_TEMPLATE.md" "$TARGET/.github/"
    cp "$SCRIPT_DIR/templates/.github/ISSUE_TEMPLATE/bug_report.yml" "$TARGET/.github/ISSUE_TEMPLATE/"
    cp "$SCRIPT_DIR/templates/.github/ISSUE_TEMPLATE/feature_request.yml" "$TARGET/.github/ISSUE_TEMPLATE/"
    cp "$SCRIPT_DIR/templates/.github/ISSUE_TEMPLATE/config.yml" "$TARGET/.github/ISSUE_TEMPLATE/"
    echo "  ✓ PR & issue templates installed"
fi

# Harness Skill (optional)
read -p "  Install /harness skill (advanced)? (y/n) " -n 1 -r INSTALL_SKILLS
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
if [[ $INSTALL_VISION =~ ^[Yy]$ ]]; then
    echo "  .vision/*.md                   - Vision document templates"
fi
if [[ $INSTALL_CI =~ ^[Yy]$ ]]; then
    echo "  .github/workflows/ci.yml       - Lint/test/build workflow"
fi
if [[ $INSTALL_REVIEW =~ ^[Yy]$ ]]; then
    echo "  .github/workflows/review.yml   - Claude code review"
    echo "  .github/workflows/auto-fix-ci.yml - Auto-fix CI failures"
fi
if [[ $INSTALL_DEPENDABOT =~ ^[Yy]$ ]]; then
    echo "  .github/dependabot.yml         - Dependency updates"
    echo "  .github/workflows/dependabot-auto-merge.yml"
fi
if [[ $INSTALL_CODEQL =~ ^[Yy]$ ]]; then
    echo "  .github/workflows/codeql.yml   - Security scanning"
fi
if [[ $INSTALL_TEMPLATES =~ ^[Yy]$ ]]; then
    echo "  .github/PULL_REQUEST_TEMPLATE.md"
    echo "  .github/ISSUE_TEMPLATE/*.yml   - Issue templates"
fi
if [[ $INSTALL_SKILLS =~ ^[Yy]$ ]]; then
    echo "  skills/harness/                - /harness skill"
fi
echo ""
echo "Next steps:"
echo "  1. Test with: /remind"
echo "  2. Start a task: Create .progress/YYYYMMDD_HHMMSS_task-name.md"
if [[ $INSTALL_VISION =~ ^[Yy]$ ]]; then
    echo "  3. Fill in vision docs in .vision/"
fi
if [[ $INSTALL_REVIEW =~ ^[Yy]$ ]]; then
    echo "  4. Add ANTHROPIC_API_KEY to GitHub secrets"
fi
if [[ $INSTALL_DEPENDABOT =~ ^[Yy]$ ]]; then
    echo "  5. Edit .github/dependabot.yml - uncomment your language"
fi
if [[ $INSTALL_CODEQL =~ ^[Yy]$ ]]; then
    echo "  6. Edit .github/workflows/codeql.yml - set your languages"
fi
echo ""
