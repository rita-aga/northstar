# Northstar

A portable development workflow for disciplined, traceable development with AI assistants.

## What It Does

Northstar helps development agents (Claude, etc.) stay focused and build iteratively on solid foundations:

- **Plan before coding** - Create timestamped plans with options/decisions/trade-offs
- **Track progress** - State machine workflow prevents rushing
- **Verify quality** - Hooks check for placeholders, missing tests, debug statements
- **Auto-fix CI failures** - GitHub Action attempts to fix failing CI automatically

## Quick Start

```bash
# Install in your project
~/Development/northstar/setup.sh /path/to/your/project

# Test it works
/remind
```

## State Machine

```
GROUNDING → PLANNING → IMPLEMENTING → VERIFYING → COMPLETE
                           ↓              ↓
                       BLOCKED ←──────────┘
```

| State | What Happens | Gate to Exit |
|-------|--------------|--------------|
| GROUNDING | Read .vision/ docs (if they exist) | Understand context |
| PLANNING | Create plan in .progress/ | Plan file exists |
| IMPLEMENTING | Do the work, log decisions | Work complete |
| VERIFYING | Tests pass, /no-cap pass | All checks pass |
| COMPLETE | Commit and push | Done |

## Directory Structure

After installation, your project will have:

```
your-project/
├── .progress/
│   ├── templates/
│   │   └── plan.md           # Plan template
│   ├── archive/              # Completed plans
│   └── YYYYMMDD_task.md      # Active plans
├── .claude/
│   ├── commands/
│   │   ├── remind.md         # /remind command
│   │   └── no-cap.md         # /no-cap verification
│   ├── hooks/
│   │   ├── check-plan-reminder.sh
│   │   ├── pre-commit.sh
│   │   └── pre-push-review.sh
│   └── settings.json         # Hook configuration
├── .vision/                  # Optional - your north star
│   └── CONSTRAINTS.md        # Project constraints
└── .github/workflows/        # Optional - CI integration
    ├── review.yml            # Claude code review
    └── auto-fix-ci.yml       # Auto-fix failures
```

## Commands

| Command | What It Does |
|---------|--------------|
| `/remind` | Show workflow checklist |
| `/harness` | Invoke full workflow skill (if installed) |
| `/no-cap` | Verify no placeholders or hacks |

## What Northstar Enforces (Outcomes)

| Outcome | How |
|---------|-----|
| Decisions are traceable | Decision log in plan |
| No placeholders left | /no-cap verification |
| Vision alignment | Read whatever vision docs exist |
| Quality over speed | State machine prevents rushing |

## What Northstar Does NOT Prescribe

| Flexible | Why |
|----------|-----|
| Which vision files must exist | Projects vary |
| Testing framework | Agent chooses appropriate tools |
| Code patterns | Style is agent's choice |
| Plan detail level | Proportional to task size |

## Vision Documents (Optional)

The `.vision/` directory contains your project's north star - long-lived documents that guide development.

### Templates Included

| Template | Purpose | Type |
|----------|---------|------|
| `NORTHSTAR.md` | The ambitious goal - why this project exists | STABLE |
| `PHILOSOPHY.md` | Core beliefs and how we make decisions | STABLE |
| `CONSTRAINTS.md` | Non-negotiable rules and boundaries | STABLE |
| `ARCHITECTURE.md` | System design, components, decisions | EVOLVING |
| `UX.md` | Experience principles (CLI, API, or UI) | STABLE |

### Other Common Documents

| Document | When Useful |
|----------|-------------|
| `ROADMAP.md` | Project phases and milestones |
| `[domain].md` | Domain-specific guidance |

**Not every project needs all files.** Create what's helpful for your project.

## Plan Template

Plans include:
- **Vision Alignment** - What docs were read
- **Task Description** - What and why
- **Options & Decisions** - Trade-offs considered
- **Implementation Plan** - Phases with checkboxes
- **Checkpoints** - Gates before completion
- **Test Requirements** - What to test

## CI Integration

### Code Review (review.yml)

Triggered on PR:
- Runs tests and typecheck
- Claude reviews code for quality, security, test coverage
- Flags issues as CRITICAL, WARNING, or SUGGESTION

### Auto-Fix (auto-fix-ci.yml)

Triggered when CI fails:
- Fetches failure logs
- Attempts to identify and fix root cause
- Commits fix with `"fix: resolve CI failure [auto]"`
- If unfixable, creates GitHub issue

**Required GitHub Secret:** `ANTHROPIC_API_KEY`

## Global Claude Instructions

For workflow to apply to ALL projects, add to `~/.claude/CLAUDE.md`:

```bash
cat ~/Development/northstar/global/CLAUDE.md.snippet >> ~/.claude/CLAUDE.md
```

## Updating

To update an existing project to latest Northstar:

```bash
~/Development/northstar/setup.sh /path/to/your/project
# Will prompt before overwriting existing files
```

## Uninstalling

```bash
~/Development/northstar/uninstall.sh /path/to/your/project
```

Note: Your plans in `.progress/` and vision docs in `.vision/` are preserved.

## License

MIT
