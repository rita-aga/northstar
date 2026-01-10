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
echo "[1/8] Creating directories..."
mkdir -p "$TARGET/.progress/templates"
mkdir -p "$TARGET/.progress/archive"
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.claude/hooks"
echo "  ✓ Directories created"

# Copy plan template
echo "[2/8] Installing plan template..."
cp "$SCRIPT_DIR/templates/.progress/templates/plan.md" "$TARGET/.progress/templates/"
echo "  ✓ Plan template installed"

# Copy commands
echo "[3/8] Installing commands..."
cp "$SCRIPT_DIR/templates/.claude/commands/remind.md" "$TARGET/.claude/commands/"
cp "$SCRIPT_DIR/templates/.claude/commands/no-cap.md" "$TARGET/.claude/commands/"
echo "  ✓ /remind and /no-cap commands installed"

# Copy hooks
echo "[4/8] Installing hooks..."
cp "$SCRIPT_DIR/templates/.claude/hooks/check-plan-reminder.sh" "$TARGET/.claude/hooks/"
cp "$SCRIPT_DIR/templates/.claude/hooks/pre-commit.sh" "$TARGET/.claude/hooks/"
cp "$SCRIPT_DIR/templates/.claude/hooks/pre-push-review.sh" "$TARGET/.claude/hooks/"
chmod +x "$TARGET/.claude/hooks/"*.sh
echo "  ✓ Hooks installed"

# Handle settings.json
echo "[5/8] Configuring hooks..."
if [ -f "$TARGET/.claude/settings.json" ]; then
    echo "  ⚠️  .claude/settings.json exists"
    echo "  Manual merge may be needed. Reference:"
    echo "  $SCRIPT_DIR/templates/.claude/settings.json"
else
    cp "$SCRIPT_DIR/templates/.claude/settings.json" "$TARGET/.claude/"
    echo "  ✓ Hook configuration installed"
fi

# Add workflow instructions to CLAUDE.md
echo "[6/8] Adding workflow to CLAUDE.md..."
if [ -f "$TARGET/CLAUDE.md" ]; then
    # Check if workflow section already exists
    if grep -q "Development Workflow (Northstar)" "$TARGET/CLAUDE.md"; then
        echo "  ⚠️  Workflow section already exists in CLAUDE.md"
    else
        # Append the snippet
        echo "" >> "$TARGET/CLAUDE.md"
        cat "$SCRIPT_DIR/global/CLAUDE.md.snippet" >> "$TARGET/CLAUDE.md"
        echo "  ✓ Workflow instructions added to CLAUDE.md"
    fi
else
    # Create CLAUDE.md with snippet
    echo "# CLAUDE.md" > "$TARGET/CLAUDE.md"
    echo "" >> "$TARGET/CLAUDE.md"
    echo "This file provides guidance to Claude Code when working with this repository." >> "$TARGET/CLAUDE.md"
    echo "" >> "$TARGET/CLAUDE.md"
    cat "$SCRIPT_DIR/global/CLAUDE.md.snippet" >> "$TARGET/CLAUDE.md"
    echo "  ✓ CLAUDE.md created with workflow instructions"
fi

# Vision directory
echo "[7/8] Vision documents..."
read -p "  Create .vision/ with templates? (y/n) " -n 1 -r INSTALL_VISION
echo ""
if [[ $INSTALL_VISION =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/.vision"
    cp "$SCRIPT_DIR/templates/.vision/CONSTRAINTS.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/NORTHSTAR.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/PHILOSOPHY.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/ARCHITECTURE.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/UX.md" "$TARGET/.vision/"
    cp "$SCRIPT_DIR/templates/.vision/STYLING.md" "$TARGET/.vision/"
    echo "  ✓ .vision/ created with all templates (including STYLING.md)"
fi

# GitHub Integration
echo "[8/8] GitHub integration..."
echo ""

# CI Workflows - Language Selection
echo "  Install CI workflow (lint/test/build)?"
echo "    1) Node.js / TypeScript (Bun)"
echo "    2) Python"
echo "    3) Go"
echo "    4) Rust"
echo "    5) Skip"
read -p "  Select [1-5]: " -n 1 -r CI_LANG
echo ""

CI_INSTALLED=""
if [[ $CI_LANG == "1" ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/ci-node.yml" "$TARGET/.github/workflows/ci.yml"
    CI_INSTALLED="Node.js"
    echo "  ✓ Node.js CI workflow installed"
elif [[ $CI_LANG == "2" ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/ci-python.yml" "$TARGET/.github/workflows/ci.yml"
    CI_INSTALLED="Python"
    echo "  ✓ Python CI workflow installed"
elif [[ $CI_LANG == "3" ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/ci-go.yml" "$TARGET/.github/workflows/ci.yml"
    CI_INSTALLED="Go"
    echo "  ✓ Go CI workflow installed"
elif [[ $CI_LANG == "4" ]]; then
    mkdir -p "$TARGET/.github/workflows"
    cp "$SCRIPT_DIR/templates/.github/workflows/ci-rust.yml" "$TARGET/.github/workflows/ci.yml"
    CI_INSTALLED="Rust"
    echo "  ✓ Rust CI workflow installed"
else
    echo "  Skipped CI workflow"
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
if [[ -n $CI_INSTALLED ]]; then
    echo "  .github/workflows/ci.yml       - $CI_INSTALLED CI workflow"
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
echo "  2. Start a task: Create .progress/001_YYYYMMDD_HHMMSS_task-name.md"
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
